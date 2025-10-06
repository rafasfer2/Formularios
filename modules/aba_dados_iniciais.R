aba_dados_iniciais <- tabPanel(
  title = "Dados Iniciais de Cadastro",
  value = "cadastro",
  
  div(
    class = "aba-conteudo",
    style = "padding: 30px;",
    
    labelObrigatorio("Data e hora do Cadastro"),
    textInput("data_manual", NULL, placeholder = "21/09/2025 13:01"),
    
    labelObrigatorio("Nome Completo da Assistida"),
    textInput("nome", NULL),
    
    labelObrigatorio("Número do CPF"),
    textInput("cpf", NULL, placeholder = "000.000.000-00"),
    
    tags$label(strong("Número do RG")),
    textInput("rg", NULL, placeholder = "00.000.000-0"),
    
    tags$label(strong("Upload do Documento")),
    fileInput("documento", NULL, accept = c(".pdf", ".jpg", ".png")),
    
    labelObrigatorio("(DDD) Telefone"),
    textInput("telefone", NULL, placeholder = "(99) 99999-9999"),
    
    labelObrigatorio("Tipo de Demanda"),
    selectInput("demanda", NULL, choices = c(
      "Espontânea",
      "Encaminhada pela Rede Intersetorial",
      "Encaminhamento Interno da Rede SEMMU"
    )),
    
    # 🔄 Subseções dinâmicas
    conditionalPanel(
      condition = "input.demanda == 'Encaminhada pela Rede Intersetorial'",
      tags$hr(),
      selectInput(
        "rede_intersetorial",
        labelObrigatorio(tags$label(strong("Rede Intersetorial"))),
        choices = c(
          "PARAPAZ", "CREAS", "CRAS", "UBS", "HGP", "UBS", "UPA",
          "Conselho Tutelar", "DEAM", "DEACA", "Ministério Público",
          "SEHAB", "SEMAS", "SEMSI", "SEMED", "Outros"
        ),
        conditionalPanel(
          condition = "input.rede_intersetorial == 'Outros'",
          textInput("rede_outros", tags$strong("Informe a rede intersetorial"))
        ),
      ),
      textInput(
        "obs_localidade",
        tags$label(strong("Observações de Localidade")),
        placeholder = "Ex: Bairro distante, zona rural, etc."
      )
    ),
    
    conditionalPanel(
      condition = "input.demanda == 'Encaminhamento Interno da Rede SEMMU'",
      tags$hr(),
      selectInput(
        "rede_semmu",
        labelObrigatorio(tags$label(strong("Rede SEMMU"))),
        choices = c(
          "CRM", "Casa de Mainha", "Casa Abrigo",
          "SEMMU Até Você", "CEAJUM", "Patrulha Maria da Penha"
        )
      )
    ),
    
    br(),
    fluidRow(
      column(6, actionButton("prev2", "⬅️ Voltar", class = "btn btn-secondary")),
      column(6, div(style = "text-align:right;", actionButton("next2", "Avançar ➡️", class = "btn btn-primary")))
    )
  )
)