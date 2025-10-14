aba_rede <- tabPanel(
  title = "Rede de Atendimento SEMMU",
  value = "rede",
  
  div(
    class = "aba-conteudo",
    style = "padding: 30px;",
    
    h3("🔗 Informações da Rede de Atendimento"),
    p("Selecione a unidade e o profissional responsável pelo atendimento."),
    
    radioButtons(
      "rede",
      labelObrigatorio("Unidade de atendimento:"),
      choices = c(
        "CRM (Centro de Referência da Mulher)",
        "Casa de Mainha",
        "Casa Abrigo",
        "SEMMU Até Você"
      )
    ),
    
    conditionalPanel(
      condition = "input.rede == 'CRM (Centro de Referência da Mulher)'",
      selectInput(
        "profissional_crm",
        labelObrigatorio("Profissional Responsável:"),
        choices = c(
          "Selecione",
          "Arlene Ferreira da Cruz Piovezan",
          "Juliana Pereira Cruz Menezes",
          "Elane Oliveira Corrêa"
        )
      )
    ),
    
    conditionalPanel(
      condition = "input.rede == 'Casa de Mainha'",
      selectInput(
        "profissional_mainha",
        labelObrigatorio("Profissional Responsável:"),
        choices = c(
          "Selecione",
          "Daiane Almino Ribeiro",
          "⁠Elizabeth Rodrigues de Bessa",
          "Fabiane Lima de Souza",
          "Keylla Alves da Silva"
        )
      )
    ),
    
    conditionalPanel(
      condition = "input.rede == 'Casa Abrigo'",
      selectInput(
        "profissional_abrigo",
        labelObrigatorio("Profissional Responsável:"),
        choices = c(
          "Selecione",
          "Alba Maria Rodrigues",
          "⁠Lucinei Aparecida Santos da Luz",
          "⁠Eva Silva de Lima",
          "Natália de Deus"
        )
      )
    ),
    
    conditionalPanel(
      condition = "input.rede == 'SEMMU Até Você'",
      tagList(
        selectInput(
          "profissional_movel",
          labelObrigatorio("Profissional Responsável:"),
          choices = c(
            "Selecione",
            "Elisangela Moreira",
            "Eleusa Maria dos Santos Salustriano",
            "Josélia Sousa Viana",
            "Sandra de Fátima Martins da Silva Araújo",
            "Keylla Alves da Silva"
          )
        ),
        selectInput(
          "polo_visitado",
          labelObrigatorio("Polo Visitado:"),
          choices = c(
            "Selecione",
            "Cedere 1",
            "Palmares 2",
            "Valentim Serra",
            "Paulo Fonteles",
            "Vila Carimã",
            "Vila Brasil",
            "Vila Alto Bonito",
            "Vila Sansão",
            "Outros"
          )
        ),
        conditionalPanel(
          condition = "input.polo_visitado == 'Outros'",
          textInput("polo_outros", "Informe o nome do polo visitado")
        )
      )
    ),
    
    br(),
    actionButton("next1", "Próximo", class = "btn btn-primary")
  )
)