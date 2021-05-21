/*
 * (c) copyright 1988 by the Vrije Universiteit, Amsterdam, The Netherlands.
 * See the copyright notice in the ACK home directory, in the file "Copyright".
 *
 *
 * Module:	range checks for LONGINT
 * Author:	Ceriel J.H. Jacobs
 * Version:	$Header: /cvsup/minix/src/lib/ack/libm2/rckil.c,v 1.1 2005/10/10 15:27:46 beng Exp $
*/

#include <em_abs.h>

extern TRP();

struct range_descr {
  long	low, high;
};

rckil(descr, val)
  struct range_descr *descr;
  long val;
{
  if (val < descr->low || val > descr->high) TRP(ERANGE);
}
