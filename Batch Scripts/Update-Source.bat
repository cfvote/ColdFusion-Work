@ECHO OFF
REM Used daily at work to update source code and move Jars to appropriate folder.
CLS

REM https://stackoverflow.com/questions/7809648/get-display-name-of-current-windows-domain-user-from-a-command-prompt
SET TNAME="net user %USERNAME% /domain| FIND /I "Full Name""
FOR /F "tokens=3,4 delims=, " %%A IN ('%TNAME%') DO SET DNAME=%%A

SET CF_PATH=C:\ColdFusion11\%DNAME%
SET SOURCE_PATH=C:\source
SET SVN_PATH=svn.exe

WHERE %SVN_PATH% >nul 2>nul
IF %ERRORLEVEL%==1 CALL:NOTFOUND "svn.exe" %SVN_PATH% "SVN_PATH" 
IF NOT EXIST %SOURCE_PATH% CALL:NOTFOUND "Source Folder" %SOURCE_PATH% "SOURCE_PATH"
IF NOT EXiST %CF_PATH% CALL:NOTFOUND "Coldfusion Folder" %CF_PATH% "CF_PATH"
GOTO:UPDATE_SOURCE


:UPDATE_SOURCE
    @ECHO ON
    svn cleanup %SOURCE_PATH%/cfmx
    svn update %SOURCE_PATH%/cfmx
    svn cleanup %SOURCE_PATH%/java
    svn update %SOURCE_PATH%/java
    XCOPY %SOURCE_PATH%\java\BuiltJARS\jars %CF_PATH%\lib\ /e /i /y /s /u
    XCOPY %SOURCE_PATH%\java\BuiltJARS\jars\properties\*.jar %CF_PATH%\lib\ /e /i /y /s /u 
    XCOPY %SOURCE_PATH%\java\JARS\CFDependencies %CF_PATH%\lib\ /e /i /y /s /u
    @ECHO OFF
    GOTO:FINISH

:NOTFOUND
    ECHO Error finding %1
    ECHO Verify that %2 Exists or edit batch file variable %3
    GOTO:FINISH 

:FINISH
    PAUSE
