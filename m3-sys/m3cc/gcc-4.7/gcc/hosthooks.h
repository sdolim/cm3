/* Modula-3: modified */

/* The host_hooks data structure.
   Copyright 2003, 2004, 2007 Free Software Foundation, Inc.

This file is part of GCC.

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

#ifndef GCC_HOST_HOOKS_H
#define GCC_HOST_HOOKS_H

struct host_hooks
{
  void (*extra_signals) (void);

  /* Whenever you add entries here, make sure you adjust hosthooks-def.h.  */
};

/* Each host provides its own.  */
extern const struct host_hooks host_hooks;

#endif /* GCC_LANG_HOOKS_H */
