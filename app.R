library(shiny)

ui <- fluidPage(
  titlePanel("Formulário de Cadastro"),
  
  sidebarLayout(
    sidebarPanel(
      textInput("nome", "Nome completo"),
      textInput("email", "E-mail"),
      selectInput("genero", "Gênero", choices = c("Masculino", "Feminino", "Outro", "Prefiro não dizer")),
      numericInput("idade", "Idade", value = NA, min = 1, max = 120),
      textAreaInput("comentario", "Comentário adicional", "", rows = 3),
      actionButton("enviar", "Enviar"),
      br(),
      textOutput("mensagem")
    ),
    
    mainPanel(
      h4("Última resposta enviada"),
      verbatimTextOutput("ultima_resposta")
    )
  )
)

server <- function(input, output, session) {
  respostas <- reactiveVal(data.frame())
  
  observeEvent(input$enviar, {
    if (input$nome == "" || input$email == "" || is.na(input$idade)) {
      output$mensagem <- renderText("?????? Por favor, preencha todos os campos obrigatórios.")
    } else {
      nova <- data.frame(
        Nome = input$nome,
        Email = input$email,
        Gênero = input$genero,
        Idade = input$idade,
        Comentário = input$comentario,
        Data = Sys.time()
      )
      
      respostas(nova)  # Armazena apenas a última resposta
      
      output$mensagem <- renderText("??? Resposta enviada com sucesso!")
      
      output$ultima_resposta <- renderPrint({
        nova
      })
      
      # Limpa os campos (opcional)
      updateTextInput(session, "nome", value = "")
      updateTextInput(session, "email", value = "")
      updateSelectInput(session, "genero", selected = "Masculino")
      updateNumericInput(session, "idade", value = NA)
      updateTextAreaInput(session, "comentario", value = "")
    }
  })
}

shinyApp(ui = ui, server = server)