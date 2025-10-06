# router.R — controle de login, navegação e exibição

router <- function(input, output, session) {
  session$sendCustomMessage("applyMasks", list())
  
  source("logic/server_resumo.R")
  
  output$tela_login <- renderUI({
    if (!login_status$autenticado) {
      fluidPage(
        div(class = "login-box",
            h3("🔐 Acesso ao Formulário"),
            textInput("usuario", "Usuário"),
            passwordInput("senha", "Senha"),
            actionButton("botao_login", "Entrar", class = "btn-primary")
        )
      )
    } else {
      uiOutput("conteudo_principal")
    }
  })
  
  output$conteudo_principal <- renderUI({
    if (login_status$perfil == "admin") {
      fluidPage(
        h3("👑 Painel Administrativo"),
        p(paste("Bem-vindo,", login_status$nome)),
        actionButton("ver_relatorios", "📊 Ver Relatórios"),
        actionButton("gerenciar_usuarios", "👥 Gerenciar Usuários"),
        uiOutput("painel_principal")
      )
    } else {
      fluidPage(
        h3("📋 Formulário de Cadastro"),
        p(paste("Profissional:", login_status$nome)),
        uiOutput("painel_principal")
      )
    }
  })
  
  output$painel_principal <- renderUI({
    absolutePanel(
      top = 100, right = 0, width = 250, fixed = TRUE,
      style = "background-color:#f9f9f9; border-left:1px solid #ccc; padding:15px;",
      h4("🗂️ Progresso do Preenchimento"),
      uiOutput("painel_status")
    )
  })
}