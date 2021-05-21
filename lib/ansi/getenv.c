/*
 * (c) copyright 1987 by the Vrije Universiteit, Amsterdam, The Netherlands.
 * See the copyright notice in the ACK home directory, in the file "Copyright".
 */
/* $Header: /cvsup/minix/src/lib/ansi/getenv.c,v 1.1.1.1 2005/04/21 14:56:05 beng Exp $ */

#include	<stdlib.h>

extern const char ***_penviron;

char *
getenv(const char *name)
{
	register const char **v = *_penviron;
	register const char *p, *q;

	if (v == NULL || name == NULL)
		return (char *)NULL;
	while ((p = *v++) != NULL) {
		q = name;
		while (*q && (*q == *p++))
			q++;
		if (*q || (*p != '='))
			continue;
		return (char *)p + 1;
	}
	return (char *)NULL;
}
