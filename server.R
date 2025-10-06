# 🔧 Carregamento das interfaces visuais
source("ui_login.R")        # Tela de login com cabeçalho institucional
source("ui_painel.R")       # Tela intermediária com boas-vindas
source("ui_formulario.R")   # Formulário completo com todas as abas

# ⚙️ Carregamento das lógicas modulares
source("logic/server_login.R")       # Autenticação
source("logic/server_dashboard.R")   # Painel intermediário
source("logic/server_formulario.R")  # Navegação e validação do formulário
source("logic/server_envio.R")       # Envio final do formulário
source("logic/server_resumo.R", local = TRUE)  # Geração do resumo consolidado

# 🚀 Inicialização do servidor Shiny
server <- function(input, output, session) {
  
  # 🔄 Estado da tela atual: login, painel ou formulário
  tela_atual <- reactiveVal("login")
  
  # ⏱️ Tempo de início do preenchimento
  tempo_inicio <- reactiveVal(NULL)
  
  observeEvent(tela_atual(), {
    if (tela_atual() == "formulario") {
      tempo_inicio(Sys.time())
    }
  })
  
  # 👨‍👩‍👧‍👦 Dados da composição familiar
  dados_familia <- reactiveValues(tabela = data.frame())
  
  # 🔐 Estado de autenticação do usuário
  login_status <- reactiveValues(
    autenticado = FALSE,
    nome = NULL,
    perfil = NULL
  )
  
  # 🔐 Autenticação
  server_login(input, output, session, tela_atual, login_status)
  
  # 🧭 Painel intermediário com boas-vindas
  server_dashboard(input, output, session, tela_atual, login_status)
  
  # 📝 Navegação e validação do formulário
  server_formulario(input, output, session, tela_atual, dados_familia)
  
  # 📤 Envio final do formulário (agora com tempo de preenchimento)
  server_envio(input, output, session, tela_atual, dados_familia)
  
  # 📋 Geração do resumo final
  server_resumo(input, output, session, dados_familia)
  
  # 🖥️ Renderização condicional da interface principal
  output$tela_principal <- renderUI({
    if (!login_status$autenticado) {
      login_ui
    } else if (tela_atual() == "painel") {
      painel_ui
    } else if (tela_atual() == "formulario") {
      ui_formulario
    }
  })
}