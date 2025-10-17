# Carregamento das interfaces visuais
source("ui_login.R")
source("ui_painel.R")
source("ui_formulario.R")

# Carregamento das lógicas modulares
source("logic/server_login.R")
source("logic/server_dashboard.R")
source("logic/server_formulario.R")
source("logic/server_envio.R")
source("logic/server_resumo.R", local = TRUE)

server <- function(input, output, session) {
  message("🚀 Servidor Shiny iniciado")
  
  # Controle da tela atual: login, painel ou formulário
  tela_atual <- reactiveVal("login")
  
  # Controle do tempo de início do preenchimento do formulário
  tempo_inicio <- reactiveVal(NULL)
  
  # Controle do tempo do login para exibir duração
  tempo_login <- Sys.time()
  
  # Controle da última atividade para logout automático
  ultima_atividade <- reactiveVal(Sys.time())
  
  # Variável reativa para armazenar o usuário logado (login)
  usuario_logado <- reactiveVal(NULL)
  
  # Atualiza tempo de início quando a tela for formulário
  observeEvent(tela_atual(), {
    if (tela_atual() == "formulario") {
      tempo_inicio(Sys.time())
    }
  })
  
  # Atualiza última atividade em várias entradas
  observe({
    input$iniciar_formulario
    input$logout
    input$usuario
    input$senha
    ultima_atividade(Sys.time())
  })
  
  # Dados reativos para membros da família
  dados_familia <- reactiveValues(tabela = data.frame())
  
  # Status do login e dados do usuário
  login_status <- reactiveValues(
    autenticado = FALSE,
    nome = NULL,
    perfil = NULL,
    unidade = NULL,
    dados_usuario = NULL
  )
  
  # Chamada do módulo de login, passando usuario_logado para atualizar
  server_login(input, output, session, tela_atual, login_status, usuario_logado)
  
  # Chamada dos demais módulos, sem passar usuario_logado para server_formulario (se não usar)
  server_dashboard(input, output, session, tela_atual, login_status)
  server_formulario(input, output, session, tela_atual, dados_familia, login_status)
  server_resumo(input, output, session, dados_familia)
  server_envio(input, output, session, tempo_inicio, usuario_logado)
  
  # Renderiza a UI principal conforme o estado do login e tela atual
  output$tela_principal <- renderUI({
    if (!login_status$autenticado) {
      login_ui
    } else if (tela_atual() == "painel") {
      painel_ui
    } else if (tela_atual() == "formulario") {
      ui_formulario
    } else {
      div(h3("Erro: tela não reconhecida"))
    }
  })
  
  # Logout manual
  observeEvent(input$logout, {
    login_status$autenticado <- FALSE
    login_status$nome <- NULL
    login_status$perfil <- NULL
    login_status$unidade <- NULL
    login_status$dados_usuario <- NULL
    usuario_logado(NULL)
    tela_atual("login")
  })
  
  # Logout automático após 1 hora de inatividade
  observe({
    invalidateLater(60000, session)
    tempo_inativo <- difftime(Sys.time(), ultima_atividade(), units = "secs")
    if (tempo_inativo > 3600) {
      login_status$autenticado <- FALSE
      login_status$nome <- NULL
      login_status$perfil <- NULL
      login_status$unidade <- NULL
      login_status$dados_usuario <- NULL
      usuario_logado(NULL)
      tela_atual("login")
      showModal(modalDialog(
        title = "Sessão expirada",
        "Você ficou inativo por 1 hora e foi desconectado. Por favor, faça login novamente.",
        easyClose = TRUE,
        footer = NULL
      ))
    }
  })
  
  # Exibe o tempo de acesso formatado
  output$tempo_acesso <- renderText({
    invalidateLater(1000, session)
    duracao <- difftime(Sys.time(), tempo_login, units = "secs")
    horas <- floor(as.numeric(duracao) / 3600)
    minutos <- floor((as.numeric(duracao) %% 3600) / 60)
    segundos <- floor(as.numeric(duracao) %% 60)
    sprintf("Tempo de acesso: %02d:%02d:%02d", horas, minutos, segundos)
  })
  
  # Obtém a unidade do usuário logado para exibir
  unidade_usuario <- reactive({
    dados <- login_status$dados_usuario
    if (is.null(dados)) return("N/D")
    
    unidade <- NULL
    if (is.data.frame(dados)) {
      if ("unidade" %in% names(dados)) {
        unidade <- as.character(dados$unidade[1])
      } else if ("coordenacao" %in% names(dados)) {
        unidade <- as.character(dados$coordenacao[1])
      }
    } else if (is.list(dados)) {
      if (!is.null(dados$unidade)) {
        unidade <- as.character(dados$unidade)
      } else if (!is.null(dados$coordenacao)) {
        unidade <- as.character(dados$coordenacao)
      }
    }
    
    if (is.null(unidade) || unidade == "") unidade <- "N/D"
    unidade
  })
  
  output$unidade_usuario <- renderUI({
    unidade <- unidade_usuario()
    HTML(paste0(
      '<span style="color: #5c2a7a; font-weight: 700;">', unidade, '</span>'
    ))
  })
  
  # Exibe o nome do usuário logado
  output$nome_usuario <- renderText({
    nome <- login_status$nome %||% "Usuária"
    nome <- gsub("^Olá,\\s*", "", nome)
    nome
  })
}