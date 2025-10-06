source("ui_login.R")
source("ui_painel.R")
source("ui_formulario.R")

server <- function(input, output, session) {
  tela_atual <- reactiveVal("login")
  
  login_status <- reactiveValues(autenticado = FALSE, nome = NULL, perfil = NULL)
  
  observeEvent(input$entrar, {
    credencial <- subset(usuarios_validos,
                         usuarios_validos$usuario == input$usuario &
                           usuarios_validos$senha == input$senha)
    
    if (nrow(credencial) == 1) {
      login_status$autenticado <- TRUE
      login_status$nome <- credencial$nome
      login_status$perfil <- credencial$perfil
      tela_atual("painel")
      shinyjs::hide("erro_login")
      limparErros(c("usuario", "senha"))
    } else {
      shinyjs::show("erro_login")
      shinyjs::addClass("usuario", "erro")
      shinyjs::addClass("senha", "erro")
    }
  })
  
  observeEvent(input$iniciar_formulario, {
    tela_atual("formulario")
  })
  
  mapa_navegacao <- list(
    dados_iniciais = list(next = "next1"),
    notificacao = list(prev = "prev2", next = "next2"),
    familia = list(prev = "prev3", next = "next3", adicionar = "adicionar_membro"),
    residencia = list(prev = "prev4", next = "next4"),
    renda = list(prev = "prev5", next = "next5"),
    revisao = list(prev = "prev6", enviar = "enviar", confirmar = "confirmar_envio")
  )
  
  aba_atual <- reactiveVal("dados_iniciais")
  
  lapply(names(mapa_navegacao), function(aba) {
    nav <- mapa_navegacao[[aba]]
    
    if (!is.null(nav$next)) {
      observeEvent(input[[nav$next]], {
        prox_aba <- names(mapa_navegacao)[which(names(mapa_navegacao) == aba) + 1]
        aba_atual(prox_aba)
        updateTabsetPanel(session, "formulario_tabs", selected = prox_aba)
      })
    }
    
    if (!is.null(nav$prev)) {
      observeEvent(input[[nav$prev]], {
        ant_aba <- names(mapa_navegacao)[which(names(mapa_navegacao) == aba) - 1]
        aba_atual(ant_aba)
        updateTabsetPanel(session, "formulario_tabs", selected = ant_aba)
      })
    }
    
    if (!is.null(nav$adicionar)) {
      observeEvent(input[[nav$adicionar]], {
        # lógica para adicionar membro à família
      })
    }
    
    if (!is.null(nav$enviar)) {
      observeEvent(input[[nav$enviar]], {
        # lógica para envio preliminar
      })
    }
    
    if (!is.null(nav$confirmar)) {
      observeEvent(input[[nav$confirmar]], {
        # lógica para envio final
      })
    }
  })
  
  output$tela_principal <- renderUI({
    if (!login_status$autenticado) {
      login_ui
    } else if (tela_atual() == "painel") {
      uiOutput("painel_ui")
    } else if (tela_atual() == "formulario") {
      formulario_ui
    }
  })
}