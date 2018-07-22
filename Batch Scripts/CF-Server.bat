@ECHO OFF
REM Stops then Starts ColdFusion Server
CLS

REM https://stackoverflow.com/questions/7809648/get-display-name-of-current-windows-domain-user-from-a-command-prompt
REM NOTE: Does not work if not connected to work network, must set DNAME manually if not connected.
SET TNAME="net user %USERNAME% /domain| FIND /I "Full Name""
FOR /F "tokens=3,4 delims=, " %%A IN ('%TNAME%') DO SET DNAME=%%A
SET CF_BIN=C:\ColdFusion11\%DNAME%\bin\

IF NOT EXIST %CF_BIN% CALL:NOTFOUND "ColdFusion bin folder" %CF_BIN% "CF_BIN"
CD %CF_BIN%
CALL cfstop.bat
CALL cfstart.bat
GOTO:FINISH

:NOTFOUND
    ECHO Error finding %1
    ECHO Verify that %2 Exists or edit batch file variable %3
    GOTO:FINISH 

:FINISH
    PAUSE