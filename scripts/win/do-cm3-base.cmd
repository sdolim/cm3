@rem $Id$

@if "%_echo%" == "" @echo off

@setlocal

@call %~dp0clearenv || exit /b 1
@call %~dp0sysinfo || exit /b 1
@call %~dp0pkginfo || exit /b 1
@call %~dp0pkgcmds || exit /b 1

set P=
set P=%P% import-libs
set P=%P% m3core
set P=%P% libm3
set P=%P% m3middle
set P=%P% m3quake
set P=%P% m3scanner
set P=%P% m3tools
set P=%P% m3cgcat
set P=%P% m3cggen
set P=%P% m3bundle
set P=%P% mklib
set P=%P% fix_nl
set P=%P% libdump
set P=%P% bitvector
set P=%P% digraph
set P=%P% parseparams
set P=%P% realgeometry
set P=%P% set
set P=%P% slisp
set P=%P% sortedtableextras
set P=%P% table-list
set P=%P% tempfiles
if "%HAVE_TCL%" == "yes" set P=%P% tcl
set P=%P% tcp
set P=%P% tapi
if "%HAVE_SERIAL%" == "yes" set P=%P% serial

call %~dp0pkgcmds extract_options %* || (
	echo error : pkgcmds extract_options failed
	exit /b 1
)
call %~dp0pkgcmds map_action %* || (
	echo error : pkgcmds map_action failed
	exit /b 1
)
call %~dp0pkgcmds add_action_opts %* || (
	echo error : pkgcmds add_action_opts failed
	exit /b 1
)

call :Run call %~dp0pkgmap %OPTIONS% %ADDARGS% -c "%ACTION%" %P%

@echo %~n0 : Done.

@endlocal
@goto :eof

:Run
@setlocal
@set x=%*
@set x=%x:  = %
@set x=%x:  = %
@echo %x%
%x% || (
	echo error : %x% failed
	exit /b 1
)
@endlocal
@goto :eof
