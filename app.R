Sys.setlocale("LC_TIME", "pt_BR.UTF-8")
options(encoding = "UTF-8")

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
      textInput("email", "E-mail"),
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

arquivo_csv <- "data/respostas.csv"
server <- function(input, output, session) {
  observeEvent(input$enviar, {
    nova_resposta <- data.frame(
      Nome = input$nome,
      Email = input$email,
      Idade = input$idade,
      Gosta_de_R = input$gosta_R,
      Comentário = input$comentario,
      Data = Sys.time()
    )
    
    # Se o arquivo já existe, adiciona; senão, cria com cabeçalho
    if (file.exists(arquivo_csv)) {
      write.table(nova_resposta, arquivo_csv, sep = ",", row.names = FALSE, col.names = FALSE, append = TRUE)
    } else {
      write.table(nova_resposta, arquivo_csv, sep = ",", row.names = FALSE, col.names = TRUE)
    }
  })
  output$mensagem <- renderText("✅ Resposta salva com sucesso!")
}

shinyApp(ui = ui, server = server)
