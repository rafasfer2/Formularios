aba_renda <- tabPanel(
  title = "Descrição da Fonte de Renda",
  value = "renda",
  
  div(
    class = "aba-conteudo",
    style = "padding: 30px;",
    
    h3("💰 Informações sobre Renda"),
    p("Preencha os dados relacionados à renda mensal da assistida e benefícios sociais recebidos."),
    
    selectInput(
      "renda_media", labelObrigatorio("Renda Média Mensal"),
      choices = c(
        "Sem renda", "Até 1/4 do salário mínimo", "De 1/4 a 1/2 salário mínimo",
        "De 1/2 a 1 salário mínimo", "De 1 a 2 salários mínimos", "De 2 a 3 Salários Mínimos",
        "De 3 a 5 Salários Mínimos", "Acima de 5 salários mínimos", "Não informado"
      )
    ),
    
    selectInput(
      "beneficio_social", labelObrigatorio("Benefício Social"),
      choices = c(
        "Nenhum", "Bolsa Família", "BPC (Benefício de Prestação Continuada)",
        "Auxílio Brasil", "Auxílio Emergencial", "Auxílio Doença", "Outros"
      )
    ),
    
    conditionalPanel(
      condition = "input.beneficio_social == 'Outros'",
      tagList(
        tags$label(tags$strong(tags$em("Informe o Benefício Social")), style = "color: #0072B2;"),
        textInput("beneficio_social_outros", label = NULL, placeholder = "Ex: Renda Cidadã")
      )
    ),
    
    div(class = "form-group",
        labelObrigatorio("Valor do Benefício Social"),
        div(class = "input-group",
            span(class = "input-group-text", "R$"),
            tags$input(
              id = "valor_beneficio",
              type = "text",
              class = "form-control moeda",
              placeholder = "R$ 1.200,00",
              style = "max-width: 250px; flex: 0 0 250px;"
            )
        )
    ),
    
    div(class = "form-group",
        labelObrigatorio("Valor de Renda Própria"),
        div(class = "input-group",
            span(class = "input-group-text", "R$"),
            tags$input(
              id = "valor_renda_propria",
              type = "text",
              class = "form-control moeda",
              placeholder = "R$ 850,00",
              style = "max-width: 250px; flex: 0 0 250px;"
            )
        )
    ),
    
    div(class = "form-group",
        labelObrigatorio("Valor de Renda Pensão"),
        div(class = "input-group",
            span(class = "input-group-text", "R$"),
            tags$input(
              id = "valor_renda_pensao",
              type = "text",
              class = "form-control moeda",
              placeholder = "R$ 600,00",
              style = "max-width: 250px; flex: 0 0 250px;"
            )
        )
    ),
    
    br(),
    fluidRow(
      column(6, actionButton("prev6", "⬅️ Voltar", class = "btn btn-secondary")),
      column(6, div(style = "text-align:right;", actionButton("next6", "Avançar ➡️", class = "btn btn-success")))
    ),
    
    br(),
    verbatimTextOutput("resposta")
  )
)