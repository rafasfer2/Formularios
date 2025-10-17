server_formulario <- function(input, output, session, tela_atual, dados_familia, login_status, usuario_logado) {
  
  # ⏱️ Tempo de início do preenchimento
  tempo_inicio <- reactiveVal(Sys.time())
  id_membro <- reactiveVal(1)
  
  # ➕ Adiciona membro à tabela
  observeEvent(input$adicionar_membro, {
    limparErros(c(
      "nome_familiar", "sexo_familiar", "parentesco", "idade_familiar",
      "escolaridade_familiar", "frequenta_escola", "reside_com", "parentesco_outros"
    ))
    
    campos <- list(
      nome_familiar = input$nome_familiar,
      sexo_familiar = input$sexo_familiar,
      parentesco = input$parentesco,
      idade_familiar = input$idade_familiar,
      escolaridade_familiar = input$escolaridade_familiar,
      frequenta_escola = input$frequenta_escola,
      reside_com = input$reside_com
    )
    
    erros <- names(Filter(function(x) is.null(x) || x == "", campos))
    
    if (input$parentesco == "Outro" && (is.null(input$parentesco_outros) || input$parentesco_outros == "")) {
      shinyjs::addClass("parentesco_outros", "erro")
      erros <- c(erros, "parentesco_outros")
    }
    
    if (length(erros) > 0) {
      exibirErros("⚠️ Campos obrigatórios não preenchidos", erros)
      return()
    }
    
    parentesco_final <- if (input$parentesco == "Outro") input$parentesco_outros else input$parentesco
    
    novo_membro <- data.frame(
      ID = id_membro(),
      Nome = input$nome_familiar,
      Sexo = input$sexo_familiar,
      Parentesco = parentesco_final,
      Idade = input$idade_familiar,
      Escola = input$frequenta_escola,
      Escolaridade = input$escolaridade_familiar,
      Reside = input$reside_com,
      stringsAsFactors = FALSE
    )
    
    dados_familia$tabela <- rbind(dados_familia$tabela, novo_membro)
    id_membro(id_membro() + 1)
    
    # 🔄 Limpa os campos
    updateTextInput(session, "nome_familiar", value = "")
    updateRadioButtons(session, "sexo_familiar", selected = character(0))
    updateRadioButtons(session, "parentesco", selected = character(0))
    updateTextInput(session, "parentesco_outros", value = "")
    updateNumericInput(session, "idade_familiar", value = NA)
    updateSelectInput(session, "escolaridade_familiar", selected = "")
    updateRadioButtons(session, "frequenta_escola", selected = character(0))
    updateRadioButtons(session, "reside_com", selected = character(0))
  })
  
  # 📋 Renderiza tabela com botão de remoção
  output$tabela_familia <- DT::renderDataTable({
    df <- dados_familia$tabela
    if (nrow(df) == 0) return(NULL)
    
    df$Remover <- sprintf(
      '<button class="btn btn-danger btn-sm delete-btn" onclick="Shiny.setInputValue(\'remover_membro\', %d, {priority: \'event\'});">🗑️</button>',
      df$ID
    )
    
    DT::datatable(
      df[, c("Nome", "Parentesco", "Sexo", "Idade", "Escola", "Escolaridade", "Reside", "Remover")],
      escape = FALSE,
      rownames = FALSE,
      options = list(dom = 't', pageLength = 5)
    )
  })
  
  # ❌ Remove membro da tabela
  observeEvent(input$remover_membro, {
    df <- dados_familia$tabela
    dados_familia$tabela <- df[df$ID != input$remover_membro, ]
  })
  
  # 🏘️ Atualiza bairro com base na UBS
  observeEvent(input$ubs_referencia, {
    if (input$ubs_referencia != "Outros") {
      bairro_ubs <- switch(
        input$ubs_referencia,
        "UBS Novo Brasil" = "Chácara das Estrelas",
        "UBS Nova Carajás" = "Nova Carajás",
        "UBS VS 10" = "VS 10",
        "UBS Casas Populares 2" = "Casas Populares",
        "UBS Liberdade I" = "Liberdade",
        "Posto de Saúde Liberdade 1" = "Liberdade",
        "UBS Guanabara" = "Guanabara",
        "UBS Fortaleza" = "Bairro da Paz",
        "UBS Cidade Nova" = "Cidade Nova",
        "UBS Jardim Canadá" = "Jardim Canadá",
        "UBS Grazielly Caetano" = "Cidade Jardim",
        NULL
      )
      updateTextInput(inputId = "bairro", value = bairro_ubs %||% "")
    }
  })
  
  # 🧭 Navegação entre abas
  observeEvent(input$iniciar_formulario, {
    tela_atual("formulario")
    updateTabsetPanel(session, "abas", selected = "rede")
  })

  # ⬅️ Botões de retorno
  observeEvent(input$prev2, { updateTabsetPanel(session, "abas", selected = "rede") })
  observeEvent(input$prev3, { updateTabsetPanel(session, "abas", selected = "cadastro") })
  observeEvent(input$prev4, { updateTabsetPanel(session, "abas", selected = "notificacao") })
  observeEvent(input$prev5, { updateTabsetPanel(session, "abas", selected = "familia") })
  observeEvent(input$prev6, { updateTabsetPanel(session, "abas", selected = "residencia") })
  observeEvent(input$prev7, { updateTabsetPanel(session, "abas", selected = "renda") })
  
  # ➡️ Avanço: Rede de Atendimento
  observeEvent(input$next1, {
    limparErros(c("rede", "profissional_crm", "profissional_mainha", "profissional_abrigo", "profissional_movel", "polo_visitado", "polo_outros"))
    erros <- c()
    
    if (is.null(input$rede) || input$rede == "") {
      shinyjs::addClass("rede", "erro")
      erros <- c(erros, "Unidade de atendimento")
    }
    
    profissional <- switch(input$rede,
                           "CRM (Centro de Referência da Mulher)" = input$profissional_crm,
                           "Casa de Mainha" = input$profissional_mainha,
                           "Casa Abrigo" = input$profissional_abrigo,
                           "SEMMU Até Você" = input$profissional_movel,
                           NULL
    )
    
    if (is.null(profissional) || profissional == "Selecione" || profissional == "") {
      campo_id <- switch(input$rede,
                         "CRM (Centro de Referência da Mulher)" = "profissional_crm",
                         "Casa de Mainha" = "profissional_mainha",
                         "Casa Abrigo" = "profissional_abrigo",
                         "SEMMU Até Você" = "profissional_movel"
      )
      shinyjs::addClass(campo_id, "erro")
      erros <- c(erros, "Profissional Responsável")
    }
    
    if (input$rede == "SEMMU Até Você") {
      if (is.null(input$polo_visitado) || input$polo_visitado == "Selecione" || input$polo_visitado == "") {
        shinyjs::addClass("polo_visitado", "erro")
        erros <- c(erros, "Polo Visitado")
      }
      if (input$polo_visitado == "Outros" && (is.null(input$polo_outros) || input$polo_outros == "")) {
        shinyjs::addClass("polo_outros", "erro")
        erros <- c(erros, "Nome do Polo (Outros)")
      }
    }
    
    if (length(erros) > 0) {
      exibirErros("⚠️ Campos obrigatórios não preenchidos", erros)
    } else {
      updateTabsetPanel(session, "abas", selected = "cadastro")
    }
  })
  
  # ➡️ Avanço: Dados Iniciais
  observeEvent(input$next2, {
    limparErros(c("data_manual", "nome", "cpf", "telefone", "demanda", "rede_intersetorial", "rede_outros", "rede_semmu"))
    erros <- c()
    
    if (input$data_manual == "") erros <- c(erros, "Data e hora do Cadastro")
    if (input$nome == "") erros <- c(erros, "Nome Completo da Assistida")
    if (input$cpf == "") erros <- c(erros, "Número do CPF")
    if (input$telefone == "") erros <- c(erros, "(DDD) Telefone")
    if (input$demanda == "") erros <- c(erros, "Tipo de Demanda")
    
    if (input$demanda == "Encaminhada pela Rede Intersetorial") {
      if (input$rede_intersetorial == "") erros <- c(erros, "Rede Intersetorial")
      if (input$rede_intersetorial == "Outros" && input$rede_outros == "") erros <- c(erros, "Rede Intersetorial (Outros)")
    }
    
    if (input$demanda == "Encaminhamento Interno da Rede SEMMU") {
      if (input$rede_semmu == "") erros <- c(erros, "Rede SEMMU")
    }
    
    if (length(erros) > 0) {
      exibirErros("⚠️ Campos obrigatórios não preenchidos", erros)
    } else {
      updateTabsetPanel(session, "abas", selected = "notificacao")
    }
  })
  
  # ➡️ Avanço: Notificação Individual
  observeEvent(input$next3, {
    limparErros(c("nome_social", "data_nascimento", "naturalidade_outros", "uf_outros"))
    erros <- c()
    
    data_valida <- tryCatch({ as.Date(input$data_nascimento, format = "%d/%m/%Y") }, error = function(e) NA)
    idade <- if (!is.na(data_valida)) as.numeric(difftime(Sys.Date(), data_valida, units = "days")) / 365.25 else NA
    
    erros <- validarCampo(is.na(data_valida), "data_nascimento", "Data de Nascimento inválida", erros)
    erros <- validarCampo(!is.na(data_valida) && data_valida > Sys.Date(), "data_nascimento", "Data de Nascimento no futuro", erros)
    erros <- validarCampo(!is.na(idade) && idade < 10, "data_nascimento", paste0("Idade mínima: 10 anos (atual: ", round(idade, 1), ")"), erros)
    erros <- validarCampo(input$naturalidade == "Outros" && input$naturalidade_outros == "", "naturalidade_outros", "Naturalidade (Outros)", erros)
    erros <- validarCampo(input$uf == "Outros" && input$uf_outros == "", "uf_outros", "UF (Outros)", erros)
    
    if (length(erros) > 0) {
      exibirErros("⚠️ Campos obrigatórios ou inválidos", erros)
    } else {
      updateTabsetPanel(session, "abas", selected = "familia")
    }
  })
  
  # ➡️ Avanço: Dados Familiares → Residência
  observeEvent(input$next4, {
    updateTabsetPanel(session, "abas", selected = "residencia")
  })
  # ➡️ Avanço: Dados de Residência → Renda
  observeEvent(input$next5, {
    limparErros(c("municipio_outros", "bairro", "condicao_moradia"))
    erros <- c()
    
    erros <- validarCampo(input$municipio_residencia == "Outros" && input$municipio_outros == "", "municipio_outros", "Município (Outros)", erros)
    erros <- validarCampo(input$bairro == "", "bairro", "Bairro", erros)
    erros <- validarCampo(input$condicao_moradia == "", "condicao_moradia", "Condição de Moradia", erros)
    
    if (length(erros) > 0) {
      exibirErros("⚠️ Campos obrigatórios não preenchidos", erros)
    } else {
      updateTabsetPanel(session, "abas", selected = "renda")
    }
  })
  
  # ➡️ Avanço: Renda → Revisão
  observeEvent(input$next6, {
    limparErros(c("renda_media", "beneficio_social", "beneficio_social_outros", "valor_beneficio", "valor_renda_propria", "valor_renda_pensao"))
    erros <- c()
    
    erros <- validarCampo(input$renda_media == "", "renda_media", "Renda Média Mensal", erros)
    erros <- validarCampo(input$beneficio_social == "", "beneficio_social", "Benefício Social", erros)
    erros <- validarCampo(input$beneficio_social == "Outros" && input$beneficio_social_outros == "", "beneficio_social_outros", "Informe o Benefício Social (Outros)", erros)
    erros <- validarCampo(input$valor_beneficio == "", "valor_beneficio", "Valor do Benefício Social", erros)
    erros <- validarCampo(input$valor_renda_propria == "", "valor_renda_propria", "Valor de Renda Própria", erros)
    erros <- validarCampo(input$valor_renda_pensao == "", "valor_renda_pensao", "Valor de Renda Pensão", erros)
    
    if (length(erros) > 0) {
      exibirErros("⚠️ Campos obrigatórios não preenchidos", erros)
    } else {
      updateTabsetPanel(session, "abas", selected = "revisao")
    }
  })
  
  # ✅ Envio final do formulário
  observeEvent(input$confirmar_envio, {
    limparErros(c("nome", "cpf"))
    erros <- c()
    
    # Função para salvar dados no banco
    salvar_dados <- function(dados_forms, dados_familia) {
      con <- conectar_bd()
      DBI::dbWriteTable(con, "cadastro_completo", as.data.frame(dados_forms), append = TRUE, row.names = FALSE)
      if (nrow(dados_familia) > 0) {
        dados_familia$cpf_principal <- dados_forms$cpf
        DBI::dbWriteTable(con, "composicao_familiar", dados_familia, append = TRUE, row.names = FALSE)
      }
      DBI::dbDisconnect(con)
    }
    
    req(tempo_inicio())
    tempo_total <- difftime(Sys.time(), tempo_inicio(), units = "mins")
    
    # Validação dos campos obrigatórios
    campos_obrigatorios <- list(nome = "Nome Completo", cpf = "CPF")
    for (campo in names(campos_obrigatorios)) {
      if (is.null(input[[campo]]) || input[[campo]] == "") {
        shinyjs::addClass(campo, "erro")
        erros <- c(erros, campos_obrigatorios[[campo]])
      }
    }
    
    if (length(erros) > 0) {
      exibirErros("⚠️ Campos obrigatórios ausentes", erros)
      return()
    }
    
    # Determina profissional e polo conforme seleção
    profissional <- switch(input$rede,
                           "CRM (Centro de Referência da Mulher)" = input$profissional_crm,
                           "Casa de Mainha" = input$profissional_mainha,
                           "Casa Abrigo" = input$profissional_abrigo,
                           "SEMMU Até Você" = input$profissional_movel,
                           NULL
    )
    
    polo <- if (input$rede == "SEMMU Até Você") {
      if (input$polo_visitado == "Outros") input$polo_outros else input$polo_visitado
    } else NA
    
    safe <- function(x) if (is.null(x) || length(x) == 0) NA else x
    
    membros <- dados_familia$tabela
    
    if (!"cpf_principal" %in% names(membros) || any(is.na(membros$cpf_principal))) {
      membros$cpf_principal <- rep(input$cpf, nrow(membros))
    }
    
    filhos <- membros[tolower(membros$parentesco) == "filho(a)", ]
    quantos_filhos <- nrow(filhos)
    
    calcular_idade <- function(data_nascimento) {
      if (is.na(data_nascimento) || length(data_nascimento) == 0) {
        return(NA_integer_)
      }
      hoje <- Sys.Date()
      intervalo <- lubridate::interval(data_nascimento, hoje)
      idade <- lubridate::as.period(intervalo)$year
      return(idade)
    }
    
    dados <- data.frame(
      data_hora_sistema     = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
      tempo_preenchimento   = round(as.numeric(tempo_total), 2),
      email_preenchedor     = usuarios_validos$email_institucional[usuarios_validos$usuario == usuario_logado()],
      unidade               = safe(input$rede),
      profissional          = login_status$nome,
      data_hora_informada   = safe(input$data_manual),
      nome_completo         = safe(input$nome),
      cpf                   = safe(input$cpf),
      telefone              = safe(input$telefone),
      rg                    = safe(input$rg),
      update_doc            = safe(input$documento),
      tipo_demanda          = safe(input$demanda),
      rede_intersetorial    = safe(input$rede_intersetorial),
      obs_localidade        = safe(input$obs_localidade),
      rede_semmu            = safe(input$rede_semmu),
      nome_social           = safe(input$nome_social),
      data_nascimento       = safe(input$data_nascimento),
      idade                 = calcular_idade(lubridate::dmy(input$data_nascimento)),
      naturalidade          = safe(if (input$naturalidade == "Outros") input$naturalidade_outros else input$naturalidade),
      uf                    = safe(if (input$uf == "Outros") input$uf_outros else input$uf),
      gestante              = safe(input$gestante),
      raca_cor              = safe(input$raca_cor),
      escolaridade          = safe(input$escolaridade),
      atividade_laboral     = safe(if (input$atividade_laboral == "Outros") input$atividade_outros else input$atividade_laboral),
      estado_civil          = safe(input$estado_civil),
      deficiencia           = safe(if (input$deficiencia == "Outros") input$deficiencia_outros else input$deficiencia),
      orientacao_sexual     = safe(if (input$orientacao_sexual == "Outros") input$orientacao_outros else input$orientacao_sexual),
      identidade_genero     = safe(if (input$identidade_genero == "Outros") input$identidade_outros else input$identidade_genero),
      municipio_residencia  = safe(if (input$municipio_residencia == "Outros") input$municipio_outros else input$municipio_residencia),
      bairro                = safe(input$bairro),
      logradouro            = safe(input$logradouro),
      numero                = safe(input$numero),
      quadra                = safe(input$quadra),
      lote                  = safe(input$lote),
      complemento           = safe(input$complemento),
      polo_visitado         = safe(polo),
      zona_residencia       = safe(input$zona),
      quantos_filhos        = quantos_filhos,
      condicao_moradia      = safe(input$condicao_moradia),
      ubs_referencia        = safe(input$ubs_referencia),
      renda_media           = safe(input$renda_media),
      beneficio_social      = safe(input$beneficio_social),
      valor_beneficio       = safe(input$valor_beneficio),
      valor_renda_propria   = safe(input$valor_renda_propria),
      valor_renda_pensao    = safe(input$valor_renda_pensao),
      stringsAsFactors      = FALSE
    )
    
    tryCatch({
      salvar_dados(dados, membros)
      showModal(modalDialog(
        title = "✅ Cadastro enviado com sucesso",
        paste("CPF:", dados$cpf, "| Membros:", nrow(membros)),
        easyClose = FALSE,
        footer = tagList(
          modalButton("Fechar"),
          actionButton("iniciar_novo", "Novo Cadastro", class = "btn btn-primary")
        )
      ))
      tela_atual("painel")
    }, error = function(e) {
      showModal(modalDialog(
        title = "❌ Erro ao salvar",
        paste("Ocorreu um erro ao tentar salvar os dados:", conditionMessage(e)),
        easyClose = TRUE,
        footer = modalButton("Fechar")
      ))
    })
  })
  
  observeEvent(input$iniciar_novo, {
    removeModal()
    tela_atual("formulario")
    updateTabsetPanel(session, "abas", selected = "Rede de Atendimento SEMMU")
    tempo_inicio(Sys.time())
    dados_familia$tabela <- data.frame()
    limparFormulario(session, c("nome", "cpf", "telefone", "data_manual"))
  })
  
}