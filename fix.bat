@echo off
setlocal EnableDelayedExpansion

:: Set console to UTF-8 for proper language support
chcp 65001 >nul

:: Language selection
:language
cls
echo Выберите язык / Escolha o idioma / Choose language:
echo 1. Русский
echo 2. Português
echo 3. English
set /p lang=Введите номер (1-3): 
if "!lang!"=="1" (
    set "lang_choice=ru"
    set "msg1=Выберите версию приложения:"
    set "msg2=1. Portable"
    set "msg3=2. Setup"
    set "msg4=Введите номер (1-2): "
    set "msg5=Хотите скачать приложение? (y/n): "
    set "msg6=Удаление папок..."
    set "msg7=Запуск uninstaller..."
    set "msg8=Скачивание файла..."
    set "msg9=Запуск скачанного файла..."
    set "msg10=Операция завершена."
    set "msg11=Неверный выбор. Попробуйте снова."
    set "msg12=Скачивание отменено."
) else if "!lang!"=="2" (
    set "lang_choice=pt"
    set "msg1=Escolha a versão do aplicativo:"
    set "msg2=1. Portátil"
    set "msg3=2. Setup"
    set "msg4=Digite o número (1-2): "
    set "msg5=Deseja baixar o aplicativo? (s/n): "
    set "msg6=Excluindo pastas..."
    set "msg7=Executando desinstalador..."
    set "msg8=Baixando arquivo..."
    set "msg9=Executando arquivo baixado..."
    set "msg10=Operação concluída."
    set "msg11=Escolha inválida. Tente novamente."
    set "msg12=Download cancelado."
) else if "!lang!"=="3" (
    set "lang_choice=en"
    set "msg1=Choose the application version:"
    set "msg2=1. Portable"
    set "msg3=2. Setup"
    set "msg4=Enter number (1-2): "
    set "msg5=Do you want to download the application? (y/n): "
    set "msg6=Deleting folders..."
    set "msg7=Running uninstaller..."
    set "msg8=Downloading file..."
    set "msg9=Running downloaded file..."
    set "msg10=Operation completed."
    set "msg11=Invalid choice. Try again."
    set "msg12=Download canceled."
) else (
    echo !msg11!
    pause
    goto language
)

:: Version selection
:version
cls
echo !msg1!
echo !msg2!
echo !msg3!
set /p version=!msg4!
if "!version!"=="1" (
    set "app_type=portable"
    set "url=https://hydrasources.su/get-file?type=portable"
) else if "!version!"=="2" (
    set "app_type=setup"
    set "url=https://hydrasources.su/get-file?type=setup"
) else (
    echo !msg11!
    pause
    goto version
)

:: Ask to download
cls
set /p download=!msg5!
if /i "!download!"=="y" (
    goto process
) else if /i "!download!"=="s" (
    goto process
) else (
    echo !msg12!
    pause
    exit /b
)

:process
:: Delete folders
echo !msg6!
rmdir /s /q "%APPDATA%\hydralauncher" 2>nul
rmdir /s /q "%LOCALAPPDATA%\hydralauncher-updater" 2>nul

:: Run uninstaller if setup version
if "!app_type!"=="setup" (
    echo !msg7!
    if exist "C:\Program Files\Hydra\Uninstall Hydra.exe" (
        start /wait "" "C:\Program Files\Hydra\Uninstall Hydra.exe"
    )
)

:: Download and run the file
echo !msg8!
powershell -Command "Invoke-WebRequest -Uri '!url!' -OutFile '%TEMP%\hydra_installer.exe'"
if exist "%TEMP%\hydra_installer.exe" (
    echo !msg9!
    start "" "%TEMP%\hydra_installer.exe"
)

echo !msg10!
pause
endlocal