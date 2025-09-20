Sys.setlocale("LC_TIME", "pt_BR.UTF-8")
options(encoding = "UTF-8")

library(shiny)
library(rsconnect)
library(rmarkdown)
library(knitr)
library(reticulate)

ui <- fluidPage(
  titlePanel("Formul?rio de Cadastro"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("nome", "Nome completo"),
      textInput("email", "E-mail"),
      numericInput("idade", "Idade", value = NA, min = 1, max = 120),
      selectInput("gosta_R", "Voc? gosta de R?", choices = c("Sim", "N?o", "Talvez")),
      actionButton("enviar", "Enviar"),
      textOutput("mensagem")
    ),
    
    mainPanel(
      h4("?ltima resposta enviada"),
      verbatimTextOutput("ultima")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$enviar, {
    if (input$nome == "" || input$email == "" || is.na(input$idade)) {
      output$mensagem <- renderText("?????? Preencha todos os campos obrigat?rios.")
    } else {
      resposta <- paste("Nome:", input$nome,
                        "\nEmail:", input$email,
                        "\nIdade:", input$idade,
                        "\nGosta de R:", input$gosta_R)
      output$mensagem <- renderText("??? Resposta enviada com sucesso!")
      output$ultima <- renderText(resposta)
    }
  })
}

shinyApp(ui = ui, server = server)