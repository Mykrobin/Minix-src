/* This file contains a standard driver for audio devices.
 * It supports double dma buffering and can be configured to use
 * extra buffer space beside the dma buffer.
 * This driver also support sub devices, which can be independently 
 * opened and closed.   
 *
 * The driver supports the following operations:
 *
 *    m_type      DEVICE    PROC_NR     COUNT    POSITION  ADRRESS
 * -----------------------------------------------------------------
 * |  DEV_OPEN   | device  | proc nr |         |         |         |
 * |-------------+---------+---------+---------+---------+---------|
 * |  DEV_CLOSE  | device  | proc nr |         |         |         |
 * |-------------+---------+---------+---------+---------+---------|
 * |  DEV_READ   | device  | proc nr |  bytes  |         | buf ptr |
 * |-------------+---------+---------+---------+---------+---------|
 * |  DEV_WRITE  | device  | proc nr |  bytes  |         | buf ptr |
 * |-------------+---------+---------+---------+---------+---------|
 * |  DEV_IOCTL  | device  | proc nr |func code|         | buf ptr |
 * |-------------+---------+---------+---------+---------+---------|
 * |  DEV_STATUS |         |         |         |         |         |
 * |-------------+---------+---------+---------+---------+---------|
 * |  HARD_INT   |         |         |         |         |         | 
 * |-------------+---------+---------+---------+---------+---------|
 * |  SIG_STOP   |         |         |         |         |         | 
 * ----------------------------------------------------------------- 
 * 
 * The file contains one entry point:
 *
 *   main:	main entry when driver is brought up
 *	
 *  February 2006   Updated audio framework, changed driver-framework relation (Peter Boonstoppel)
 *  November 2005   Created generic DMA driver framework (Laurens Bronwasser)
 *  August 24 2005  Ported audio driver to user space (only audio playback) (Peter Boonstoppel)
 *  May 20 1995	    SB16 Driver: Michel R. Prevenier 
 */
 
#include "audio_fw.h"

FORWARD _PROTOTYPE( int msg_open, (int minor_dev_nr) );
FORWARD _PROTOTYPE( int msg_close, (int minor_dev_nr) );
FORWARD _PROTOTYPE( int msg_ioctl, (message *m_ptr) );
FORWARD _PROTOTYPE( void msg_write, (message *m_ptr) );
FORWARD _PROTOTYPE( void msg_read, (message *m_ptr) );
FORWARD _PROTOTYPE( void msg_hardware, (void) );
FORWARD _PROTOTYPE( void msg_sig_stop, (void) );
FORWARD _PROTOTYPE( void msg_status, (message *m_ptr) );
FORWARD _PROTOTYPE( int init_driver, (void) );
FORWARD _PROTOTYPE( int open_sub_dev, (int sub_dev_nr, int operation) );
FORWARD _PROTOTYPE( int close_sub_dev, (int sub_dev_nr) );
FORWARD _PROTOTYPE( void handle_int_write,(int sub_dev_nr) );
FORWARD _PROTOTYPE( void handle_int_read,(int sub_dev_nr) );
FORWARD _PROTOTYPE( void data_to_user, (sub_dev_t *sub_dev_ptr) );
FORWARD _PROTOTYPE( void data_from_user, (sub_dev_t *sub_dev_ptr) );
FORWARD _PROTOTYPE( int init_buffers, (sub_dev_t *sub_dev_ptr) );
FORWARD _PROTOTYPE( int get_started, (sub_dev_t *sub_dev_ptr) );
FORWARD _PROTOTYPE( void reply,(int code, int replyee, int process,int status));
FORWARD _PROTOTYPE( int io_ctl_length, (int io_request) );
FORWARD _PROTOTYPE( special_file_t* get_special_file, (int minor_dev_nr) );


PRIVATE char io_ctl_buf[_IOCPARM_MASK];
PRIVATE int irq_hook_id = 0;	/* id of irq hook at the kernel */
PRIVATE int irq_hook_set = FALSE;
PRIVATE device_available = 0;/*todo*/


PUBLIC void main(void) 
{	
	int r, caller, proc_nr, chan;
	message mess;

	drv_init();

	/* Here is the main loop of the dma driver.  It waits for a message, 
     carries it out, and sends a reply. */
	printf("%s up and running\n", drv.DriverName);
	
	while(1) {
		receive(ANY, &mess);
		caller = mess.m_source;
		proc_nr = mess.PROC_NR;

		/* Now carry out the work. */
		switch(mess.m_type) {
			case DEV_OPEN:		/* open the special file ( = parameter) */
        r = msg_open(mess.DEVICE);break;
        
			case DEV_CLOSE:		/* close the special file ( = parameter) */
        r = msg_close(mess.DEVICE); break;
        
			case DEV_IOCTL:		
        r = msg_ioctl(&mess); break; 
        
			case DEV_READ:		
        msg_read(&mess); continue; /* don't reply */
        
			case DEV_WRITE:		
        msg_write(&mess); continue; /* don't reply */
        
      case DEV_STATUS:	
        msg_status(&mess);continue; /* don't reply */
        
			case HARD_INT:
        msg_hardware();continue;  /* don't reply */
        
			case SYS_SIG:		  
        msg_sig_stop(); continue; /* don't reply */
        
			default:          
        r = EINVAL;	dprint("%s: %d uncaught msg!\n", mess.m_type ,drv.DriverName);
        break;
		}
		/* Finally, prepare and send the reply message. */
		reply(TASK_REPLY, caller, proc_nr, r);
	}
	
}

PRIVATE int init_driver(void) {
  u32_t i; char irq;
  static int executed = 0;
  sub_dev_t* sub_dev_ptr;
  
  /* init variables, get dma buffers */
  for (i = 0; i < drv.NrOfSubDevices; i++) {
  
    sub_dev_ptr = &sub_dev[i];
    
    sub_dev_ptr->Opened = FALSE;
    sub_dev_ptr->DmaBusy = FALSE;
    sub_dev_ptr->DmaMode = NO_DMA;
    sub_dev_ptr->DmaReadNext = 0;
    sub_dev_ptr->DmaFillNext = 0;
    sub_dev_ptr->DmaLength = 0;
    sub_dev_ptr->BufReadNext = 0;
    sub_dev_ptr->BufFillNext = 0;
    sub_dev_ptr->RevivePending = FALSE;
    sub_dev_ptr->OutOfData = FALSE;
    sub_dev_ptr->Nr = i;
  }
  
  /* initialize hardware*/
  if (drv_init_hw() != OK) {
    error("%s: Could not initialize hardware\n", drv.DriverName, 0);
    return EIO;
  }
  
	/* get irq from device driver...*/
	if (drv_get_irq(&irq) != OK) {
	  error("%s: init driver couldn't get IRQ", drv.DriverName, i);
	  return EIO;
	}
	/* todo: execute the rest of this function only once 
     we don't want to set irq policy twice */
  if (executed) return OK;
  executed = TRUE;
  
	/* ...and register interrupt vector */
  if ((i=sys_irqsetpolicy(irq, 0, &irq_hook_id )) != OK){
  	error("%s: init driver couldn't set IRQ policy", drv.DriverName, i);
  	return EIO;
  }
  irq_hook_set = TRUE; /* now msg_sig_stop knows it must unregister policy*/
	return OK;
}


PRIVATE int msg_open (int minor_dev_nr) {
  int r, read_chan, write_chan, io_ctl;
  special_file_t* special_file_ptr;

  dprint("%s: msg_open() special file %d\n", drv.DriverName, minor_dev_nr);
  
  special_file_ptr = get_special_file(minor_dev_nr);
  if(special_file_ptr == NULL) {
	return EIO;
  }
  
  read_chan = special_file_ptr->read_chan;
  write_chan = special_file_ptr->write_chan;
  io_ctl = special_file_ptr->io_ctl;
  
  if (read_chan==NO_CHANNEL && write_chan==NO_CHANNEL && io_ctl==NO_CHANNEL) {
    error("%s: No channel specified for minor device!\n", drv.DriverName, minor_dev_nr);
    return EIO;
  }
  if (read_chan == write_chan && read_chan != NO_CHANNEL) {
    error("%s: Read and write channels are equal!\n", drv.DriverName,minor_dev_nr);
    return EIO;
  }
  /* init driver */
  if (!device_available) {  
    if (init_driver() != OK) {
      error("%s: Couldn't init driver!\n", drv.DriverName, minor_dev_nr);
      return EIO;
    } else {
      device_available = TRUE;
    }
  }  
  /* open the sub devices specified in the interface header file */
  if (write_chan != NO_CHANNEL) {
    /* open sub device for writing */
    if (open_sub_dev(write_chan, DEV_WRITE) != OK) return EIO;
  }  
  if (read_chan != NO_CHANNEL) {
    if (open_sub_dev(read_chan, DEV_READ) != OK) return EIO;
  }
  if (read_chan == io_ctl || write_chan == io_ctl) {
    /* io_ctl is already opened because it's the same as read or write */
    return OK; /* we're done */
  }
  if (io_ctl != NO_CHANNEL) { /* Ioctl differs from read/write channels, */
    r = open_sub_dev(io_ctl, NO_DMA); /* open it explicitly */
    if (r != OK) return EIO;
  } 
  return OK;
}


PRIVATE int open_sub_dev(int sub_dev_nr, int dma_mode) {
  sub_dev_t* sub_dev_ptr; int i;
  sub_dev_ptr = &sub_dev[sub_dev_nr];
  
  /* Only one open at a time per sub device */
	if (sub_dev_ptr->Opened) { 
    error("%s: Sub device %d is already opened\n", drv.DriverName, sub_dev_nr);
    return EBUSY;
  }
	if (sub_dev_ptr->DmaBusy) { 
    error("%s: Sub device %d is still busy\n", drv.DriverName, sub_dev_nr);
    return EBUSY;
  }
	/* Setup variables */
	sub_dev_ptr->Opened = TRUE;
	sub_dev_ptr->DmaReadNext = 0;
	sub_dev_ptr->DmaFillNext = 0;
	sub_dev_ptr->DmaLength = 0;
	sub_dev_ptr->DmaMode = dma_mode;
  sub_dev_ptr->BufReadNext = 0;
  sub_dev_ptr->BufFillNext = 0;
  sub_dev_ptr->BufLength = 0;
	sub_dev_ptr->RevivePending = FALSE;
	sub_dev_ptr->OutOfData = TRUE;
  
  /* arrange DMA */
  if (dma_mode != NO_DMA) { /* sub device uses DMA */
    /* allocate dma buffer and extra buffer space
       and configure sub device for dma */
    if (init_buffers(sub_dev_ptr) != OK ) return EIO;
  }
  return OK;  
}


PRIVATE int msg_close(int minor_dev_nr) {

  int r, read_chan, write_chan, io_ctl; 
  special_file_t* special_file_ptr;
   
  dprint("%s: msg_close() minor device %d\n", drv.DriverName, minor_dev_nr);
  
  special_file_ptr = get_special_file(minor_dev_nr);
  if(special_file_ptr == NULL) {
	return EIO;
  }
  
  read_chan = special_file_ptr->read_chan;
  write_chan = special_file_ptr->write_chan;
  io_ctl = special_file_ptr->io_ctl;
  
  /* close all sub devices */
  if (write_chan != NO_CHANNEL) {
    if (close_sub_dev(write_chan) != OK) r = EIO;
  }  
  if (read_chan != NO_CHANNEL) {
    if (close_sub_dev(read_chan) != OK) r = EIO;
  }
  if (read_chan == io_ctl || write_chan == io_ctl) {
    /* io_ctl is already closed because it's the same as read or write */
    return r; /* we're done */
  }
  /* Ioctl differs from read/write channels... */
  if (io_ctl != NO_CHANNEL) { 
    if (close_sub_dev(io_ctl) != OK) r = EIO; /* ...close it explicitly */
  } 
  return r;
}


PRIVATE int close_sub_dev(int sub_dev_nr) {
  sub_dev_t *sub_dev_ptr;
  sub_dev_ptr = &sub_dev[sub_dev_nr];
   
  if (sub_dev_ptr->DmaMode == DEV_WRITE && !sub_dev_ptr->OutOfData) {
    /* do nothing, still data in buffers that has to be transferred */
    sub_dev_ptr->Opened = FALSE;  /* keep DMA busy */
    return OK;
  }
  if (sub_dev_ptr->DmaMode == NO_DMA) {
    /* do nothing, there is no dma going on */
    sub_dev_ptr->Opened = FALSE;
    return OK;
  }
  sub_dev_ptr->Opened = FALSE;
  sub_dev_ptr->DmaBusy = FALSE;
  /* stop the device */
  drv_stop(sub_dev_ptr->Nr);
  /* free the buffers */
  free(sub_dev_ptr->DmaBuf);
  free(sub_dev_ptr->ExtraBuf);
}


PRIVATE int msg_ioctl(message *m_ptr)
{
	int status, len, chan;
	phys_bytes user_phys;
  sub_dev_t *sub_dev_ptr;
  special_file_t* special_file_ptr;
	
  dprint("%s: msg_ioctl() device %d\n", drv.DriverName, m_ptr->DEVICE);

  special_file_ptr = get_special_file(m_ptr->DEVICE);
  if(special_file_ptr == NULL) {
	return EIO;
  }
  
  chan = special_file_ptr->io_ctl;
  
	if (chan == NO_CHANNEL) {
	  error("%s: No io control channel specified!\n", drv.DriverName);
	  return EIO;
	}
	/* get pointer to sub device data */
	sub_dev_ptr = &sub_dev[chan];
	
  if(!sub_dev_ptr->Opened) {
    error("%s: io control impossible - not opened!\n", drv.DriverName);
    return EIO;
  }

  /* this is a hack...todo: may we intercept reset calls? */
	if(m_ptr->REQUEST == DSPIORESET) {
    device_available = FALSE;
  }
  /* this is confusing, _IOC_OUT bit means that there is incoming data */
  if (m_ptr->REQUEST & _IOC_OUT) { /* if there is data for us, copy it */
    len = io_ctl_length(m_ptr->REQUEST);
    sys_vircopy(m_ptr->PROC_NR, D, 
        (vir_bytes)m_ptr->ADDRESS, SELF, D, 
        (vir_bytes)io_ctl_buf, len);
  }

  /* all ioctl's are passed to the device specific part of the driver */
  status = drv_io_ctl(m_ptr->REQUEST, (void *)io_ctl_buf, &len, chan); 
	
	                                       /* _IOC_IN bit -> user expects data */
  if (status == OK && m_ptr->REQUEST & _IOC_IN) { 
    /* copy result back to user */
		sys_vircopy(SELF, D, (vir_bytes)io_ctl_buf, m_ptr->PROC_NR, D, (vir_bytes)m_ptr->ADDRESS, len);
	}
	return status;
}


PRIVATE void msg_write(message *m_ptr) 
{
  int s, chan; sub_dev_t *sub_dev_ptr;
  special_file_t* special_file_ptr;
	
  dprint("%s: msg_write() device %d\n", drv.DriverName, m_ptr->DEVICE);

  special_file_ptr = get_special_file(m_ptr->DEVICE); 
  chan = special_file_ptr->write_chan;
  
	if (chan == NO_CHANNEL) {
	  error("%s: No write channel specified!\n", drv.DriverName);
    reply(TASK_REPLY, m_ptr->m_source, m_ptr->PROC_NR, EIO);
	  return;
	}
	/* get pointer to sub device data */
	sub_dev_ptr = &sub_dev[chan];
	
  if (!sub_dev_ptr->DmaBusy) { /* get fragment size on first write */
    if (drv_get_frag_size(&(sub_dev_ptr->FragSize), sub_dev_ptr->Nr) != OK){
      error("%s; Failed to get fragment size!\n", drv.DriverName, 0);
      return;	
    }
  }
	if(m_ptr->COUNT != sub_dev_ptr->FragSize) {
		error("Fragment size does not match user's buffer length\n");
    reply(TASK_REPLY, m_ptr->m_source, m_ptr->PROC_NR, EINVAL);		
		return;
	}
	/* if we are busy with something else than writing, return EBUSY */
	if(sub_dev_ptr->DmaBusy && sub_dev_ptr->DmaMode != DEV_WRITE) {
	  error("Already busy with something else then writing\n");
		reply(TASK_REPLY, m_ptr->m_source, m_ptr->PROC_NR, EBUSY);
		return;
	}
	/* unblock the FileSystem, but keep user process blocked until REVIVE*/
	reply(TASK_REPLY, m_ptr->m_source, m_ptr->PROC_NR, SUSPEND);
	sub_dev_ptr->RevivePending = TRUE;
	sub_dev_ptr->ReviveProcNr = m_ptr->PROC_NR;
	sub_dev_ptr->UserBuf = m_ptr->ADDRESS;
	sub_dev_ptr->NotifyProcNr = m_ptr->m_source;

  data_from_user(sub_dev_ptr);
  
	if(!sub_dev_ptr->DmaBusy) { /* Dma tranfer not yet started */
  	dprint("starting audio device\n");
    get_started(sub_dev_ptr);    
		sub_dev_ptr->DmaMode = DEV_WRITE; /* Dma mode is writing */
	} 
}


PRIVATE void msg_read(message *m_ptr) 
{
  int s, chan; sub_dev_t *sub_dev_ptr;
  special_file_t* special_file_ptr;
	
  dprint("%s: msg_read() device %d\n", drv.DriverName, m_ptr->DEVICE);
  
  special_file_ptr = get_special_file(m_ptr->DEVICE); 
  chan = special_file_ptr->read_chan;
  
	if (chan == NO_CHANNEL) {
	  error("%s: No read channel specified!\n", drv.DriverName);
    reply(TASK_REPLY, m_ptr->m_source, m_ptr->PROC_NR, EIO);
	  return;
	}
	/* get pointer to sub device data */
	sub_dev_ptr = &sub_dev[chan];
	
  if (!sub_dev_ptr->DmaBusy) { /* get fragment size on first read */
    if (drv_get_frag_size(&(sub_dev_ptr->FragSize), sub_dev_ptr->Nr) != OK){
      error("%s: Could not retrieve fragment size!\n", drv.DriverName);
      reply(TASK_REPLY, m_ptr->m_source, m_ptr->PROC_NR, EIO);      	
      return;
    }
  }
	if(m_ptr->COUNT != sub_dev_ptr->FragSize) {
		reply(TASK_REPLY, m_ptr->m_source, m_ptr->PROC_NR, EINVAL);
		error("fragment size does not match message size\n");
		return;
	}
	/* if we are busy with something else than reading, reply EBUSY */
	if(sub_dev_ptr->DmaBusy && sub_dev_ptr->DmaMode != DEV_READ) {
		reply(TASK_REPLY, m_ptr->m_source, m_ptr->PROC_NR, EBUSY);
		return;
	}
	/* unblock the FileSystem, but keep user process blocked until REVIVE*/
	reply(TASK_REPLY, m_ptr->m_source, m_ptr->PROC_NR, SUSPEND);
	sub_dev_ptr->RevivePending = TRUE;
	sub_dev_ptr->ReviveProcNr = m_ptr->PROC_NR;
	sub_dev_ptr->UserBuf = m_ptr->ADDRESS;
	sub_dev_ptr->NotifyProcNr = m_ptr->m_source;

	if(!sub_dev_ptr->DmaBusy) { /* Dma tranfer not yet started */
    get_started(sub_dev_ptr);
		sub_dev_ptr->DmaMode = DEV_READ; /* Dma mode is reading */
		return;  /* no need to get data from DMA buffer at this point */
	}
  /* check if data is available and possibly fill user's buffer */
  data_to_user(sub_dev_ptr);
}


PRIVATE void msg_hardware(void) {
  
  u32_t     i;
  int j = 0;
  
  dprint("%s: handling hardware message\n", drv.DriverName);
  
  /* while we have an interrupt  */
  while ( drv_int_sum()) {
    /* loop over all sub devices */
    for ( i = 0; i < drv.NrOfSubDevices; i++) {
      /* if interrupt from sub device and Dma transfer 
         was actually busy, take care of business */
      if( drv_int(i) && sub_dev[i].DmaBusy ) {
        if (sub_dev[i].DmaMode == DEV_WRITE) handle_int_write(i);
        if (sub_dev[i].DmaMode == DEV_READ) handle_int_read(i);  
      }
    }
  }
}


PRIVATE void msg_status(message *m_ptr)
{
  int i; 

  dprint("got a status message\n");
  for (i = 0; i < drv.NrOfSubDevices; i++) {
  
  	if(sub_dev[i].ReadyToRevive) 
    {
  		m_ptr->m_type = DEV_REVIVE;			/* build message */
  		m_ptr->REP_PROC_NR = sub_dev[i].ReviveProcNr;
  		m_ptr->REP_STATUS = sub_dev[i].ReviveStatus;
      send(m_ptr->m_source, m_ptr);			/* send the message */
  		
  		/* reset variables */
  		sub_dev[i].ReadyToRevive = FALSE;
  		sub_dev[i].RevivePending = 0;
  		
  		return; /* stop after one mess, 
                    file system will get back for other processes */
  	}
  }
  m_ptr->m_type = DEV_NO_STATUS;
  m_ptr->REP_STATUS = 0;
  send(m_ptr->m_source, m_ptr);			/* send DEV_NO_STATUS message */
}


PRIVATE void msg_sig_stop(void) 
{
  int i; char irq;
  for (i = 0; i < drv.NrOfSubDevices; i++) {
    drv_stop(i); /* stop all sub devices */
  }
  if (irq_hook_set) {
    if (sys_irqdisable(&irq_hook_id) != OK) {
      error("Could not disable IRQ\n");
    }
    /* get irq from device driver*/
  	if (drv_get_irq(&irq) != OK) {
  	  error("Msg SIG_STOP Couldn't get IRQ");
  	}
  	/* remove the policy */
    if (sys_irqrmpolicy(irq, &irq_hook_id) != OK) {
      error("%s: Could not disable IRQ\n",drv.DriverName);
    }
  }
}


/* handle interrupt for specified sub device; DmaMode == DEV_WRITE*/
PRIVATE void handle_int_write(int sub_dev_nr) 
{
  sub_dev_t *sub_dev_ptr;
  int r;
  
  sub_dev_ptr = &sub_dev[sub_dev_nr];
  
  dprint("Finished playing dma[%d] ", sub_dev_ptr->DmaReadNext);
	sub_dev_ptr->DmaReadNext = (sub_dev_ptr->DmaReadNext + 1) % sub_dev_ptr->NrOfDmaFragments;
	sub_dev_ptr->DmaLength -= 1;
	 
  if (sub_dev_ptr->BufLength != 0) { /* Data in extra buf, copy to Dma buf */

    dprint(" buf[%d] -> dma[%d] ", sub_dev_ptr->BufReadNext, sub_dev_ptr->DmaFillNext);
    memcpy(sub_dev_ptr->DmaPtr + sub_dev_ptr->DmaFillNext * sub_dev_ptr->FragSize, 
           sub_dev_ptr->ExtraBuf + sub_dev_ptr->BufReadNext * sub_dev_ptr->FragSize, 
           sub_dev_ptr->FragSize);
		
		sub_dev_ptr->BufReadNext = (sub_dev_ptr->BufReadNext + 1) % sub_dev_ptr->NrOfExtraBuffers;
		sub_dev_ptr->DmaFillNext = (sub_dev_ptr->DmaFillNext + 1) % sub_dev_ptr->NrOfDmaFragments;
		
		sub_dev_ptr->BufLength -= 1;
	  sub_dev_ptr->DmaLength += 1;
  } 
  
  /* space became available, possibly copy new data from user */
	data_from_user(sub_dev_ptr);
    
  if(sub_dev_ptr->DmaLength == 0) { /* Dma buffer empty, stop Dma transfer */

    sub_dev_ptr->OutOfData = TRUE; /* we're out of data */
    dprint("No more work...!\n");
    if (!sub_dev_ptr->Opened) {
      close_sub_dev(sub_dev_ptr->Nr);
      dprint("Stopping sub device %d\n", sub_dev_ptr->Nr);
      return;
    }
    dprint("Pausing sub device %d\n",sub_dev_ptr->Nr);
    drv_pause(sub_dev_ptr->Nr);
    return;
  }

  dprint("\n");
  
  /* confirm and reenable interrupt from this sub dev */
  drv_reenable_int(sub_dev_nr);
  /* reenable irq_hook*/
	if ((r=sys_irqenable(&irq_hook_id)) != OK) {
    error("%s Couldn't enable IRQ\n", drv.DriverName);
  }
}


/* handle interrupt for specified sub device; DmaMode == DEV_READ */
PRIVATE void handle_int_read(int sub_dev_nr) 
{
  sub_dev_t *sub_dev_ptr; int r,i;
  
  sub_dev_ptr = &sub_dev[sub_dev_nr];
  
  dprint("Device filled dma[%d]\n", sub_dev_ptr->DmaFillNext);
  sub_dev_ptr->DmaLength += 1; 
  sub_dev_ptr->DmaFillNext = (sub_dev_ptr->DmaFillNext + 1) % sub_dev_ptr->NrOfDmaFragments;

  /* possibly copy data to user (if it is waiting for us) */
  data_to_user(sub_dev_ptr);
  
	if (sub_dev_ptr->DmaLength == sub_dev_ptr->NrOfDmaFragments) { /* if dma buffer full */
    
    if (sub_dev_ptr->BufLength == sub_dev_ptr->NrOfExtraBuffers) {
      error("All buffers full, we have a problem.\n");
      drv_stop(sub_dev_nr);        /* stop the sub device */
      sub_dev_ptr->DmaBusy = FALSE;
      sub_dev_ptr->ReviveStatus = 0;   /* no data for user, this is a sad story */
      sub_dev_ptr->ReadyToRevive = TRUE; /* wake user up */
      return;
    } 
    else { /* dma full, still room in extra buf; copy from dma to extra buf */
      dprint("dma full: going to copy buf[%d] <- dma[%d]\n", sub_dev_ptr->BufFillNext, 
                                                       sub_dev_ptr->DmaReadNext);
      memcpy(sub_dev_ptr->ExtraBuf + sub_dev_ptr->BufFillNext * sub_dev_ptr->FragSize, 
                sub_dev_ptr->DmaPtr + sub_dev_ptr->DmaReadNext * sub_dev_ptr->FragSize,
                                                         sub_dev_ptr->FragSize);
      sub_dev_ptr->DmaLength -= 1;
      sub_dev_ptr->DmaReadNext = (sub_dev_ptr->DmaReadNext + 1) % sub_dev_ptr->NrOfDmaFragments;
      sub_dev_ptr->BufFillNext = (sub_dev_ptr->BufFillNext + 1) % sub_dev_ptr->NrOfExtraBuffers;
    }
  }
  /* confirm interrupt, and reenable interrupt from this sub dev*/
  drv_reenable_int(sub_dev_ptr->Nr);
  
  /* reenable irq_hook*/
  if ((r=sys_irqenable(&irq_hook_id)) != OK) {
    error("%s: Couldn't reenable IRQ", drv.DriverName);
 	}
}


PRIVATE int get_started(sub_dev_t *sub_dev_ptr) {
  u32_t i;char c;  
  
  /* enable interrupt messages from MINIX */
  if ((i=sys_irqenable(&irq_hook_id)) != OK) {
    error("%s: Couldn't enable IRQs",drv.DriverName);
    return EIO;
  }
  /* let the lower part of the driver start the device */
  if (drv_start(sub_dev_ptr->Nr, sub_dev_ptr->DmaMode) != OK) {
    error("%s: Could not start device %d\n", drv.DriverName, sub_dev_ptr->Nr);
  }
  
  sub_dev_ptr->DmaBusy = TRUE;     /* Dma is busy from now on */
	sub_dev_ptr->DmaReadNext = 0;    
  return OK;
}


PRIVATE void data_from_user(sub_dev_t *subdev) {

  if (subdev->DmaLength == subdev->NrOfDmaFragments &&
      subdev->BufLength == subdev->NrOfExtraBuffers) return; /* no space */
  
  if (!subdev->RevivePending) return; /* no new data waiting to be copied */
  
  if (subdev->RevivePending && 
      subdev->ReadyToRevive) return; /* we already got this data */
  
  
  if (subdev->DmaLength < subdev->NrOfDmaFragments) { /* room in dma buf */
    
      sys_datacopy(subdev->ReviveProcNr, 
      (vir_bytes)subdev->UserBuf, 
      SELF, 
      (vir_bytes)subdev->DmaPtr + subdev->DmaFillNext * subdev->FragSize, 
      (phys_bytes)subdev->FragSize);
  
    dprint(" user -> dma[%d]\n", subdev->DmaFillNext);
    subdev->DmaLength += 1;
    subdev->DmaFillNext = (subdev->DmaFillNext + 1) % subdev->NrOfDmaFragments;
    
  } else { /* room in extra buf */ 

		sys_datacopy(subdev->ReviveProcNr, 
      (vir_bytes)subdev->UserBuf, 
      SELF, 
      (vir_bytes)subdev->ExtraBuf + subdev->BufFillNext * subdev->FragSize, 
      (phys_bytes)subdev->FragSize);
      
		dprint(" user -> buf[%d]\n", subdev->BufFillNext);
		subdev->BufLength += 1;
		
		subdev->BufFillNext = (subdev->BufFillNext + 1) % subdev->NrOfExtraBuffers;

	}
	if(subdev->OutOfData) { /* if device paused (because of lack of data) */
    subdev->OutOfData = FALSE;
    drv_reenable_int(subdev->Nr);
    /* reenable irq_hook*/
  	if ((sys_irqenable(&irq_hook_id)) != OK) {
      error("%s: Couldn't enable IRQ", drv.DriverName);
    }
    drv_resume(subdev->Nr);  /* resume resume the sub device */
    
  }
  
	subdev->ReviveStatus = subdev->FragSize;
	subdev->ReadyToRevive = TRUE;
	notify(subdev->NotifyProcNr);
}


PRIVATE void data_to_user(sub_dev_t *sub_dev_ptr) 
{
  if (!sub_dev_ptr->RevivePending) return; /* nobody is wating for data */
  if (sub_dev_ptr->ReadyToRevive) return;  /* we already filled user's buffer */
  if (sub_dev_ptr->BufLength == 0 && sub_dev_ptr->DmaLength == 0) return; 
                                                          /* no data for user */
  
  if(sub_dev_ptr->BufLength != 0) { /* data in extra buffer available */
    
		sys_datacopy(SELF, 
      (vir_bytes)sub_dev_ptr->ExtraBuf + sub_dev_ptr->BufReadNext * sub_dev_ptr->FragSize,
      sub_dev_ptr->ReviveProcNr, 
      (vir_bytes)sub_dev_ptr->UserBuf, 
      (phys_bytes)sub_dev_ptr->FragSize);
      
		dprint(" copied buf[%d] to user\n", sub_dev_ptr->BufReadNext); 
		/* adjust the buffer status variables */
    sub_dev_ptr->BufReadNext = (sub_dev_ptr->BufReadNext + 1) % sub_dev_ptr->NrOfExtraBuffers;
		sub_dev_ptr->BufLength -= 1;
		
	} else { /* extra buf empty, but data in dma buf*/ 

		  sys_datacopy(SELF, 
      (vir_bytes)sub_dev_ptr->DmaPtr + sub_dev_ptr->DmaReadNext * sub_dev_ptr->FragSize,
      sub_dev_ptr->ReviveProcNr, 
      (vir_bytes)sub_dev_ptr->UserBuf, 
      (phys_bytes)sub_dev_ptr->FragSize);
      
		dprint(" copied dma[%d] to user\n", sub_dev_ptr->DmaReadNext);
		/* adjust the buffer status variables */
    sub_dev_ptr->DmaReadNext = (sub_dev_ptr->DmaReadNext + 1) % sub_dev_ptr->NrOfDmaFragments;
		sub_dev_ptr->DmaLength -= 1;
	}
	sub_dev_ptr->ReviveStatus = sub_dev_ptr->FragSize;
	sub_dev_ptr->ReadyToRevive = TRUE; /* drv_status will send REVIVE mess to FS*/	
  notify(sub_dev_ptr->NotifyProcNr);     /* notify the File Systam to make it 
                                        send DEV_STATUS messages*/
}


PRIVATE int init_buffers(sub_dev_t *sub_dev_ptr) {
#if (CHIP == INTEL)
	unsigned left;
	u32_t i;
  
  /* allocate dma buffer space */
  if (!(sub_dev_ptr->DmaBuf = malloc(sub_dev_ptr->DmaSize + 64 * 1024))) {
    error("%s: failed to allocate dma buffer for channel %d\n", drv.DriverName,i);
    return EIO;
  }
  /* allocate extra buffer space */
  if (!(sub_dev_ptr->ExtraBuf = malloc(sub_dev_ptr->NrOfExtraBuffers * sub_dev_ptr->DmaSize / sub_dev_ptr->NrOfDmaFragments))) {
    error("%s failed to allocate extra buffer for channel %d\n", drv.DriverName,i);
    return EIO;
  }
  
	sub_dev_ptr->DmaPtr = sub_dev_ptr->DmaBuf;
	i = sys_umap(SELF, D, 
               (vir_bytes) sub_dev_ptr->DmaBuf, 
               (phys_bytes) sizeof(sub_dev_ptr->DmaBuf), 
               &(sub_dev_ptr->DmaPhys));
  
  if (i != OK) {
    return EIO;
  }
	if((left = dma_bytes_left(sub_dev_ptr->DmaPhys)) < sub_dev_ptr->DmaSize) {
		/* First half of buffer crosses a 64K boundary, can't DMA into that */
		sub_dev_ptr->DmaPtr += left;
		sub_dev_ptr->DmaPhys += left;
	}
	/* write the physical dma address and size to the device */
  drv_set_dma(sub_dev_ptr->DmaPhys, sub_dev_ptr->DmaSize, sub_dev_ptr->Nr);
	return OK;
	
#else /* CHIP != INTEL */
	error("%s: init_buffer() failed, CHIP != INTEL", drv.DriverName);
	return EIO;
#endif /* CHIP == INTEL */
}


PRIVATE void reply(int code, int replyee, int process, int status)
{
	message m;

	m.m_type = code;		/* TASK_REPLY or REVIVE */
	m.REP_STATUS = status;	/* result of device operation */
	m.REP_PROC_NR = process;	/* which user made the request */
	send(replyee, &m);
}


PRIVATE int io_ctl_length(int io_request) {
  io_request >>= 16; 
  return io_request & _IOCPARM_MASK;
}


PRIVATE special_file_t* get_special_file(int minor_dev_nr) {
	int i;
	
	for(i = 0; i < drv.NrOfSpecialFiles; i++) {
		if(special_file[i].minor_dev_nr == minor_dev_nr) {
			return &special_file[i];
		}
	}

	error("%s: No subdevice specified for minor device %d!\n", drv.DriverName, minor_dev_nr);
	
	return NULL;
}