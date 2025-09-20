Sys.setlocale("LC_TIME", "pt_BR.UTF-8")
options(encoding = "UTF-8")

library(shiny)
library(rsconnect)
library(rmarkdown)
library(tidyverse)
library(lubridate)
library(knitr)
library(reticulate)
library(shiny)
library(bslib)

# Caminho do arquivo CSV
library(shiny)
arquivo_csv <- "data/respostas.csv"

ui <- fluidPage(
  titlePanel("Formulário de Cadastro"),
  
  tabsetPanel(id = "abas",
              
              # ???? Aba 1: Capa introdutória
              tabPanel("???? Início",
                       fluidPage(
                         tags$img(src = "capa.png", height = "250px",
                                  style = "display: block; margin: auto;"),
                         br(),
                         h2(tags$strong("Bem-vindo ao Formulário de Cadastro Inicial")),
                         p("Formulário utilizado para coletar dados sociodemográficas das mulheres atendidas pela Rede de Atendimento SEMMU. Refere-se a informações que incluem tanto características demográficas (idade, sexo, estado civil, etc.) quanto dados sociais (renda, educação, ocupação, hábitos culturais, etc.)."),
                         tags$ul(
                           tags$li("?????? Preencha todos os campos obrigatórios."),
                           tags$li("?????? Seus dados são armazenados localmente em formato CSV."),
                           tags$li("?????? Você pode enviar múltiplas respostas.")
                         ),
                         br(),
                         h4("??????? Notas de Atualização"),
                         tags$ul(
                           tags$li("Versão 1.2 - Item Upload do Documento inserido para armazenamento digitalizado do documento de identificação da assistida."),
                           tags$li("Versão 1.1 - Padronização dos itens, considerando a Ficha Individual de Notificação (FIN) do Sistema de Informação de Agravos de Notificação (SINAN)."),
                           tags$li("Versão 1.0 - Primeira versão funcional.")
                         ),
                         br(),
                         tags$div(
                           style = "margin-top: 30px; text-align: center; font-size: 14px; color: #444;",
                           tags$hr(),
                           tags$strong("???? Endereço institucional"),
                           tags$p("Este formulário é de responsabilidade da Secretaria da Mulher de Parauapebas (SEMMU)."),
                           tags$p("Rua Rio Dourado - Beira Rio, Parauapebas - PA, 68515-000")
                         ),
                         actionButton("ir_para_formulario", "Preencher Formulário", class = "btn btn-primary")
                       )
              ),
              
              # ???? Aba 2: Informações Pessoais
              tabPanel("???? Informações Pessoais",
                       fluidRow(
                         column(6, textInput("nome", "Nome completo")),
                         column(6, textInput("email", "E-mail"))
                       ),
                       fluidRow(
                         column(4, numericInput("idade", "Idade", value = NA, min = 1, max = 120)),
                         column(8, selectInput("genero", "Gênero",
                                               choices = c("Masculino", "Feminino", "Outro", "Prefiro não dizer")))
                       )
              ),
              
              # ???? Aba 3: Preferências
              tabPanel("???? Preferências",
                       fluidRow(
                         column(12, selectInput("gosta_R", "Você gosta de R?",
                                                choices = c("Sim", "Não", "Talvez")))
                       )
              ),
              
              # ???? Aba 4: Comentário Adicional
              tabPanel("???? Comentário Adicional",
                       fluidRow(
                         column(12, textAreaInput("comentario", NULL, "", rows = 4))
                       )
              ),
              
              # ??? Aba 5: Enviar
              tabPanel("??? Enviar",
                       fluidRow(
                         column(4, actionButton("enviar", "Enviar")),
                         column(4, uiOutput("botao_nova_resposta")),
                         column(4, textOutput("mensagem"))
                       ),
                       hr(),
                       h4("???? Última resposta enviada"),
                       verbatimTextOutput("ultima_resposta")
              )
  ),
  tags$footer(
    style = "
    position: fixed;
    bottom: 0;
    width: 100%;
    background-color: #f8f9fa;
    padding: 10px;
    text-align: center;
    font-size: 13px;
    color: #555;
    border-top: 1px solid #ccc;
    z-index: 1000;
  ",
    HTML("© 2025 Rafael . Todos os direitos reservados . rafasfer2@gmail.com")
  )
  
)

server <- function(input, output, session) {
  enviado <- reactiveVal(FALSE)
  
  observeEvent(input$ir_para_formulario, {
    updateTabsetPanel(session, "abas", selected = "???? Informações Pessoais")
  })
  
  observeEvent(input$enviar, {
    if (input$nome == "" || input$email == "" || is.na(input$idade)) {
      output$mensagem <- renderText("?????? Preencha todos os campos obrigatórios.")
      return()
    }
    
    nova <- data.frame(
      Nome       = input$nome,
      Email      = input$email,
      Idade      = input$idade,
      Gênero     = input$genero,
      Gosta_de_R = input$gosta_R,
      Comentário = input$comentario,
      Data       = Sys.time()
    )
    
    if (!dir.exists("data")) dir.create("data")
    
    if (file.exists(arquivo_csv)) {
      write.table(nova, arquivo_csv, sep = ",", row.names = FALSE,
                  col.names = FALSE, append = TRUE)
    } else {
      write.table(nova, arquivo_csv, sep = ",", row.names = FALSE,
                  col.names = TRUE)
    }
    
    output$mensagem <- renderText("??? Resposta enviada com sucesso!")
    output$ultima_resposta <- renderPrint(nova)
    enviado(TRUE)
  })
  
  output$botao_nova_resposta <- renderUI({
    if (enviado()) actionButton("nova_resposta", "Enviar outra resposta")
  })
  
  observeEvent(input$nova_resposta, {
    enviado(FALSE)
    output$mensagem <- renderText("")
    output$ultima_resposta <- renderText("")
    
    updateTextInput(session, "nome", value = "")
    updateTextInput(session, "email", value = "")
    updateNumericInput(session, "idade", value = NA)
    updateSelectInput(session, "genero", selected = "Masculino")
    updateSelectInput(session, "gosta_R", selected = "Sim")
    updateTextAreaInput(session, "comentario", value = "")
    updateTabsetPanel(session, "abas", selected = "???? Informações Pessoais")
  })
}

shinyApp(ui = ui, server = server)
