/*
**  File:	ne.h
**   
**  Created:	March 15, 1994 by Philip Homburg <philip@cs.vu.nl>
**  $PchId: ne2000.h,v 1.2 1995/12/22 08:42:31 philip Exp $
**
**  $Log: ne.h,v $
**  Revision 1.1  2005/06/29 10:16:46  beng
**  Import of dpeth 3c501/3c509b/.. ethernet driver by
**  Giovanni Falzoni <fgalzoni@inwind.it>.
**
**  Revision 2.0  2005/06/26 16:16:46  lsodgf0
**  Initial revision for Minix 3.0.6
**
**  $Id: ne.h,v 1.1 2005/06/29 10:16:46 beng Exp $
*/

#ifndef NE2000_H
#define NE2000_H

#define NE_DP8390	0x00
#define NE_DATA		0x10
#define NE_RESET	0x1F

#define NE1000_START	0x2000
#define NE1000_SIZE	0x2000
#define NE2000_START	0x4000
#define NE2000_SIZE	0x4000

#define inb_ne(dep, reg) (inb(dep->de_base_port+reg))
#define outb_ne(dep, reg, data) (outb(dep->de_base_port+reg, data))
#define inw_ne(dep, reg) (inw(dep->de_base_port+reg))
#define outw_ne(dep, reg, data) (outw(dep->de_base_port+reg, data))

#endif				/* NE2000_H */

/** ne.h **/
