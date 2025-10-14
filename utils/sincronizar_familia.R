sincronizar_familia <- function() {
  tryCatch({
    # Autenticação persistente no Google Sheets
    library(googlesheets4)
    library(janitor)
    library(stringr)
    gs4_auth(cache = ".secrets", email = "rafasfer2@gmail.com")
    
    # Link da planilha de composição familiar
    sheet_url_familia <- "https://docs.google.com/spreadsheets/d/1v2Dnto3sVRBXoj3eNFIedh4rjKxHMgzX8yxLVPoTzUU/edit#gid=565862886"
    dados_familia_raw <- read_sheet(sheet_url_familia)
    
    # Verificação se a planilha está vazia
    if (nrow(dados_familia_raw) == 0) {
      message("⚠️ Planilha de composição familiar está vazia.")
      return(NULL)
    }
    
    # Limpeza dos nomes de colunas
    dados_familia_raw <- janitor::clean_names(dados_familia_raw)
    
    # Verifica se a coluna cpf_da_mulher existe
    if (!"cpf_da_mulher" %in% names(dados_familia_raw)) {
      stop("❌ Coluna 'cpf_da_mulher' não encontrada na planilha. Verifique o nome da coluna.")
    }
    
    # Transformação dos dados
    dados_familia <- dados_familia_raw %>%
      transmute(
        cpf_principal     = str_remove_all(cpf_da_mulher, "\\D"),
        nome              = nome_do_membro,
        sexo              = sexo,
        parentesco        = parentesco,
        idade             = as.integer(idade),
        escolaridade      = escolaridade,
        frequenta_escola  = frequenta_escola,
        reside_com        = reside_com
      ) %>%
      filter(!is.na(cpf_principal) & nchar(cpf_principal) == 11)
    
    # Conexão com Supabase
    con <- conectar_bd()
    
    # Validação de colunas
    campos_banco <- dbListFields(con, "composicao_familiar")
    campos_faltando <- setdiff(names(dados_familia), campos_banco)
    if (length(campos_faltando) > 0) {
      stop("❌ Colunas ausentes no Supabase: ", paste(campos_faltando, collapse = ", "))
    }
    
    # Prevenção contra duplicatas
    dados_existentes <- dbReadTable(con, "composicao_familiar")
    dados_novos <- anti_join(dados_familia, dados_existentes, by = c("cpf_principal", "nome"))
    
    if (nrow(dados_novos) == 0) {
      message("⚠️ Nenhum dado novo para inserir.")
    } else {
      dbWriteTable(con, "composicao_familiar", dados_novos, append = TRUE, row.names = FALSE)
      message("✅ Inseridos ", nrow(dados_novos), " novos registros.")
    }
    
    dbDisconnect(con)
  }, error = function(e) {
    message("❌ Erro na sincronização da família: ", e$message)
  })
}