@echo off
REM =====================================================================
REM  Demo del corso System Integrator - avvio con un doppio clic.
REM
REM  Fa le stesse cose di "npm run start:all" senza dover aprire un
REM  terminale: controlla i prerequisiti (Node.js e Docker Desktop),
REM  avvia Docker Desktop se e' spento, lancia le quattro demo e apre
REM  l'hub nel browser. Equivalente per Mac: avvia.command
REM
REM  Nota: i messaggi non usano lettere accentate di proposito. La
REM  finestra del Prompt dei comandi non le mostra correttamente su
REM  tutti i PC e "e'" e' preferibile a un carattere illeggibile.
REM =====================================================================
setlocal
cd /d "%~dp0"
title Demo corso System Integrator

echo.
echo  ============================================================
echo    Demo del corso AIsuru System Integrator
echo  ============================================================
echo.

REM Alcune installazioni di Docker non aggiungono il CLI al PATH di sistema.
set "PATH=%PATH%;%ProgramFiles%\Docker\Docker\resources\bin"

REM ---------------------------------------------------------------- 1/3
echo  [1/3] Controllo Node.js...
where node >nul 2>&1
if errorlevel 1 goto :manca_node
echo        OK.
echo.

REM ---------------------------------------------------------------- 2/3
echo  [2/3] Controllo Docker Desktop...
where docker >nul 2>&1
if errorlevel 1 goto :manca_docker

docker info >nul 2>&1
if not errorlevel 1 goto :docker_pronto

echo        Docker Desktop non e' in esecuzione: provo ad avviarlo io.
if exist "%ProgramFiles%\Docker\Docker\Docker Desktop.exe" start "" "%ProgramFiles%\Docker\Docker\Docker Desktop.exe"
if exist "%LOCALAPPDATA%\Docker\Docker Desktop.exe" start "" "%LOCALAPPDATA%\Docker\Docker Desktop.exe"
echo        Attendo che sia pronto, puo' volerci un paio di minuti.
set /a TENTATIVI=0

:attesa_docker
docker info >nul 2>&1
if not errorlevel 1 goto :attesa_finita
set /a TENTATIVI+=1
if %TENTATIVI% geq 60 goto :docker_non_parte
<nul set /p "=."
timeout /t 3 /nobreak >nul
goto :attesa_docker

:attesa_finita
echo.

:docker_pronto
echo        OK.
echo.

REM ---------------------------------------------------------------- 3/3
echo  [3/3] Avvio delle demo.
echo.
echo        La prima volta puo' richiedere anche una decina di minuti:
echo        e' normale. Non chiudere questa finestra finche' non compare
echo        il messaggio finale.
echo.

node start-all.js --quiet
if errorlevel 1 goto :avvio_parziale

echo.
echo  ============================================================
echo    Tutto pronto.
echo  ============================================================
echo.
echo  L'elenco delle demo si sta aprendo nel tuo browser. Se non si
echo  apre da solo, fai doppio clic sul file "index.html" che trovi
echo  in questa stessa cartella.
echo.
goto :come_fermare

:avvio_parziale
echo.
echo  ============================================================
echo    Alcune demo non sono partite.
echo  ============================================================
echo.
echo  Quelle partite correttamente sono comunque utilizzabili: le
echo  trovi nell'elenco che si sta aprendo nel browser.
echo.
echo  Per capire cosa e' andato storto apri il file "avvio.log" in
echo  questa cartella, oppure inviacelo: contiene i dettagli tecnici.
echo.
goto :come_fermare

:come_fermare
echo  Le demo restano attive anche dopo aver chiuso questa finestra.
echo  Per fermarle, doppio clic su "ferma.bat".
echo.
goto :fine

REM ------------------------------------------------------- errori noti
:manca_node
echo        Node.js non risulta installato.
echo.
echo  Cosa fare:
echo    1. vai su https://nodejs.org
echo    2. scarica la versione indicata come "LTS" e installala
echo       lasciando tutte le opzioni come sono
echo    3. riavvia il computer
echo    4. fai di nuovo doppio clic su questo file
echo.
goto :fine

:manca_docker
echo        Docker Desktop non risulta installato.
echo.
echo  Cosa fare:
echo    1. vai su https://www.docker.com/products/docker-desktop/
echo    2. scarica Docker Desktop per Windows e installalo
echo    3. aprilo almeno una volta e attendi che scriva "Engine running"
echo    4. fai di nuovo doppio clic su questo file
echo.
goto :fine

:docker_non_parte
echo.
echo        Docker Desktop non e' diventato pronto entro tre minuti.
echo.
echo  Cosa fare:
echo    1. apri Docker Desktop dal menu Start
echo    2. attendi che in basso a sinistra compaia "Engine running"
echo    3. fai di nuovo doppio clic su questo file
echo.
goto :fine

:fine
pause
endlocal
