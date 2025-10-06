aba_revisao <- tabPanel(
  title = "Revisão Final",
  value = "revisao",
  
  div(
    class = "aba-conteudo",
    style = "padding: 30px; max-width: 900px; margin: auto;",
    
    # Título e instrução
    h3("📋 Revisão dos Dados Preenchidos"),
    p("Confira atentamente todas as informações antes de enviar o formulário. Caso necessário, volte às abas anteriores para corrigir."),
    
    # Painel consolidado com todas as seções
    div(
      class = "painel-resumo",
      style = "margin-top: 20px; background-color: #f9f9f9; padding: 25px; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.05);",
      uiOutput("resumo_dados")
    ),
    
    tags$hr(),
    
    # Botões de navegação
    fluidRow(
      column(6,
             actionButton("prev7", "⬅️ Voltar", class = "btn btn-secondary")
      ),
      column(6,
             div(style = "text-align: right;",
                 actionButton("confirmar_envio", "✅ Confirmar e Enviar", class = "btn btn-success")
             )
      )
    ),
    
    br(),
    verbatimTextOutput("resposta_final")
  )
)