@echo off
setlocal

REM Verifica se foi fornecido o nome do cliente como argumento
if "%~1"=="" (
    echo Por favor, forneça o nome do cliente como argumento.
    echo Exemplo: script.bat NomeDoCliente
    exit /b 1
)

REM Define o cliente
set nomeCliente=%~1

REM Define a pasta de origem e o arquivo específico
set pastaOrigem=D:\fs-arquivosservice\ArquivosService-%nomeCliente%
set arquivoCompactado=D:\fs-arquivosservice\ArquivosService-%nomeCliente%.7z

REM Define a pasta de destino
set destino="B2:bkp-skyone-omega-fs\FileServer\Backup"

REM Gera um timestamp no formato YYYYMMDD_HHMMSS
for /f "tokens=1-4 delims=/ " %%i in ('date /t') do set dt=%%k%%j%%i
for /f "tokens=1-3 delims=:." %%i in ('time /t') do set tm=%%i%%j%%k
set timestamp=%dt%_%tm%

REM Compacta a pasta de origem para um arquivo .7z
echo Compactando a pasta de origem...
"C:\Program Files\7-Zip\7z.exe" a -t7z "%arquivoCompactado%" "%pastaOrigem%" > nul

REM Verifica se a pasta "Backup" já existe no destino
set pastaBackup=%destino%\ArquivosService-%nomeCliente%
rclone.exe lsf %pastaBackup% > nul 2>&1
if %errorlevel% neq 0 (
    echo Criando a pasta Backup no destino...
    rclone.exe mkdir %pastaBackup%
)

REM Executa o comando rclone com o arquivo compactado e o timestamp no nome do arquivo de destino
set nomeArquivoDestino=Backup_ArquivosService-%nomeCliente%_%timestamp%.7z
echo Copiando o arquivo para o destino...
rclone.exe copyto %arquivoCompactado% %pastaBackup%\%nomeArquivoDestino% --fast-list --progress

REM Remove o arquivo compactado após a cópia ser concluída
echo Removendo o arquivo compactado...
del %arquivoCompactado%

endlocal
