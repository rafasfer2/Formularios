# Carregar pacotes (já incluídos no instalar_pacotes_siam.R)
library(googlesheets4)
library(DBI)
library(RPostgres)
library(dplyr)

# 1. Ler dados do Google Sheets
sheet_url <- "https://docs.google.com/spreadsheets/d/15n6E6eQLdYf_aWTB0JUgLUrXA7MFxWMrYhp6qpQwBjw/edit?resourcekey=&gid=869864524#gid=869864524"

# Se a planilha for pública
gs4_deauth()

# Ler os dados
dados_forms <- read_sheet(sheet_url)

# 2. Conectar ao Supabase
con <- dbConnect(
  RPostgres::Postgres(),
  dbname = "postgres",
  host = "SEU_HOST.supabase.co",
  port = 5432,
  user = "SEU_USUARIO",
  password = "SUA_SENHA",
  sslmode = "require"
)

# 3. Sincronizar com a tabela cadastro_completo
# (opcional: remover duplicados por CPF antes de inserir)
dados_novos <- dados_forms %>%
  filter(!is.na(cpf)) %>%
  distinct(cpf, .keep_all = TRUE)

# Inserir dados
dbWriteTable(
  con,
  name = "cadastro_completo",
  value = dados_novos,
  append = TRUE,
  row.names = FALSE
)

# 4. Fechar conexão
dbDisconnect(con)

message("✅ Dados sincronizados com sucesso entre Google Sheets e Supabase.")