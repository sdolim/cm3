(*******************************************************************************
 * This file was automatically generated by SWIG (http://www.swig.org).
 * Version 2.0.11
 *
 * Do not make changes to this file unless you know what you are doing--modify
 * the SWIG interface file instead.
*******************************************************************************)

INTERFACE QtStringRaw;


IMPORT Ctypes AS C;


<* EXTERNAL New_QString0 *>
PROCEDURE New_QString0 (): QString;

<* EXTERNAL Delete_QString *>
PROCEDURE Delete_QString ( self: QString;
);

<* EXTERNAL QString_size *>
PROCEDURE QString_size ( self: QString;
): C.int;

<* EXTERNAL QString_count *>
PROCEDURE QString_count ( self: QString;
): C.int;

<* EXTERNAL QString_length *>
PROCEDURE QString_length ( self: QString;
): C.int;

<* EXTERNAL QString_count1 *>
PROCEDURE QString_count1 ( self: QString;
 s: ADDRESS;
): C.int;

<* EXTERNAL QString_toUtf8 *>
PROCEDURE QString_toUtf8 ( self: QString;
): ADDRESS;

<* EXTERNAL QString_toLocal8Bit *>
PROCEDURE QString_toLocal8Bit ( self: QString;
): ADDRESS;

<* EXTERNAL New_initQString *>
PROCEDURE New_initQString ( ch: C.char_star;
): QString;

<* EXTERNAL New_QString1 *>
PROCEDURE New_QString1 ( a: ADDRESS;
): QString;

<* EXTERNAL New_QString2 *>
PROCEDURE New_QString2 (size, arg2: C.int;
): QString;

TYPE
QString <: ADDRESS;

END QtStringRaw.
