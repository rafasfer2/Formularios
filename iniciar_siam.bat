@echo off
title Iniciando Projeto SIAM

echo ================================
echo     INICIANDO PROJETO SIAM
echo ================================

:: Verifica se o Rscript existe
if not exist "C:\Program Files\R\R-4.5.0\bin\Rscript.exe" (
  echo ❌ Rscript.exe não encontrado. Verifique o caminho do R.
  pause
  exit /b
)

:: Inicia o app Shiny
echo Iniciando app Shiny...
start "" "C:\Program Files\R\R-4.5.0\bin\Rscript.exe" -e "setwd('C:/Users/rafas/OneDrive/Documentos/github/SEMMU Arquivados/Formularios'); shiny::runApp(port = 5250, host = '0.0.0.0')"

:: Aguarda alguns segundos para garantir que o app esteja rodando
timeout /t 5 >nul

:: Verifica se o cloudflared está disponível
where cloudflared >nul 2>nul
if errorlevel 1 (
  echo ❌ Cloudflared não encontrado. Verifique se está instalado e no PATH.
  pause
  exit /b
)

:: Inicia o túnel Cloudflare
echo Iniciando túnel Cloudflare...
start /min "" cloudflared tunnel run siam-tunnel

:: Mensagem final
echo.
echo ✅ Tudo iniciado com sucesso!
echo 🌐 Acesse: https://cadastroinicial.siammulher.com.br
echo ================================
pause