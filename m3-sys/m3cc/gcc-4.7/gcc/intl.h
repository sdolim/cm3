/* Modula-3: modified */

/* intl.h - internationalization
   Copyright 1998, 2001, 2003, 2004, 2007, 2009, 2010
   Free Software Foundation, Inc.

   GCC is free software; you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation; either version 3, or (at your option)
   any later version.

   GCC is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with GCC; see the file COPYING3.  If not see
   <http://www.gnu.org/licenses/>.  */

#ifndef GCC_INTL_H
#define GCC_INTL_H

/* Stubs.  */
# undef textdomain
# define textdomain(domain) (domain)
# undef bindtextdomain
# define bindtextdomain(domain, directory) (domain)
# undef gettext
# define gettext(msgid) (msgid)
# define ngettext(singular,plural,n) fake_ngettext(singular,plural,n)
# define gcc_init_libintl()	/* nothing */
# define gcc_gettext_width(s) strlen(s)

#define fake_ngettext(singular, plural, n) (((n) == 1) ? (singular) : (plural))

#ifndef _
# define _(msgid) gettext (msgid)
#endif

#ifndef N_
# define N_(msgid) msgid
#endif

#ifndef G_
# define G_(gmsgid) gmsgid
#endif

#define open_quote "'"
#define close_quote "'"

#endif /* intl.h */
