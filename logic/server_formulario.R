server_formulario <- function(input, output, session, tela_atual, dados_familia) {
  
  # Inicializa contador de ID
  id_membro <- reactiveVal(1)
  tempo_inicio <- reactiveVal(Sys.time())
  
  # Adiciona membro à tabela
  observeEvent(input$adicionar_membro, {
    shinyjs::removeClass(selector = ".erro")  # Limpa erros visuais anteriores
    erros <- c()
    
    # Validação dos campos obrigatórios
    campos <- list(
      nome_familiar = input$nome_familiar,
      sexo_familiar = input$sexo_familiar,
      parentesco = input$parentesco,
      idade_familiar = input$idade_familiar,
      escolaridade_familiar = input$escolaridade_familiar,
      frequenta_escola = input$frequenta_escola,
      reside_com = input$reside_com
    )
    
    for (campo in names(campos)) {
      if (is.null(campos[[campo]]) || campos[[campo]] == "") {
        shinyjs::addClass(campo, "erro")
        erros <- c(erros, campo)
      }
    }
    
    # Validação do campo condicional "parentesco_outros"
    if (input$parentesco == "Outro" && (is.null(input$parentesco_outros) || input$parentesco_outros == "")) {
      shinyjs::addClass("parentesco_outros", "erro")
      erros <- c(erros, "parentesco_outros")
    }
    
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios não preenchidos",
        paste("Preencha os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE,
        footer = modalButton("Fechar")
      ))
      return()
    }
    
    # Captura do parentesco final
    parentesco_final <- if (input$parentesco == "Outro") input$parentesco_outros else input$parentesco
    
    # Criação do novo membro
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
    
    # Atualiza tabela reativa
    dados_familia$tabela <- rbind(dados_familia$tabela, novo_membro)
    id_membro(id_membro() + 1)
    
    # Limpa os campos
    updateTextInput(session, "nome_familiar", value = "")
    updateRadioButtons(session, "sexo_familiar", selected = character(0))
    updateRadioButtons(session, "parentesco", selected = character(0))
    updateTextInput(session, "parentesco_outros", value = "")
    updateNumericInput(session, "idade_familiar", value = NA)
    updateSelectInput(session, "escolaridade_familiar", selected = "")
    updateRadioButtons(session, "frequenta_escola", selected = character(0))
    updateRadioButtons(session, "reside_com", selected = character(0))
  })
  
  # Renderiza tabela com botão de remoção
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
  
  # Remove membro da tabela
  observeEvent(input$remover_membro, {
    df <- dados_familia$tabela
    df <- df[df$ID != input$remover_membro, ]
    dados_familia$tabela <- df
  })
  
  # Atualiza bairro com base na UBS
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
        ""
      )
      updateTextInput(inputId = "bairro", value = bairro_ubs)
    }
  })
  
  # Navegação entre abas
  observeEvent(input$iniciar_formulario, { tela_atual("formulario"); updateTabsetPanel(session, "abas", selected = "rede") })
  observeEvent(input$prev2, { updateTabsetPanel(session, "abas", selected = "rede") })
  observeEvent(input$prev3, { updateTabsetPanel(session, "abas", selected = "cadastro") })
  observeEvent(input$prev4, { updateTabsetPanel(session, "abas", selected = "notificacao") })
  observeEvent(input$prev5, { updateTabsetPanel(session, "abas", selected = "familia") })
  observeEvent(input$prev6, { updateTabsetPanel(session, "abas", selected = "residencia") })
  observeEvent(input$prev7, { updateTabsetPanel(session, "abas", selected = "renda") })
  observeEvent(input$next1, {
    erros <- c()
    
    # Valida unidade
    if (is.null(input$rede) || input$rede == "") {
      shinyjs::addClass("rede", "erro")
      erros <- c(erros, "Unidade de atendimento")
    }
    
    # Valida profissional conforme unidade
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
    
    # Valida polo se for SEMMU Até Você
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
    
    # Exibe erros ou avança
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios não preenchidos",
        paste("Preencha os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE
      ))
    } else {
      updateTabsetPanel(session, "abas", selected = "cadastro")
    }
  })
  observeEvent(input$next2, {
    shinyjs::removeClass(selector = ".erro")  # Limpa erros anteriores
    erros <- c()
    
    # Campos obrigatórios fixos
    if (is.null(input$data_manual) || input$data_manual == "") {
      shinyjs::addClass("data_manual", "erro")
      erros <- c(erros, "Data e hora do Cadastro")
    }
    
    if (is.null(input$nome) || input$nome == "") {
      shinyjs::addClass("nome", "erro")
      erros <- c(erros, "Nome Completo da Assistida")
    }
    
    if (is.null(input$cpf) || input$cpf == "") {
      shinyjs::addClass("cpf", "erro")
      erros <- c(erros, "Número do CPF")
    }
    
    if (is.null(input$telefone) || input$telefone == "") {
      shinyjs::addClass("telefone", "erro")
      erros <- c(erros, "(DDD) Telefone")
    }
    
    if (is.null(input$demanda) || input$demanda == "") {
      shinyjs::addClass("demanda", "erro")
      erros <- c(erros, "Tipo de Demanda")
    }
    
    # Campos condicionais: Rede Intersetorial
    if (input$demanda == "Encaminhada pela Rede Intersetorial") {
      if (is.null(input$rede_intersetorial) || input$rede_intersetorial == "") {
        shinyjs::addClass("rede_intersetorial", "erro")
        erros <- c(erros, "Rede Intersetorial")
      }
      
      if (input$rede_intersetorial == "Outros" && (is.null(input$rede_outros) || input$rede_outros == "")) {
        shinyjs::addClass("rede_outros", "erro")
        erros <- c(erros, "Rede Intersetorial (Outros)")
      }
    }
    
    # Campos condicionais: Rede SEMMU
    if (input$demanda == "Encaminhamento Interno da Rede SEMMU") {
      if (is.null(input$rede_semmu) || input$rede_semmu == "") {
        shinyjs::addClass("rede_semmu", "erro")
        erros <- c(erros, "Rede SEMMU")
      }
    }
    
    # Exibe modal ou avança
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios não preenchidos",
        paste("Preencha os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE
      ))
    } else {
      updateTabsetPanel(session, "abas", selected = "notificacao")
    }
  })
  observeEvent(input$next3, {
    limparErros(c("nome_social", "data_nascimento", "naturalidade_outros", "uf_outros", "quantos_filhos"))
    erros <- c()
    
    data_valida <- tryCatch({ as.Date(input$data_nascimento, format = "%d/%m/%Y") }, error = function(e) NA)
    idade <- if (!is.na(data_valida)) as.numeric(difftime(Sys.Date(), data_valida, units = "days")) / 365.25 else NA
    
    erros <- validarCampo(is.na(data_valida), "data_nascimento", "Data de Nascimento inválida", erros)
    erros <- validarCampo(!is.na(data_valida) && data_valida > Sys.Date(), "data_nascimento", "Data de Nascimento no futuro", erros)
    erros <- validarCampo(!is.na(idade) && idade < 10, "data_nascimento", paste0("Idade mínima: 10 anos (atual: ", round(idade, 1), ")"), erros)
    erros <- validarCampo(input$naturalidade == "Outros" && input$naturalidade_outros == "", "naturalidade_outros", "Naturalidade (Outros)", erros)
    erros <- validarCampo(input$uf == "Outros" && input$uf_outros == "", "uf_outros", "UF (Outros)", erros)
    #erros <- validarCampo(is.na(input$quantos_filhos) || input$quantos_filhos < 0, "quantos_filhos", "Número de filhos", erros)
    
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios ou inválidos",
        paste("Verifique os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE
      ))
    } else {
      updateTabsetPanel(session, "abas", selected = "familia")
    }
  })
  observeEvent(input$next4, { updateTabsetPanel(session, "abas", selected = "residencia") })
  observeEvent(input$next5, {
    shinyjs::removeClass(selector = ".erro")  # Limpa erros anteriores
    erros <- c()
    
    # Validação dos campos obrigatórios
    if (input$municipio_residencia == "Outros" && (is.null(input$municipio_outros) || input$municipio_outros == "")) {
      shinyjs::addClass("municipio_outros", "erro")
      erros <- c(erros, "Município (Outros)")
    }
    
    if (is.null(input$bairro) || input$bairro == "") {
      shinyjs::addClass("bairro", "erro")
      erros <- c(erros, "Bairro")
    }
    
    if (is.null(input$condicao_moradia) || input$condicao_moradia == "") {
      shinyjs::addClass("condicao_moradia", "erro")
      erros <- c(erros, "Condição de Moradia")
    }
    
    # Exibe modal ou avança
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios não preenchidos",
        paste("Preencha os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE
      ))
    } else {
      updateTabsetPanel(session, "abas", selected = "renda")
    }
  })
  observeEvent(input$next6, {
    shinyjs::removeClass(selector = ".erro")  # Limpa erros anteriores
    erros <- c()
    
    # Renda média mensal
    if (is.null(input$renda_media) || input$renda_media == "") {
      shinyjs::addClass("renda_media", "erro")
      erros <- c(erros, "Renda Média Mensal")
    }
    
    # Benefício social
    if (is.null(input$beneficio_social) || input$beneficio_social == "") {
      shinyjs::addClass("beneficio_social", "erro")
      erros <- c(erros, "Benefício Social")
    }
    
    # Benefício Social (Outros)
    if (input$beneficio_social == "Outros" && (is.null(input$beneficio_social_outros) || input$beneficio_social_outros == "")) {
      shinyjs::addClass("beneficio_social_outros", "erro")
      erros <- c(erros, "Informe o Benefício Social (Outros)")
    }
    
    # Valor do benefício
    if (is.null(input$valor_beneficio) || input$valor_beneficio == "") {
      shinyjs::addClass("valor_beneficio", "erro")
      erros <- c(erros, "Valor do Benefício Social")
    }
    
    # Valor de renda própria
    if (is.null(input$valor_renda_propria) || input$valor_renda_propria == "") {
      shinyjs::addClass("valor_renda_propria", "erro")
      erros <- c(erros, "Valor de Renda Própria")
    }
    
    # Valor de pensão
    if (is.null(input$valor_renda_pensao) || input$valor_renda_pensao == "") {
      shinyjs::addClass("valor_renda_pensao", "erro")
      erros <- c(erros, "Valor de Renda Pensão")
    }
    
    # Exibe modal ou avança
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios não preenchidos",
        paste("Preencha os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE
      ))
    } else {
      updateTabsetPanel(session, "abas", selected = "revisao")
    }
  })
  
  observeEvent(input$confirmar_envio, {
    # Aqui você pode incluir validações finais se quiser
    # Exemplo: verificar se todos os campos obrigatórios estão preenchidos
    
    # Simulação de envio (substitua pela lógica real)
    output$resposta_final <- renderText({
      "✅ Formulário enviado com sucesso! Seus dados foram registrados no sistema."
    })
    
    # Se quiser salvar em banco, planilha ou API, chame aqui a função de envio real
    # ex: enviarFormulario(input, dados_familia$tabela)
  })
  

}