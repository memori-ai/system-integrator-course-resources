@echo off
REM =====================================================================
REM  Ferma tutte le demo del corso - doppio clic.
REM  Controparte di avvia.bat. Equivalente per Mac: ferma.command
REM =====================================================================
setlocal
cd /d "%~dp0"
title Arresto demo corso System Integrator

set "PATH=%PATH%;%ProgramFiles%\Docker\Docker\resources\bin"

echo.
echo  ============================================================
echo    Arresto delle demo in corso...
echo  ============================================================
echo.

where node >nul 2>&1
if errorlevel 1 goto :manca_node

docker info >nul 2>&1
if errorlevel 1 goto :docker_spento

node stop-all.js

echo.
echo  Fatto: le demo sono state fermate.
echo  Per riavviarle, doppio clic su "avvia.bat".
echo.
goto :fine

:manca_node
echo  Node.js non risulta installato, quindi le demo non sono mai
echo  state avviate da qui: non c'e' nulla da fermare.
echo.
goto :fine

:docker_spento
echo  Docker Desktop non e' in esecuzione: le demo sono gia' ferme.
echo.
goto :fine

:fine
pause
endlocal
