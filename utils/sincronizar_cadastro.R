sincronizar_cadastro <- function() {
  tryCatch({
    library(googlesheets4)
    library(janitor)
    library(dplyr)
    library(stringr)
    library(lubridate)
    library(readr)
    
    # Autenticação no Google Sheets
    gs4_auth(cache = ".secrets", email = "rafasfer2@gmail.com")
    
    # Leitura da planilha
    sheet_url <- "https://docs.google.com/spreadsheets/d/15n6E6eQLdYf_aWTB0JUgLUrXA7MFxWMrYhp6qpQwBjw/edit#gid=869864524"
    dados_forms_raw <- read_sheet(sheet_url)
    
    if (nrow(dados_forms_raw) == 0) {
      message("⚠️ Planilha de cadastro inicial está vazia.")
      return(NULL)
    }
    
    # Limpeza dos nomes de colunas
    dados_forms_raw <- janitor::clean_names(dados_forms_raw)
    
    # Transformação dos dados
    dados_forms <- dados_forms_raw %>%
      mutate(
        data_cadastro = suppressWarnings(lubridate::dmy_hms(data_do_cadastro)),
        data_nascimento = suppressWarnings(parse_date(data_de_nascimento, format = "%d/%m/%Y")),
        idade = as.integer(floor(interval(data_nascimento, today()) / years(1))),
        cpf = str_remove_all(numero_do_cpf, "\\D")
      ) %>%
      filter(!is.na(cpf) & nchar(cpf) == 11) %>%
      distinct(cpf, .keep_all = TRUE) %>%
      select(
        data_hora_sistema = carimbo_de_data_hora,
        tempo_preenchimento = NA_real_,
        email_preenchedor = endereco_de_e_mail,
        unidade = rede_de_atendimento_semmu,
        profissional = profissional_responsavel_pelo_preenchimento,
        data_cadastro,
        nome_completo = nome_completo_da_assistida,
        cpf,
        telefone = ddd_telefone,
        rg = numero_do_rg,
        update_doc = NA_character_,
        tipo_demanda = tipo_de_demanda,
        unidade_origem = rede_de_atendimento_semmu,
        rede_intersetorial,
        obs_localidade = observacoes_de_localidade,
        rede_semmu,
        nome_social,
        data_nascimento,
        idade,
        naturalidade = naturalidade_codigo_ibge,
        uf,
        gestante,
        raca_cor,
        escolaridade,
        atividade_laboral,
        estado_civil = situacao_conjugal_estado_civil,
        deficiencia = deficiencia_transtorno,
        orientacao_sexual,
        identidade_genero = identidade_de_genero,
        municipio_residencia = municipio_de_residencia_codigo_ibge,
        bairro,
        logradouro = logradouro_rua_avenida,
        numero,
        quadra,
        lote,
        complemento = complemento_apto_casa,
        polo_visitado,
        zona,
        quantos_filhos = as.integer(quantos_filhos_possui),
        condicao_moradia = condicao_de_moradia,
        ubs_referencia,
        renda_media = suppressWarnings(parse_number(renda_media)),
        beneficio_social,
        valor_beneficio = parse_number(valor_de_beneficio_social_r),
        valor_renda_propria = parse_number(valor_de_renda_propria_r),
        valor_renda_pensao = parse_number(valor_de_renda_pensao_r)
      )
    
    # Conexão com Supabase
    con <- conectar_bd()
    
    # Validação de colunas
    campos_banco <- dbListFields(con, "cadastro_completo")
    campos_faltando <- setdiff(names(dados_forms), campos_banco)
    if (length(campos_faltando) > 0) {
      stop("❌ Colunas ausentes no Supabase: ", paste(campos_faltando, collapse = ", "))
    }
    
    # Prevenção contra duplicatas
    dados_existentes <- dbReadTable(con, "cadastro_completo")
    dados_novos <- anti_join(dados_forms, dados_existentes, by = "cpf")
    
    if (nrow(dados_novos) == 0) {
      message("⚠️ Nenhum dado novo para inserir.")
    } else {
      dbWriteTable(con, "cadastro_completo", dados_novos, append = TRUE, row.names = FALSE)
      message("✅ Inseridos ", nrow(dados_novos), " novos registros.")
    }
    
    dbDisconnect(con)
  }, error = function(e) {
    message("❌ Erro na sincronização: ", e$message)
  })
}