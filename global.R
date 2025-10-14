# global.R

# 📦 Lista de pacotes usados no SIAM
pacotes <- c(
  # Interface e layout
  "shiny", "shinyjs", "bslib", "DT",
  
  # Banco de dados
  "DBI", "RSQLite", "RPostgres",
  
  # Segurança e formatos
  "digest", "jsonlite",
  
  # Manipulação de dados
  "lubridate", "stringr", "readr", "dplyr", "tidyr", "purrr",
  
  # Integração externa
  "googlesheets4",
  
  # Manipulação de dados (via tidyverse)
  "tidyverse"
)

# Instala e carrega os pacotes
novos <- pacotes[!(pacotes %in% installed.packages()[,"Package"])]
if(length(novos)) install.packages(novos)
lapply(pacotes, require, character.only = TRUE)



# 🧠 Funções auxiliares e layout
source("utils/helpers.R")           # Rótulos, salvamento, tratamento de nulos
source("utils/validacao.R")         # Validações específicas por aba
source("utils/conexao_bd.R")        # Função conectar_bd() com suporte a SQLite e Supabase
source("utils/inicializar_bd.R")    # Criação automática do banco local
source("utils/layout_global.R")     # Tema, cabeçalho e rodapé institucional
source("utils/header_includes.R")   # Scripts JS e estilos CSS personalizados
source("utils/sincronizar_cadastro.R") # Sincronização com banco remoto Supabase
source("utils/sincronizar_familia.R")
# 🗃️ Inicialização do banco de dados local
message("🔄 Inicializando banco de dados local...")
inicializar_bd()

# 🔍 Verificação do arquivo do banco
if (!file.exists("database/siam.sqlite")) {
  stop("❌ Banco de dados não encontrado. Verifique inicializar_bd().")
}

# ⏱️ Tempo de preenchimento (global, se necessário)
tempo_inicio <- reactiveVal(NULL)

# 👥 Carregamento de usuários válidos para login
message("🔌 Conectando ao banco para carregar usuários...")
conn <- tryCatch(
  conectar_bd(),
  error = function(e) {
    warning("⚠️ Supabase offline. Usando banco local.")
    dbConnect(RSQLite::SQLite(), "database/siam.sqlite")
  }
)

usuarios_validos <- tryCatch({
  dbGetQuery(conn, "
    SELECT 
      usuario, 
      senha_hash AS senha, 
      nome, 
      perfil   
    FROM usuarios 
    WHERE ativo = 1
  ")
}, error = function(e) {
  stop("❌ Erro ao buscar usuários: ", e$message)
})

dbDisconnect(conn)

# 🧾 Validação da consulta
if (nrow(usuarios_validos) == 0) {
  warning("⚠️ Nenhum usuário ativo encontrado no banco.")
} else {
  message("✅ Usuários ativos carregados: ", paste(usuarios_validos$usuario, collapse = ", "))
}

# 🔧 Operador seguro para valores nulos
`%||%` <- function(a, b) if (!is.null(a)) a else b

# 🪵 Log de inicialização
if (!dir.exists("logs")) dir.create("logs")
log_inicio <- paste(Sys.time(), "global.R carregado com sucesso")
write(log_inicio, file = "logs/inicializacao.log", append = TRUE)

message("✅ global.R carregado com sucesso")