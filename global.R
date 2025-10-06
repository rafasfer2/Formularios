# 📦 Carregamento de pacotes principais
library(shiny)
library(shinyjs)
library(bslib)
library(DT)
library(DBI)
library(RSQLite)
library(digest)

# 🧠 Carregamento de funções auxiliares
source("utils/helpers.R")         # Rótulos, validações, salvamento, etc.
source("utils/validacao.R")       # Validações específicas
source("utils/conexao_bd.R")      # Função conectar_bd()
source("utils/inicializar_bd.R")  # Criação automática do banco com estrutura e dados
source("utils/layout_global.R")   # Tema, cabeçalho e rodapé institucional
source("utils/header_includes.R") # Scripts JS e estilos CSS

# 🗃️ Inicialização do banco de dados (estrutura + usuários iniciais)
inicializar_bd()

# ⏱️ Tempo de preenchimento (global)
tempo_inicio <- reactiveVal(NULL)

# 👥 Lista de usuários válidos para login (carregados do banco)
conn <- conectar_bd()
usuarios_validos <- DBI::dbGetQuery(conn, "
  SELECT 
    usuario, 
    senha_hash AS senha, 
    nome, 
    perfil 
  FROM usuarios 
  WHERE ativo = 1
")
DBI::dbDisconnect(conn)

# 🔧 Função segura para valores nulos
`%||%` <- function(a, b) if (!is.null(a)) a else b