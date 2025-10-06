aba_residencia <- tabPanel(
  title = "Dados de Residência",
  value = "residencia",
  
  div(
    class = "aba-conteudo",
    style = "padding: 30px;",
    
    h3("🏠 Informações sobre Residência"),
    p("Preencha os dados referentes ao local de moradia da assistida."),
    
    fluidRow(
      column(
        4,
        selectInput(
          "municipio_residencia", labelObrigatorio("Município de Residência (Código IBGE)"),
          choices = c(
            "Parauapebas (1505536)", "Canaã dos Carajás (1502152)", "Curionópolis (1502772)",
            "Eldorado dos Carajás (1502954)", "Marabá (1504208)", "Belém (1501402)", "Outros"
          )
        ),
        conditionalPanel(
          condition = "input.municipio_residencia == 'Outros'",
          tagList(
            tags$label(tags$strong(tags$em("Informe o município de residência")), style = "color: #0072B2;"),
            textInput("municipio_outros", label = NULL)
          )
        ),
        
        textInput("bairro", labelObrigatorio("Bairro")),
        textInput("logradouro", labelObrigatorio("Logradouro (Rua, Avenida, ...)")),
        textInput("numero", tags$strong("Número")),
        textInput("quadra", tags$strong("Quadra")),
        textInput("lote", tags$strong("Lote")),
        textInput("complemento", tags$strong("Complemento (apto., casa, ...)")),
      ),
      column(
        4,
        radioButtons("zona", tags$strong("Zona de residência"), choices = c(
          "Urbana", "Rural", "Periurbana", "Indígena", "Quilombola"
        )),
        
        radioButtons("condicao_moradia", labelObrigatorio(tags$strong("Condição de Moradia")), choices = c(
          "Casa própria", "Alugada", "Cedida", "Ocupação", "Abrigo", "Situação de rua", "Outros"
        )),
        conditionalPanel(
          condition = "input.condicao_moradia == 'Outros'",
          tagList(
            tags$label(tags$strong(tags$em("Informe a condição de moradia")), style = "color: #0072B2;"),
            textInput("condicao_moradia_outros", label = NULL)
          )
        ),
      ),
      column(
        4,
        selectInput("ubs_referencia", tags$strong("UBS de Referência"), choices = c(
          "", "UBS Novo Brasil", "UBS Nova Carajás", "UBS VS 10", "UBS Casas Populares 2",
          "UBS Liberdade I", "Posto de Saúde Liberdade 1", "UBS Guanabara", "UBS Fortaleza",
          "UBS Cidade Nova", "UBS Jardim Canadá", "UBS Grazielly Caetano", "Outros"
        )),
        
        conditionalPanel(
          condition = "input.ubs_referencia == 'Outros'",
          tagList(
            tags$label(tags$strong(tags$em("Informe o nome da UBS")), style = "color: #0072B2;"),
            textInput("ubs_outros", label = NULL),
            tags$label(tags$strong(tags$em("Informe o bairro da UBS")), style = "color: #0072B2;"),
            textInput("ubs_bairro", label = NULL)
          )
        ),
      ),
      br(),
      fluidRow(
        column(6, actionButton("prev5", "⬅️ Voltar", class = "btn btn-secondary")),
        column(6, div(style = "text-align:right;", actionButton("next5", "Avançar ➡️", class = "btn btn-primary")))
      )
    )
  )
)