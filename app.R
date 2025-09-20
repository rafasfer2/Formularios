Sys.setlocale("LC_TIME", "Portuguese")

library(shiny)
library(rsconnect)
library(rmarkdown)
library(knitr)
library(reticulate)

ui <- fluidPage(
  titlePanel("Formulário de Cadastro"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("nome", "Nome completo"),
      #textInput("email", "E-mail"),
      numericInput("idade", "Idade", value = NA, min = 1, max = 120),
      selectInput("gosta_R", "Você gosta de R?", choices = c("Sim", "Não", "Talvez")),
      actionButton("enviar", "Enviar"),
      textOutput("mensagem")
    ),
    
    mainPanel(
      h4("Última resposta enviada"),
      verbatimTextOutput("ultima")
    )
  )
)

server <- function(input, output, session) {
  observeEvent(input$enviar, {
    if (input$nome == "" || input$email == "" || is.na(input$idade)) {
      output$mensagem <- renderText("?????? Preencha todos os campos obrigatórios.")
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