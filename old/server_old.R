server <- function(input, output, session) {
  
  limparErros <- function(campos) {
    lapply(campos, function(campo) shinyjs::removeClass(campo, "erro"))
  }   # Função auxiliar para limpar erros
  validarCampo <- function(condicao, id, mensagem, erros) {
    if (condicao) {
      shinyjs::addClass(id, "erro")
      erros <- c(erros, mensagem)
    }
    return(erros)
  } # Função auxiliar para validar campos
  
  observe({ session$sendCustomMessage("applyMasks", list()) }) # Aplica máscaras nos campos ao carregar
  ######################################################################
  ###########              Navegação entre abas             ############
  observeEvent(input$iniciar, { updateTabsetPanel(session, "abas", selected = "Rede de Atendimento SEMMU")  }) # Navegação inicial
  observeEvent(input$prev2, { updateTabsetPanel(session, "abas", selected = "Rede de Atendimento SEMMU") })
  observeEvent(input$prev3, { updateTabsetPanel(session, "abas", selected = "Dados Iniciais de Cadastro") })
  observeEvent(input$prev4, { updateTabsetPanel(session, "abas", selected = "Notificação Individual") })
  observeEvent(input$prev5, { updateTabsetPanel(session, "abas", selected = "Dados Familiares") })
  observeEvent(input$prev6, { updateTabsetPanel(session, "abas", selected = "Dados de Residência")})
  observeEvent(input$prev_revisao, { updateTabsetPanel(session, "abas", selected = "Descrição da Fonte de Renda")})
  
  observeEvent(input$next1, { updateTabsetPanel(session, "abas", selected = "Dados Iniciais de Cadastro") })
  observeEvent(input$next2, { updateTabsetPanel(session, "abas", selected = "Notificação Individual") })
  observeEvent(input$next3, {
    limparErros(c("nome_social", "data_nascimento", "naturalidade_outros", "uf_outros", "quantos_filhos"))
    erros <- c()
    
    # ⚠️ Nome Social NÃO é obrigatório — validação removida
    
    # Validação da Data de Nascimento
    data_valida <- tryCatch({
      as.Date(input$data_nascimento, format = "%d/%m/%Y")
    }, error = function(e) NA)
    
    idade <- if (!is.na(data_valida)) {
      as.numeric(difftime(Sys.Date(), data_valida, units = "days")) / 365.25
    } else {
      NA
    }
    
    erros <- validarCampo(is.na(data_valida), "data_nascimento", "Data de Nascimento inválida", erros)
    erros <- validarCampo(!is.na(data_valida) && data_valida > Sys.Date(), "data_nascimento", "Data de Nascimento no futuro", erros)
    erros <- validarCampo(!is.na(idade) && idade < 10, "data_nascimento", paste0("Idade mínima: 10 anos (atual: ", round(idade, 1), ")"), erros)
    
    erros <- validarCampo(input$naturalidade == "Outros" && input$naturalidade_outros == "", "naturalidade_outros", "Naturalidade (Outros)", erros)
    erros <- validarCampo(input$uf == "Outros" && input$uf_outros == "", "uf_outros", "UF (Outros)", erros)
    erros <- validarCampo(is.na(input$quantos_filhos) || input$quantos_filhos < 0, "quantos_filhos", "Número de filhos", erros)
    
    # Exibir modal ou avançar
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios ou inválidos",
        paste("Verifique os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE
      ))
    } else {
      updateTabsetPanel(session, "abas", selected = "familia")
    }
  })   #{ updateTabsetPanel(session, "abas", selected = "Dados Familiares") })
  observeEvent(input$next4, { updateTabsetPanel(session, "abas", selected = "Dados de Residência") })
  observeEvent(input$next5, {
    shinyjs::removeClass("municipio_outros", "erro")
    shinyjs::removeClass("bairro", "erro")
    shinyjs::removeClass("logradouro", "erro")
    shinyjs::removeClass("numero", "erro")
    shinyjs::removeClass("zona", "erro")
    shinyjs::removeClass("condicao_moradia", "erro")
    
    erros <- c()
    
    if (input$municipio_residencia == "Outros" && input$municipio_outros == "") {
      shinyjs::addClass("municipio_outros", "erro")
      erros <- c(erros, "Município (Outros)")
    }
    
    if (input$bairro == "") {
      shinyjs::addClass("bairro", "erro")
      erros <- c(erros, "Bairro")
    }
    
    if (input$logradouro == "") {
      shinyjs::addClass("logradouro", "erro")
      erros <- c(erros, "Logradouro")
    }
    
    if (input$numero == "") {
      shinyjs::addClass("numero", "erro")
      erros <- c(erros, "Número")
    }
    
    if (input$zona == "") {
      shinyjs::addClass("zona", "erro")
      erros <- c(erros, "Zona de Residência")
    }
    
    if (input$condicao_moradia == "") {
      shinyjs::addClass("condicao_moradia", "erro")
      erros <- c(erros, "Condição de Moradia")
    }
    
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios ou inválidos",
        paste("Verifique os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE
      ))
    } else {
      updateTabsetPanel(session, "abas", selected = "Descrição da fonte de renda")
    }
  })   #{ updateTabsetPanel(session, "abas", selected = "Descrição da Fonte de Renda") })
  observeEvent(input$enviar, {
    updateTabsetPanel(session, "abas", selected = "Revisão Final")
  })  #{ updateTabsetPanel(session, "abas", selected = "Revisão Final") })
  ###########              Navegação entre abas             ############
  ######################################################################
  output$resumo_dados <- renderUI({
    tagList(
      h4("🧭 Unidade de Atendimento"),
      verbatimTextOutput("resumo_unidade"),
      h4("👤 Dados Pessoais"),
      verbatimTextOutput("resumo_pessoais"),
      h4("🏠 Dados de Residência"),
      verbatimTextOutput("resumo_residencia"),
      h4("💰 Informações de Renda"),
      verbatimTextOutput("resumo_renda")
    )
  })
  
  output$resumo_unidade <- renderText({
    profissional <- switch(input$rede,
                           "CRM (Centro de Referência da Mulher)" = input$profissional_crm,
                           "Casa de Mainha" = input$profissional_mainha,
                           "Casa Abrigo" = input$profissional_abrigo,
                           "SEMMU Até Você" = input$profissional_movel
    )
    polo <- if (input$rede == "SEMMU Até Você") {
      if (input$polo_visitado == "Outros") input$polo_outros else input$polo_visitado
    } else {
      NA
    }
    paste("Unidade:", input$rede,
          "\nProfissional:", profissional,
          if (!is.na(polo)) paste("\nPolo Visitado:", polo) else "")
  })
  
  output$resumo_pessoais <- renderText({
    paste("Nome Social:", input$nome_social,
          "\nData de Nascimento:", input$data_nascimento,
          "\nRaça/Cor:", input$raca_cor,
          "\nEscolaridade:", input$escolaridade,
          "\nAtividade Laboral:", input$atividade_laboral,
          "\nEstado Civil:", input$estado_civil,
          "\nDeficiência:", input$deficiencia,
          "\nOrientação Sexual:", input$orientacao_sexual,
          "\nIdentidade de Gênero:", input$identidade_genero)
  })
  
  output$resumo_residencia <- renderText({
    municipio <- if (input$municipio_residencia == "Outros") input$municipio_outros else input$municipio_residencia
    paste("Município:", municipio,
          "\nBairro:", input$bairro,
          "\nLogradouro:", input$logradouro,
          "\nNúmero:", input$numero,
          "\nQuadra:", input$quadra,
          "\nLote:", input$lote,
          "\nComplemento:", input$complemento,
          "\nZona:", input$zona,
          "\nCondição de Moradia:", input$condicao_moradia,
          "\nUBS de Referência:", input$ubs_referencia)
  })
  
  output$resumo_renda <- renderText({
    paste("Renda Média:", input$renda_media,
          "\nBenefício Social:", input$beneficio_social,
          "\nValor do Benefício (R$):", input$valor_beneficio,
          "\nRenda Própria (R$):", input$valor_renda_propria,
          "\nRenda Pensão (R$):", input$valor_renda_pensao)
  })
  
  observeEvent(input$confirmar_envio, {
    profissional <- switch(input$rede,
                           "CRM (Centro de Referência da Mulher)" = input$profissional_crm,
                           "Casa de Mainha" = input$profissional_mainha,
                           "Casa Abrigo" = input$profissional_abrigo,
                           "SEMMU Até Você" = input$profissional_movel
    )
    
    polo <- if (input$rede == "SEMMU Até Você") {
      if (input$polo_visitado == "Outros") input$polo_outros else input$polo_visitado
    } else {
      NA
    }
    
    municipio <- if (input$municipio_residencia == "Outros") input$municipio_outros else input$municipio_residencia
    
    atividade <- if (input$atividade_laboral == "Outros") input$atividade_outros else input$atividade_laboral
    deficiencia <- if (input$deficiencia == "Outros") input$deficiencia_outros else input$deficiencia
    
    dados <- data.frame(
      DataHoraSistema = format(Sys.time(), "%d/%m/%Y %H:%M:%S"),
      DataHoraInformada = input$data_manual,
      Unidade = input$rede,
      Profissional = profissional,
      PoloVisitado = polo,
      NomeSocial = input$nome_social,
      DataNascimento = input$data_nascimento,
      Naturalidade = if (input$naturalidade == "Outros") input$naturalidade_outros else input$naturalidade,
      UF = if (input$uf == "Outros") input$uf_outros else input$uf,
      QuantosFilhos = input$quantos_filhos,
      Gestante = input$gestante,
      RacaCor = input$raca_cor,
      Escolaridade = input$escolaridade,
      AtividadeLaboral = atividade,
      EstadoCivil = input$estado_civil,
      Deficiencia = deficiencia,
      OrientacaoSexual = input$orientacao_sexual,
      IdentidadeGenero = input$identidade_genero,
      MunicipioResidencia = municipio,
      Bairro = input$bairro,
      Logradouro = input$logradouro,
      Numero = input$numero,
      Quadra = input$quadra,
      Lote = input$lote,
      Complemento = input$complemento,
      ZonaResidencia = input$zona,
      CondicaoMoradia = input$condicao_moradia,
      UBSReferencia = input$ubs_referencia,
      RendaMedia = input$renda_media,
      BeneficioSocial = input$beneficio_social,
      ValorBeneficio = input$valor_beneficio,
      ValorRendaPropria = input$valor_renda_propria,
      ValorRendaPensao = input$valor_renda_pensao,
      stringsAsFactors = FALSE
    )
    
    # Upload do documento
    if (!is.null(input$documento)) {
      nome_arquivo <- paste0("documento_", gsub("[^0-9]", "", Sys.time()), "_", gsub("\\D", "", input$cpf))
      caminho_destino <- file.path("documentos", paste0(nome_arquivo, "_", input$documento$name))
      dir.create("documentos", showWarnings = FALSE)
      file.copy(input$documento$datapath, caminho_destino)
    }
    
    # Salvamento em CSV
    write.table(dados, file = "cadastros_semmu.csv", sep = ";", row.names = FALSE,
                col.names = !file.exists("cadastros_semmu.csv"), append = TRUE)
    
    showModal(modalDialog(
      title = "✅ Cadastro enviado com sucesso!",
      "Os dados foram registrados e salvos com sucesso.",
      easyClose = TRUE,
      footer = modalButton("Fechar")
    ))
    
    updateTabsetPanel(session, "abas", selected = "Início")
  })
  
  familia <- reactiveValues(lista = data.frame(
    Nome = character(),
    Parentesco = character(),
    Sexo = character(),
    Idade = integer(),
    FrequentaEscola = character(),
    Escolaridade = character(),
    ResideCom = character(),
    stringsAsFactors = FALSE
  ))
  
  observeEvent(input$adicionar_membro, {
    novo <- data.frame(
      Nome = input$nome_familiar,
      Parentesco = input$parentesco,
      Sexo = input$sexo_familiar,
      Idade = input$idade_familiar,
      FrequentaEscola = input$frequenta_escola,
      Escolaridade = input$escolaridade_familiar,
      ResideCom = input$reside_com,
      stringsAsFactors = FALSE
    )
    
    familia$lista <- rbind(familia$lista, novo)
    
    # Limpar campos após adicionar
    updateTextInput(session, "nome_familiar", value = "")
    updateSelectInput(session, "parentesco", selected = "")
    updateSelectInput(session, "sexo_familiar", selected = "")
    updateNumericInput(session, "idade_familiar", value = NA)
    updateSelectInput(session, "frequenta_escola", selected = "")
    updateSelectInput(session, "escolaridade_familiar", selected = "")
    updateSelectInput(session, "reside_com", selected = "")
  })
  
  output$tabela_familia <- DT::renderDataTable({
    df <- familia$lista
    if (nrow(df) == 0) return(NULL)
    
    # Adiciona colunas de ação
    df$Editar <- sprintf(
      '<button class="btn btn-warning btn-sm editar" data-linha="%s">✏️</button>',
      seq_len(nrow(df))
    )
    df$Remover <- sprintf(
      '<button class="btn btn-danger btn-sm remover" data-linha="%s">🗑️</button>',
      seq_len(nrow(df))
    )
    
    DT::datatable(
      df,
      escape = FALSE,
      selection = "none",
      rownames = FALSE,
      options = list(dom = 't', paging = FALSE)
    )
  })
  
  observeEvent(input$alterar_membro, {
    linha <- input$tabela_familia_rows_selected
    if (is.null(linha)) {
      showModal(modalDialog("Selecione um membro para alterar.", easyClose = TRUE))
      return()
    }
    
    membro <- familia$lista[linha, ]
    
    showModal(modalDialog(
      title = "✏️ Alterar Membro da Família",
      textInput("editar_nome", "Nome", value = membro$Nome),
      selectInput("editar_parentesco", "Parentesco", choices = c("Filho", "Filha", "Cônjuge", "Outro"), selected = membro$Parentesco),
      selectInput("editar_sexo", "Sexo", choices = c("Masculino", "Feminino", "Outro"), selected = membro$Sexo),
      numericInput("editar_idade", "Idade", value = membro$Idade, min = 0),
      selectInput("editar_frequenta", "Frequenta Escola?", choices = c("Sim", "Não"), selected = membro$FrequentaEscola),
      selectInput("editar_escolaridade", "Escolaridade", choices = c("Fundamental", "Médio", "Superior", "Não informado"), selected = membro$Escolaridade),
      selectInput("editar_reside", "Reside com a assistida?", choices = c("Sim", "Não"), selected = membro$ResideCom),
      footer = tagList(
        modalButton("Cancelar"),
        actionButton("confirmar_edicao", "Salvar Alterações", class = "btn-success")
      )
    ))
  })
  
  observeEvent(input$confirmar_edicao, {
    linha <- input$tabela_familia_rows_selected
    familia$lista[linha, ] <- data.frame(
      Nome = input$editar_nome,
      Parentesco = input$editar_parentesco,
      Sexo = input$editar_sexo,
      Idade = input$editar_idade,
      FrequentaEscola = input$editar_frequenta,
      Escolaridade = input$editar_escolaridade,
      ResideCom = input$editar_reside,
      stringsAsFactors = FALSE
    )
    removeModal()
  })
  
  observeEvent(input$remover_membro, {
    linha <- input$tabela_familia_rows_selected
    if (is.null(linha)) {
      showModal(modalDialog("Selecione um membro para remover.", easyClose = TRUE))
      return()
    }
    
    showModal(modalDialog(
      title = "🗑️ Remover Membro",
      paste("Deseja remover o membro:", familia$lista[linha, "Nome"], "?"),
      footer = tagList(
        modalButton("Cancelar"),
        actionButton("confirmar_remocao", "Remover", class = "btn-danger")
      )
    ))
  })
  
  observeEvent(input$confirmar_remocao, {
    linha <- input$tabela_familia_rows_selected
    familia$lista <- familia$lista[-linha, ]
    removeModal()
  })
  
  observeEvent(input$editar_linha_familia, {
    linha <- input$editar_linha_familia
    membro <- familia$lista[linha, ]
    
    showModal(modalDialog(
      title = "✏️ Editar Membro da Família",
      textInput("editar_nome", "Nome", value = membro$Nome),
      selectInput("editar_parentesco", "Parentesco", choices = c("Filho", "Filha", "Cônjuge", "Outro"), selected = membro$Parentesco),
      selectInput("editar_sexo", "Sexo", choices = c("Masculino", "Feminino", "Outro"), selected = membro$Sexo),
      numericInput("editar_idade", "Idade", value = membro$Idade, min = 0),
      selectInput("editar_frequenta", "Frequenta Escola?", choices = c("Sim", "Não"), selected = membro$FrequentaEscola),
      selectInput("editar_escolaridade", "Escolaridade", choices = c("Fundamental", "Médio", "Superior", "Não informado"), selected = membro$Escolaridade),
      selectInput("editar_reside", "Reside com a assistida?", choices = c("Sim", "Não"), selected = membro$ResideCom),
      footer = tagList(
        modalButton("Cancelar"),
        actionButton("confirmar_edicao", "Salvar Alterações", class = "btn-success")
      )
    ))
    
    observeEvent(input$confirmar_edicao, {
      familia$lista[linha, ] <- data.frame(
        Nome = input$editar_nome,
        Parentesco = input$editar_parentesco,
        Sexo = input$editar_sexo,
        Idade = input$editar_idade,
        FrequentaEscola = input$editar_frequenta,
        Escolaridade = input$editar_escolaridade,
        ResideCom = input$editar_reside,
        stringsAsFactors = FALSE
      )
      removeModal()
    })
  })
  
  observeEvent(input$remover_linha_familia, {
    linha <- input$remover_linha_familia
    nome <- familia$lista[linha, "Nome"]
    
    showModal(modalDialog(
      title = "🗑️ Remover Membro",
      paste("Deseja remover o membro:", nome, "?"),
      footer = tagList(
        modalButton("Cancelar"),
        actionButton("confirmar_remocao", "Remover", class = "btn-danger")
      )
    ))
    
    observeEvent(input$confirmar_remocao, {
      familia$lista <- familia$lista[-linha, ]
      removeModal()
    })
  })
  
  # 1. ReactiveValues para controle de conclusão das abas
  abas_concluidas <- reactiveValues(
    cadastro = FALSE,
    rede = FALSE,
    notificacao = FALSE,
    familia = FALSE,
    residencia = FALSE,
    renda = FALSE,
    revisao = FALSE,
    finalizado = FALSE
  )
  # 2. Lista de campos obrigatórios (apenas para abas com campos fixos)
  campos_obrigatorios <- list(
    cadastro = c("campo_inicial_1", "campo_inicial_2"),
    residencia     = c("campo_residencia_1", "campo_residencia_2"),
    renda          = c("campo_renda_1", "campo_renda_2"),
    revisao        = c("campo_revisao_1", "campo_revisao_2"),
    finalizado     = c("campo_finalizado_1")
  )
  
  
  # 3. Função genérica para verificar campos fixos
  verificarCampos <- function(input, campos) {
    all(sapply(campos, function(id) {
      !is.null(input[[id]]) && trimws(input[[id]]) != ""
    }))
  }
  
  # 4. Verificação automática para abas com campos fixos
  observe({
    lapply(names(campos_obrigatorios), function(aba) {
      campos <- campos_obrigatorios[[aba]]
      abas_concluidas[[aba]] <- verificarCampos(input, campos)
    })
  })
  
  # 5. Verificação condicional para aba "Rede de Atendimento SEMMU"
  observe({
    abas_concluidas$rede <- switch(
      input$rede,
      "CRM (Centro de Referência da Mulher)" = !is.null(input$profissional_crm) && input$profissional_crm != "Selecione",
      "Casa de Mainha" = !is.null(input$profissional_mainha) && input$profissional_mainha != "Selecione",
      "Casa Abrigo" = !is.null(input$profissional_abrigo) && input$profissional_abrigo != "Selecione",
      "SEMMU Até Você" = !is.null(input$profissional_movel) && input$profissional_movel != "Selecione" &&
        !is.null(input$polo_visitado) && input$polo_visitado != "Selecione" &&
        (input$polo_visitado != "Outros" || (!is.null(input$polo_outros) && input$polo_outros != "")),
      FALSE
    )
  })
  
  # 6. Verificação condicional para aba "Notificação Individual"
  observe({
    campos_basicos <- !is.null(input$naturalidade) && input$naturalidade != "" &&
      !is.null(input$uf) && input$uf != "" &&
      !is.null(input$quantos_filhos) && !is.na(input$quantos_filhos)
    
    naturalidade_ok <- input$naturalidade != "Outros" || (!is.null(input$naturalidade_outros) && input$naturalidade_outros != "")
    uf_ok           <- input$uf != "Outros" || (!is.null(input$uf_outros) && input$uf_outros != "")
    atividade_ok    <- input$atividade_laboral != "Outros" || (!is.null(input$atividade_outros) && input$atividade_outros != "")
    deficiencia_ok  <- input$deficiencia != "Outros" || (!is.null(input$deficiencia_outros) && input$deficiencia_outros != "")
    
    abas_concluidas$notificacao <- campos_basicos && naturalidade_ok && uf_ok && atividade_ok && deficiencia_ok
  })
  
  # 7. Verificação condicional para aba "Dados Familiares"
  observe({
    abas_concluidas$familia <- !is.null(input$tabela_familia_rows_selected) && length(input$tabela_familia_rows_selected) > 0
  })
  
  output$painel_principal <- renderUI({
    if (is.null(input$iniciar) || input$iniciar == 0) {
      # Painel de capa
      tabsetPanel(
        id = "abas",
        tabPanel(
          title = "Início",
          value = "inicio",
          div(
            class = "capa",
            h3(tags$strong("Bem-vindo ao Formulário de Cadastro Inicial")),
            p("Este formulário é utilizado para coletar dados sociodemográficos das mulheres atendidas pela Rede de Atendimento SEMMU..."),
            tags$hr(),
            p("📋 Instruções de preenchimento"),
            tags$ul(
              tags$li("✔️ Preenchimento obrigatório: Todos os campos marcados com * devem ser preenchidos."),
              tags$li("📁 Armazenamento local: As informações são salvas em formato CSV."),
              tags$li("🔄 Múltiplas submissões: Você pode enviar quantas respostas forem necessárias."),
              tags$li("🧠 Profissional responsável: Registrar o nome do profissional responsável.")
            ),
            tags$hr(),
            p("🛠️ Notas de Atualização"),
            tags$ul(
              tags$li(tags$em(tags$strong("Versão 2.1 de 04/09/2025:"), " Upload do Documento inserido.")),
              tags$li(tags$em(tags$strong("Versão 2.0 de 21/07/2025:"), " Padronização conforme SINAN.")),
              tags$li(tags$em(tags$strong("Versão 1.0 de 04/06/2025:"), " Primeira versão funcional."))
            ),
            br(),
            div(style = "text-align:center;", actionButton("iniciar", "Preencher formulário", class = "btn-success btn-lg")),
            br(), br()
          )
        )
      )
    } else {
      # Painéis do formulário
      tabsetPanel(
        id = "abas",
        tabPanel("Rede de Atendimento SEMMU", ...),
        tabPanel("Notificação Individual", ...),
        tabPanel("Dados Familiares", ...),
        tabPanel("Dados de Residência", ...),
        tabPanel("Fonte de Renda", ...),
        tabPanel("Revisão Final", ...),
        tabPanel("Finalizado", ...)
      )
    }
  })
  
  
  # 8. Renderização das abas com ícones de conclusão
  output$abas_ui <- renderUI({
    fluidPage(
      div(
        class = "main-container",
        style = "flex: 1; padding-bottom: 80px;",
        fluidRow(
          column(
            10,
            tabsetPanel(
              id = "abas",
              tabPanel("Rede de Atendimento SEMMU", ...),
              tabPanel("Dados Iniciais de Cadastro", ...),
              tabPanel("Notificação Individual", ...),
              tabPanel("Dados Familiares", ...),
              tabPanel("Dados de Residência", ...),
              tabPanel("Descrição da Fonte de Renda", ...),
              tabPanel("Revisão Final", ...)
            )
          )
        )
      )
    )
  })
  
  absolutePanel(
    top = 100,
    right = 0,  # garante alinhamento total à direita
    width = 250,
    fixed = TRUE,
    draggable = FALSE,
    style = "
    background-color: #f9f9f9;
    border-left: 1px solid #ccc;
    padding: 15px;
    box-shadow: -2px 0 5px rgba(0,0,0,0.1);
    z-index: 1000;
  ",
    h4("🗂️ Progresso do Preenchimento"),
    uiOutput("painel_status")
  )
  
  output$painel_status <- renderUI({
    abas <- list(
      rede = "Rede de Atendimento SEMMU",
      cadastro = "Dados Iniciais de Cadastro",
      notificacao = "Notificação Individual",
      familia = "Dados Familiares",
      residencia = "Dados de Residência",
      renda = "Fonte de Renda",
      revisao = "Revisão Final",
    )
    
    # Exemplo de preenchimento fictício (substitua com lógica real)
    status_abas <- reactiveValues(
      rede = TRUE,
      cadastro = FALSE,
      notificacao = FALSE,
      familia = FALSE,
      residencia = FALSE,
      renda = FALSE,
      revisao = FALSE
    )
    
    # Geração da interface visual
    tagList(
      h4("📊 Status do Preenchimento"),
      tags$div(
        class = "painel-status",
        style = "display: flex; flex-wrap: wrap; gap: 10px;",
        lapply(names(abas), function(nome) {
          preenchido <- status_abas[[nome]]
          cor <- if (preenchido) "#28a745" else "#ffc107"
          icone <- if (preenchido) "✅" else "⏳"
          tags$div(
            style = paste0("border: 1px solid #ccc; padding: 10px; border-radius: 6px; background-color: ", cor, "; color: white; width: 220px;"),
            tags$strong(icone, " ", abas[[nome]])
          )
        })
      )
    )
  })
}