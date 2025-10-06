painel_ui <- fluidPage(
  useShinyjs(),
  header_includes,
  theme = theme_global,
  
  div(
    style = "display: flex; flex-direction: column; min-height: 100vh;",
    
    # 🟣 Cabeçalho institucional
    cabecalho_global(),
    
    # 📄 Conteúdo principal
    div(
      class = "painel-conteudo",
      style = "flex: 1; padding: 40px; text-align: center;",
      textOutput("nome_usuario"),  # Saudação personalizada
      
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
      div(style = "text-align:center;", actionButton("iniciar_formulario", "Preencher formulário", class = "btn-success btn-lg")),
      br(), br()
    ),
    
    # ⚫ Rodapé institucional
    rodape_global()
  )
)