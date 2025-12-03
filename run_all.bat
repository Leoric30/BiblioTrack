@echo off
echo ========================================
echo    INICIANDO SISTEMA COMPLETO
echo ========================================
echo.

echo 1. Iniciando Backend Python (FastAPI)...
start cmd /k "cd python_backend && python api.py"

timeout /t 3 /nobreak >nul

echo.
echo 2. Iniciando App Flutter...
echo    Espera 5 segundos para que el backend inicie...
timeout /t 5 /nobreak >nul

echo.
echo 3. Ejecutando Flutter...
flutter run --no-sound-null-safety

echo.
echo Presiona cualquier tecla para cerrar todo...
pause

taskkill /F /IM python.exe >nul 2>&1
taskkill /F /IM uvicorn.exe >nul 2>&1