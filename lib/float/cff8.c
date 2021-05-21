/*
  (c) copyright 1988 by the Vrije Universiteit, Amsterdam, The Netherlands.
  See the copyright notice in the ACK home directory, in the file "Copyright".
*/

/* $Header: /cvsup/minix/src/lib/float/cff8.c,v 1.1.1.1 2005/04/21 14:56:10 beng Exp $ */

/*
		CONVERT SINGLE TO DOUBLE (CFF 4 8)

	This routine works quite simply. A floating point
	of size 04 is converted to extended format.
	This extended variable is converted back to
	a floating point of size 08.

*/

#include "FP_types.h"

void
cff8(src)
SINGLE	src;
{
	EXTEND	buf;

	extend(&src,&buf,sizeof(SINGLE));	/* no matter what */
	compact(&buf, &src,sizeof(DOUBLE));
}
