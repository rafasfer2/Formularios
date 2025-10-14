# Lista de pacotes usados no SIAM
pacotes <- c(
  # Interface e layout
  "shiny",           # Framework principal
  "shinyjs",         # Interações JS
  "bslib",           # Temas e layout
  "DT",              # Tabelas dinâmicas
  
  # Banco de dados
  "DBI",             # Interface de banco de dados
  "RSQLite",         # Suporte a SQLite local
  "RPostgres",       # Conexão com Supabase (PostgreSQL)
  
  # Segurança e formatos
  "digest",          # Criptografia de senha
  "jsonlite",        # Manipulação de JSON
  
  # Manipulação de dados
  "lubridate",       # Datas e horários
  "stringr",         # Manipulação de strings
  "readr",           # Leitura de arquivos
  "dplyr",           # Manipulação de dados
  "tidyr",           # Organização de dados
  "purrr",           # Programação funcional
  
  # Integração externa
  "googlesheets4",   # Coleta de dados do Google Sheets
  
  # Manipulação de dados (via tidyverse)
  "tidyverse"
)

# Instala apenas os que ainda não estão presentes
instalar <- pacotes[!pacotes %in% installed.packages()[, "Package"]]

if (length(instalar) > 0) {
  install.packages(instalar, repos = "https://cloud.r-project.org")
  message("✅ Pacotes instalados com sucesso: ", paste(instalar, collapse = ", "))
} else {
  message("🎉 Todos os pacotes já estavam instalados.")
}

# Carrega todos os pacotes
invisivel <- lapply(pacotes, function(pkg) {
  suppressPackageStartupMessages(library(pkg, character.only = TRUE))
})

message("📦 Todos os pacotes carregados: ", paste(pacotes, collapse = ", "))