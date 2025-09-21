Sys.setlocale("LC_TIME", "pt_BR.UTF-8")
options(encoding = "UTF-8")

# Caminho do arquivo CSV
library(shiny)
arquivo_csv <- "data/respostas.csv"

ui <- fluidPage(
  titlePanel("Formulário Cadastro Inicial"),
  
  tabsetPanel(id = "abas",
              
              # ???? Capa
              tabPanel("???? Início",
                       fluidPage(
                         tags$img(src = "capa.png", height = "250px", style = "display: block; margin: auto;"),
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
              
              # ???? Aba 2: Rede de Atendimento SEMMU
              tabPanel("???? Rede de Atendimento SEMMU",
                       h3("Selecione os serviços ou unidades que você deseja acessar:"),
                       checkboxGroupInput("rede_semmu", "Rede de Atendimento:",
                                          choices = c(
                                            "CRM (Centro de Referência da Mulher)",
                                            "Casa de Mainha",
                                            "Casa Abrigo",
                                            "SEMMU Até Você"
                                          )
                       ),
                       br(),
                       fluidRow(
                         column(6, actionButton("voltar_inicio", "?????? Voltar")),
                         column(6, actionButton("avancar_subsecao", "?????? Avançar"))
                       )
              ),
              
              # ???? Aba 2.1: CRM
              tabPanel("???? CRM - Centro de Referência da Mulher",
                       checkboxGroupInput("crm_servicos", "1. Profissional Responsável pelo Preenchimento",
                                          choices = c(
                                            "Arlene Ferreira da Cruz Piovezan",
                                            "Juliana Pereira Cruz Menezes",
                                            "Elane Oliveira Corrêa"
                                          )
                       ),
                       br(),
                       fluidRow(
                         column(6, actionButton("voltar_rede", "?????? Voltar")),
                         column(6, actionButton("avancar_pessoais", "?????? Avançar"))
                       )
              ),
              # ???? Aba 2.2: CRM
              tabPanel("???? Casa de Mainha",
                       checkboxGroupInput("mainha_servicos", "2. Profissional Responsável pelo Preenchimento",
                                          choices = c(
                                            "Daiane Almino Ribeiro",
                                            "???Elizabeth Rodrigues de Bessa",
                                            "Fabiane Lima de Souza",
                                            "Keylla Alves da Silva"
                                          )
                       ),
                       br(),
                       fluidRow(
                         column(6, actionButton("voltar_rede", "?????? Voltar")),
                         column(6, actionButton("avancar_pessoais", "?????? Avançar"))
                       )
              ),
              # ???? Aba 2.3: SEMMU Até Você
              tabPanel("???? SEMMU Até Você",
                       checkboxGroupInput("movel_servicos", "3. Profissional Responsável pelo Preenchimento",
                                          choices = c(
                                            "Elisangela Moreira",
                                            "Eleusa",
                                            "Josélia Viana",
                                            "Sandra Araújo",
                                            "Keylla Alves da Silva"
                                          )
                       ),
                       br(),
                       fluidRow(
                         column(6, actionButton("voltar_rede", "?????? Voltar")),
                         column(6, actionButton("avancar_pessoais", "?????? Avançar"))
                       )
              ),
              # ???? Aba 2.4: Casa Abrigo
              tabPanel("??????? Casa Abrigo",
                       checkboxGroupInput("casa_abrigo", "4. Profissional Responsável pelo Preenchimento",
                                          choices = c(
                                            "Daiane Almino Ribeiro",
                                            "???Elizabeth Rodrigues de Bessa",
                                            "Fabiane Lima de Souza",
                                            "Keylla Alves da Silva"
                                          )
                       ),
                       br(),
                       fluidRow(
                         column(6, actionButton("voltar_rede", "?????? Voltar")),
                         column(6, actionButton("avancar_pessoais", "?????? Avançar"))
                       )
              ),
              
              # ???? Informações Pessoais
              tabPanel("???? Informações Pessoais",
                       fluidRow(
                         column(6, textInput("nome", "Nome completo")),
                         column(6, textInput("email", "E-mail"))
                       ),
                       fluidRow(
                         column(4, numericInput("idade", "Idade", value = NA, min = 1, max = 120)),
                         column(8, selectInput("genero", "Gênero",
                                               choices = c("Masculino", "Feminino", "Outro", "Prefiro não dizer")))
                       ),
                       br(),
                       fluidRow(
                         column(6, actionButton("voltar_preferencias", "?????? Voltar")),
                         column(6, actionButton("avancar_subsecao", "?????? Avançar"))
                       )
              ),
              
              # ???? Preferências
              tabPanel("???? Preferências",
                       selectInput("gosta_R", "Você gosta de R?", c("Sim", "Não", "Talvez")),
                       selectInput("precisa_apoio", "Você gostaria de receber apoio da SEMMU?", c("Não", "Sim"))
              ),
              
              # ???? Comentário
              tabPanel("???? Comentário Adicional",
                       textAreaInput("comentario", "Comentário ou observações:", "", rows = 4)
              ),
              
              # ??? Enviar
              tabPanel("??? Enviar",
                       actionButton("enviar", "Enviar"),
                       textOutput("mensagem"),
                       verbatimTextOutput("ultima_resposta"),
                       uiOutput("botao_nova_resposta")
              ),
  )
)

server <- function(input, output, session) {
  enviado <- reactiveVal(FALSE)
  
  # Botão da capa
  observeEvent(input$ir_para_formulario, {
    updateTabsetPanel(session, "abas", selected = "???? Rede de Atendimento SEMMU")
  })

  observeEvent(input$avancar_subsecao, {
    if ("CRM (Centro de Referência da Mulher)" %in% input$rede_semmu) {
      updateTabsetPanel(session, "abas", selected = "???? CRM - Centro de Referência da Mulher")
    } else if ("Casa de Mainha" %in% input$rede_semmu) {
      updateTabsetPanel(session, "abas", selected = "???? Casa de Mainha")
    } else if ("Casa Abrigo" %in% input$rede_semmu) {
      updateTabsetPanel(session, "abas", selected = "??????? Casa Abrigo")
    } else if ("SEMMU Até Você" %in% input$rede_semmu) {
      updateTabsetPanel(session, "abas", selected = "???? SEMMU Até Você")
    }
  })
  
  observeEvent(input$voltar_inicio, {
    updateTabsetPanel(session, "abas", selected = "???? Início")
  })
  
  
  
  
  observeEvent(input$voltar_rede, {
    updateTabsetPanel(session, "abas", selected = "???? Rede de Atendimento SEMMU")
  })
  
  observeEvent(input$avancar_pessoais, {
    updateTabsetPanel(session, "abas", selected = "???? Informações Pessoais")
  })
  

  observeEvent(input$voltar_preferencias, {
    updateTabsetPanel(session, "abas", selected = "???? Preferências")
  })
  

  
  
  # Envio dos dados
  observeEvent(input$enviar, {
    if (input$nome == "" || input$email == "" || is.na(input$idade)) {
      output$mensagem <- renderText("?????? Preencha todos os campos obrigatórios.")
      return()
    }
    
    nova <- data.frame(
      Data       = Sys.time(),
      Rede_SEMMU = paste(input$rede_semmu, collapse = "; "),
      CRM_Servicos = paste(input$crm_servicos, collapse = "; "),
      Mainha_Servicos = paste(input$mainha_servicos, collapse = "; "),
      Abrigo_Servicos = paste(input$abrigo_servicos, collapse = "; "),
      Movel_Servicos = paste(input$movel_servicos, collapse = "; "),
      Nome       = input$nome,
      Email      = input$email,
      Idade      = input$idade,
      Gênero     = input$genero,
      Gosta_de_R = input$gosta_R,
      Precisa_Apoio = input$precisa_apoio,

      Comentário = input$comentario
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
    updateSelectInput(session, "precisa_apoio", selected = "Não")
    updateCheckboxGroupInput(session, "rede_semmu", selected = character(0))
    updateCheckboxGroupInput(session, "crm_servicos", selected = character(0))
    updateCheckboxGroupInput(session, "mainha_servicos", selected = character(0))
    updateCheckboxGroupInput(session, "abrigo_servicos", selected = character(0))
    updateCheckboxGroupInput(session, "movel_servicos", selected = character(0))
    updateTextAreaInput(session, "comentario", value = "")
    updateTabsetPanel(session, "abas", selected = "???? Início")
  })
}

shinyApp(ui = ui, server = server)