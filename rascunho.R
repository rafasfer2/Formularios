library(shiny)
library(shinyjs)
library(shinyWidgets)
library(shinythemes)
library(DT)
library(bslib)
library(rmarkdown)

# Função auxiliar para rótulo com asterisco vermelho
labelObrigatorio <- function(texto) {  tagList(tags$label(tags$span(strong(texto)), tags$span("*", style = "color:red; margin-left:5px;"))) }

ui <- fluidPage(
  useShinyjs(),
  #theme = shinytheme("flatly"),
  theme = bs_theme(version = 5, bootswatch = "flatly"),  # Bootstrap 5 + tema leve
  
  # Máscaras e estilos
  tags$head(
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.16/jquery.mask.min.js"),
    tags$script(HTML("
      Shiny.addCustomMessageHandler('applyMasks', function(message) {
        $('#cpf').mask('000.000.000-00');
        $('#telefone').mask('(00) 00000-0000');
        $('#rg').mask('00.000.000-0');
        $('#cep').mask('00000-000');
        $('#data_manual').mask('00/00/0000 00:00');
        $('#data_nascimento').mask('00/00/0000');
      });
      $(document).on('click', '.editar', function() {
        var id = $(this).attr('id').split('_')[1];
        Shiny.setInputValue('editar_membro', parseInt(id));
      });
      $(document).on('click', '.remover', function() {
        var id = $(this).attr('id').split('_')[1];
        Shiny.setInputValue('remover_membro', parseInt(id));
      });
        Shiny.addCustomMessageHandler('imprimirTela', function(message) {
        window.print();
      });
 ")),
    tags$style(HTML("
      html, body {
        height: 100%;
        margin: 0;
        padding: 0;
      }
      .main-container {
        min-height: calc(100vh - 100px);
        padding-bottom: 20px;
      }
      .rodape-global {
        background-color: #f0f0f0;
        color: #555;
        text-align: center;
        padding: 15px;
        font-size: 14px;
        border-top: 1px solid #ccc;
      }
      .rodape-inicio {
        background-color: #f8f9fa;
        color: #333;
        text-align: center;
        padding: 15px;
        font-size: 14px;
        border-top: 1px solid #ddd;
        margin-top: 40px;
      }
      .erro input, .erro select, .erro textarea {
        border-color: red !important;
        box-shadow: 0 0 5px red !important;
      }
    @media print {
      body {
        overflow: visible !important;
      }
      .no-print {
        display: none !important;
      }
    }
    "))
  ),
  
  titlePanel(tags$strong("Formulário de Cadastro Inicial SEMMU")),
  
  class = "main-container",
  tabsetPanel(
    id = "abas", # 🟢 Aba 0: Início
    tabPanel(
      "Início",
      div(
        class = "capa",
        h1("Bem-vindo ao Formulário de Cadastro Inicial"),
        p("Este formulário é utilizado para coletar dados sociodemográficos das mulheres atendidas pela Rede de Atendimento SEMMU..."),
        tags$hr(),
        p("📋 Instruções de preenchimento"),
        tags$ul(
          tags$li("✔️ Preenchimento obrigatório: Todos os campos marcados com * devem ser preenchidos."),
          tags$li("📁 Armazenamento local: As informações são salvas em formato CSV."),
          tags$li("🔄 Múltiplas submissões: Você pode enviar quantas respostas forem necessárias."),
          tags$li("🧠 Profissional responsável: Registrar o nome do profissional responsável.")
        ),
        tags$hr(),
        p("🛠️ Notas de Atualização"),
        tags$ul(
          tags$li(tags$em(tags$strong("Versão 2.1 de 04/09/2025:"), "Upload do Documento inserido.")),
          tags$li(tags$em(tags$strong("Versão 2.0 de 21/07/2025:"), "Padronização conforme SINAN.")),
          tags$li(tags$em(tags$strong("Versão 1.0 de 04/06/2025:"), "Primeira versão funcional."))
        ),
        br(),
        div(style = "text-align:center;", actionButton("iniciar", "Preencher formulário", class = "btn-success btn-lg")
        ),
        br(), br(),
        div(class = "rodape-inicio", HTML("📍 Secretaria da Mulher de Parauapebas (SEMMU)<br>Localizada na R. Rio Dourado – Beira Rio, Parauapebas – PA, 68515-000")
        )
      )
    ),
    tabPanel(
      "Rede de Atendimento SEMMU", # 🟤 Aba 1
      div(
        style = "max-height: 80vh; overflow-y: auto; padding-right: 15px;",
        fluidRow(
          column(
            12,
            h4("🏥 Selecione a unidade de atendimento da SEMMU"),
            radioButtons("rede", "Unidade de Atendimento *", 
                         choices = c(
                           "CRM (Centro de Referência da Mulher)", 
                           "Casa de Mainha", 
                           "Casa Abrigo", 
                           "SEMMU Até Você"
                         )
            ),
            
            # CRM
            conditionalPanel(
              condition = "input.rede == 'CRM (Centro de Referência da Mulher)'",
              selectInput("profissional_crm", "Profissional Responsável *",
                          choices = c("Selecione", 
                                      "Arlene Ferreira da Cruz Piovezan", 
                                      "Juliana Pereira Cruz Menezes", 
                                      "Elane Oliveira Corrêa"))
            ),
            
            # Casa de Mainha
            conditionalPanel(
              condition = "input.rede == 'Casa de Mainha'",
              selectInput("profissional_mainha", "Profissional Responsável *",
                          choices = c("Selecione", 
                                      "Daiane Almino Ribeiro", 
                                      "Elizabeth Rodrigues de Bessa", 
                                      "Fabiane Lima de Souza", 
                                      "Keylla Alves da Silva"))
            ),
            
            # Casa Abrigo
            conditionalPanel(
              condition = "input.rede == 'Casa Abrigo'",
              selectInput("profissional_abrigo", "Profissional Responsável *",
                          choices = c("Selecione", 
                                      "Alba Maria Rodrigues", 
                                      "Lucinei Aparecida Santos da Luz", 
                                      "Eva Silva de Lima", 
                                      "Natália de Deus"))
            ),
            
            # SEMMU Até Você
            conditionalPanel(
              condition = "input.rede == 'SEMMU Até Você'",
              tagList(
                selectInput("profissional_movel", "Profissional Responsável *",
                            choices = c("Selecione", 
                                        "Elisangela Moreira", 
                                        "Eleusa", 
                                        "Josélia Viana", 
                                        "Sandra Araújo", 
                                        "Keylla Alves da Silva")),
                radioButtons("polo_visitado", "Polo Visitado *",
                             choices = c("Selecione", 
                                         "Polo 01 - Cedere 1", 
                                         "Polo 02 - Palmares 2", 
                                         "Polo 03 - Valentim Serra", 
                                         "Polo 04 - Paulo Fonteles", 
                                         "Polo 05 - Vila Carimã", 
                                         "Polo 06 - Vila Brasil", 
                                         "Polo 07 - Vila Alto Bonito", 
                                         "Polo 08 - Vila Sansão", 
                                         "Outros")),
                conditionalPanel(
                  condition = "input.polo_visitado == 'Outros'",
                  textInput("polo_outros", "Informe o nome do polo visitado")
                )
              )
            )
          )
        ),
        br(),
        fluidRow(
          column(12, div(style = "text-align:right;", actionButton("proximo2", "Próximo ➡️", class = "btn-primary")))
        )
      )
    ),
    tabPanel(
      "Dados Iniciais de Cadastro", # 🟡 Aba 3: Dados Iniciais de Cadastro
      div(
        style = "max-height: 80vh; overflow-y: auto; padding-right: 15px;",
        fluidRow(
          column(
            12,
            labelObrigatorio("Data e hora do Cadastro"),
            textInput("data_manual", NULL, placeholder = "21/09/2025 13:01"),
            
            labelObrigatorio("Nome Completo da Assistida"),
            textInput("nome_completo", NULL),
            
            labelObrigatorio("Número do CPF"),
            textInput("cpf", NULL, placeholder = "000.000.000-00"),
            
            tags$label(strong("Número do RG")),
            textInput("rg", NULL, placeholder = "00.000.000-0"),
            
            tags$label(strong("Upload do Documento")),
            fileInput("documento", NULL, accept = c(".pdf", ".jpg", ".png")),
            
            labelObrigatorio("Telefone"),
            textInput("telefone", NULL, placeholder = "(99) 99999-9999"),
            
            labelObrigatorio("Tipo de Demanda"),
            radioButtons("tipo_demanda", NULL, choices = c("Espontânea", "Encaminhada pela Rede Intersetorial", "Encaminhamento Interno da Rede SEMMU")),
            
            # Subseções dinâmicas
            conditionalPanel(
              condition = "input.demanda == 'Encaminhada pela Rede Intersetorial'",
              tags$hr(),
              tags$label(strong("Rede Intersetorial")),
              
              radioButtons("rede_intersetorial", labelObrigatorio("Rede Intersetorial"), choices = c("PARAPAZ", "CREAS", "CRAS", "UBS", "HGP", "UBS", "UPA", "Conselho Tutelar", "DEAM", "DEACA", "Ministério Público","SEHAB", "SEMAS", "SEMSI", "SEMED", "Outros")),
              tags$label(strong("Observações de Localidade")),
              textInput("obs_localidade", NULL, placeholder = "Ex: Bairro distante, zona rural, etc.")
            ),
            conditionalPanel(
              condition = "input.demanda == 'Encaminhamento Interno da Rede SEMMU'",
              tags$hr(),
              tags$label(strong("Rede SEMMU")),
              radioButtons("rede_semmu", labelObrigatorio("Rede SEMMU"), choices = c("CRM", "Casa de Mainha", "Casa Abrigo", "SEMMU Até Você", "SEMMU Sede", "Outros"))),
          )
        ),
        actionButton("prev2", "Voltar", class = "btn-secondary"),
        actionButton("next2", "Próximo", class = "btn-primary")
      ),
      tabPanel(
        "Notificação Individual", # 🟠 Aba 4: Notificação Individual
        textInput("nome_social", "Nome Social"),
        textInput("data_nascimento", labelObrigatorio("Data de Nascimento"), placeholder = "21/09/1990"),
        selectInput("naturalidade", labelObrigatorio("Naturalidade (Código IBGE)"), choices = c("Parauapebas (1505536)", "Canaã dos Carajás (1502152)", "Curionópolis (1502772)", "Eldorado dos Carajás (1502954)", "Marabá (1504208)", "Belém (1501402)", "Outros")),
        conditionalPanel(
          condition = "input.naturalidade == 'Outros'",
          textInput("naturalidade_outros", "Informe a naturalidade")
        ),
        selectInput("uf", labelObrigatorio("UF"), choices = c("PA", "MA", "TO", "Outros")),
        conditionalPanel(
          condition = "input.uf == 'Outros'",
          textInput("uf_outros", "Informe a UF")
        ),
        numericInput("quantos_filhos", labelObrigatorio("Quantos filhos possui?"), value = NA, min = 0),
        selectInput("gestante", labelObrigatorio("Gestante"), choices = c("Não", "1° Trimestre (1 a 3 meses)", "2° Trimestre (3 a 6 meses)","3° Trimestre (6 a 9 meses)", "Ignorado")),
        selectInput("raca_cor", labelObrigatorio("Raça/Cor"), choices = c("Branca", "Preta", "Amarela", "Parda", "Indígena", "Ignorado")),
        selectInput("escolaridade", labelObrigatorio("Escolaridade"), choices = c("Sem escolaridade", "Ensino Fundamental Incompleto", "Ensino Fundamental Completo", "Ensino Médio Incompleto", "Ensino Médio Completo", "Superior Incompleto", "Superior Completo", "Alfabetização para adultos", "Educação Especial", "Técnico/Cursos Livres", "Não se aplica", "Ignorado")),
        selectInput("atividade_laboral", labelObrigatorio("Atividade Laboral"), choices = c("Cuidados do Lar não remunerado", "Autônoma Formal (MEI)", "Autônoma Informal", "Trabalho Formal (CLT)", "Desempregada", "Estudante", "Pensão/Aposentadoria", "Servidora Pública", "Outros")),
        conditionalPanel(
          condition = "input.atividade_laboral == 'Outros'",
          textInput("atividade_outros", "Informe a atividade laboral")
        ),
        selectInput("estado_civil", labelObrigatorio("Situação Conjugal/Estado Civil"), choices = c("Solteira", "Casada", "Separada", "Viúva", "União estável")),
        selectInput("deficiencia", labelObrigatorio("Deficiência/Transtorno"), choices = c("Não possui", "Auditiva", "Visual", "Intelectual", "Física", "Psicossocial", "Transtorno Mental", "Transtorno de Comportamento","Múltipla", "Outros")),
        conditionalPanel(
          condition = "input.deficiencia == 'Outros'",
          textInput("deficiencia_outros", "Informe a deficiência ou transtorno")
        ),
        selectInput("orientacao_sexual", labelObrigatorio("Orientação Sexual"), choices = c("Heterossexual", "Homossexual", "Bissexual", "Outros")),
        selectInput("identidade_genero", labelObrigatorio("Identidade de Gênero"), choices = c("Mulher cisgênero", "Mulher transgênero", "Travesti", "Não binária", "Prefere não informar", "Outros")),
        
        actionButton("prev3", "Voltar", class = "btn-secondary"),
        actionButton("next3", "Próximo", class = "btn-primary")
      ),
      
      tabPanel(
        "Dados Familiares",
        div(
          style = "max-height: 80vh; overflow-y: auto; padding-right: 15px;",
          fluidRow(
            column(
              12,
              h4("Resumo dos membros já preenchidos"),
              DT::dataTableOutput("tabela_familia"),
              hr(),
              h4("Preencher novo membro"),
              uiOutput("familia_ui"),
              actionButton("adicionar_familia", "Adicionar outro membro", icon = icon("plus"), class = "btn-info")
            )
          )
        ),
        actionButton("prev4", "Voltar"),
        actionButton("next4", "Próximo", class = "btn-primary"),
        tags$script(HTML("
          $(document).on('click', '.editar', function() {
            var id = $(this).attr('id').split('_')[1];
            Shiny.setInputValue('editar_membro', parseInt(id));
          });
          $(document).on('click', '.remover', function() {
            var id = $(this).attr('id').split('_')[1];
            Shiny.setInputValue('remover_membro', parseInt(id));
          });
        "))
      ),
      
      tabPanel(
        "Dados de Residência", # 🔵 Aba 5: Dados de Residência
        selectInput("municipio_residencia", labelObrigatorio("Município de Residência (Código IBGE)"), choices = c("Parauapebas (1505536)", "Canaã dos Carajás (1502152)", "Curionópolis (1502772)", "Eldorado dos Carajás (1502954)", "Marabá (1504208)", "Belém (1501402)", "Outros")),
        conditionalPanel(
          condition = "input.municipio_residencia == 'Outros'",
          textInput("municipio_outros", "Informe o município de residência")
        ),
        textInput("bairro", labelObrigatorio("Bairro")),
        textInput("logradouro", labelObrigatorio("Logradouro (Rua, Avenida, ...)")),
        textInput("numero", labelObrigatorio("Número")),
        textInput("quadra", "Quadra"),
        textInput("lote", "Lote"),
        textInput("complemento", "Complemento (apto., casa, ...)"),
        selectInput("zona", labelObrigatorio("Zona de residência"), choices = c("", "Urbana", "Rural", "Periurbana", "Indígena", "Quilombola")),
        selectInput("condicao_moradia", labelObrigatorio("Condição de Moradia"), choices = c("Casa própria", "Alugada", "Cedida", "Ocupação", "Abrigo", "Situação de rua", "Outros")),
        conditionalPanel(
          condition = "input.condicao_moradia == 'Outros'",
          textInput("condicao_moradia_outros", "Informe a condição de moradia")
        ),
        textInput("ubs_referencia", "UBS de Referência"),
        actionButton("prev5", "Voltar", class = "btn-secondary"),
        actionButton("next5", "Próximo", class = "btn-primary")
      ),
      
      tabPanel(
        "Descrição da Fonte de Renda", # 🟣 Aba 6: Descrição da fonte de renda
        radioButtons("renda_media", "Renda Média Mensal",  choices = c("Sem renda", "Até 1/4 do salário mínimo", "De 1/4 a 1/2 salário mínimo", "De 1/2 a 1 salário mínimo", "De 1 a 2 salários mínimos",  "De 2 a 3 Salários Mínimos", "De 3 a 5 Salários Mínimos", "Acima de 5 salários mínimos", "Não informado")),
        radioButtons("beneficio_social", "Benefício Social", choices = c("Nenhum", "Bolsa Família", "BPC (Benefício de Prestação Continuada)", "Auxílio Brasil", "Auxílio Emergencial", "Auxílio Doença", "Outros")),
        conditionalPanel(
          condition = "input.beneficio_social == 'Outros'",
          textInput("beneficio_social_outros", "Informe o Benefício Social")
        ),
        numericInput("valor_beneficio", "Valor do Benefício Social (R$)", value = NA, min = 0),
        numericInput("valor_renda_propria", "Valor de Renda Própria (R$)", value = NA, min = 0),
        numericInput("valor_renda_pensao", "Valor de Renda Pensão (R$)", value = NA, min = 0),
        
        actionButton("prev6", "Voltar", class = "btn-secondary"),
        actionButton("enviar", "Enviar", class = "btn-success"),
        verbatimTextOutput("resposta")
      ),
      tabPanel(
        "Revisão Final",
        tags$head(
          tags$style(HTML("
              @media print {
                body {
                  width: 210mm;
                  height: 297mm;
                  margin: 10mm;
                  font-size: 11pt;
                  line-height: 1.4;
                }
                .no-print {
                  display: none !important;
                }
                .print-only {
                  display: block !important;
                }
                .resumo-bloco {
                  page-break-inside: avoid;
                  margin-bottom: 12px;
                }
              }
              .print-only {
                display: none;
              }
          ")
          )
        ),
        div(
          class = "print-only",
          h2("Resumo Final do Cadastro"),
          tags$hr()
        ),
        column(
          12,
          div(
            class = "resumo-bloco",
            h4("📋 Dados Iniciais de Cadastro"),
            verbatimTextOutput("resumo_cadastro")
          ),
          div(class = "resumo-bloco",
              h4("🏥 Rede de Atendimento SEMMU"),
              verbatimTextOutput("resumo_rede")
          ),
          div(
            class = "resumo-bloco",
            h4("🧍 Notificação Individual"),
            verbatimTextOutput("resumo_notificacao")
          ),
          div(
            class = "resumo-bloco",
            h4("👨‍👩‍👧‍👦 Membros da Família"),
            DT::dataTableOutput("resumo_familia")
          ),
          div(
            class = "resumo-bloco",
            h4("🏠 Dados de Residência"),
            verbatimTextOutput("resumo_residencia")
          ),
          div(
            class = "resumo-bloco",
            h4("💰 Fonte de Renda"),
            verbatimTextOutput("resumo_renda")
          ),
          br(),
          div(
            class = "no-print",
            actionButton("editar_cadastro", "Alterar Cadastro", icon = icon("edit"), class = "btn-warning"),
            actionButton("editar_rede", "Alterar Rede", icon = icon("edit"), class = "btn-warning"),
            actionButton("editar_notificacao", "Alterar Notificação", icon = icon("edit"), class = "btn-warning"),
            actionButton("editar_familia", "Alterar Família", icon = icon("edit"), class = "btn-warning"),
            actionButton("editar_residencia", "Alterar Residência", icon = icon("edit"), class = "btn-warning"),
            actionButton("editar_renda", "Alterar Renda", icon = icon("edit"), class = "btn-warning"),
            br(), br(),
            actionButton("imprimir_resumo", "🖨️ Imprimir Resumo", class = "btn-info"),
            actionButton("prev_revisao", "Voltar", class = "btn-secondary"),
            actionButton("confirmar_envio", "Confirmar e Enviar", class = "btn-success")
          )
        ),
        tags$script(HTML("
         Shiny.addCustomMessageHandler('imprimirTela', function(message) {
           window.print();
        });
      "))
      )
    )  # fim do tabsetPanel
  ),   # fim da main-container
  tags$footer(
    style = "
          position: fixed;
          bottom: 0;
          left: 0;
          width: 100%;
          background-color: #e9ecef;
          padding: 10px 20px;
          text-align: center;
          font-size: 12px;
          color: #666;
          border-top: 1px solid #bbb;
          z-index: 999;
        ",
    tags$div(class = "rodape-global",
             HTML("💻 Desenvolvido por Rafael Fernandes — Professor<br>
          Contato: <a href='mailto:rafasfer2@gmail.com'>rafasfer2@gmail.com</a> |
          GitHub: <a href='https://github.com/rafasfer2' target='_blank'>github.com/rafasfer2</a>")
    )
  )   # fim da main-container
)

server <- function(input, output, session) {
  formatar_ausente   <- function(valor) {
    if (is.null(valor) || is.na(valor) || valor == "") {
      return("")
    } else {
      return(as.character(valor))
    }
  }
  formatar_monetario <- function(valor) {
    if (is.null(valor) || is.na(valor) || valor == "") {
      return("")
    } else {
      return(paste0("R$ ", formatC(as.numeric(valor), format = "f", big.mark = ".", decimal.mark = ",", digits = 2)))
    }
  }
  
  # Aplica máscaras nos campos ao carregar
  observe({ session$sendCustomMessage("applyMasks", list()) })
  # Navegação inicial
  observeEvent(input$iniciar, { updateTabsetPanel(session, "abas", selected = "Rede de Atendimento SEMMU") })
  # Navegação entre abas
  observeEvent(input$next1, {
    shinyjs::removeClass("rede_intersetorial", "erro")
    shinyjs::removeClass("rede_semmu", "erro")
    
    erros <- c()
    
    if (input$rede_intersetorial == "") {
      shinyjs::addClass("rede_intersetorial", "erro")
      erros <- c(erros, "Rede Intersetorial")
    }
    
    if (input$rede_semmu == "") {
      shinyjs::addClass("rede_semmu", "erro")
      erros <- c(erros, "Rede SEMMU")
    }
    
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios",
        paste("Preencha os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE
      ))
    } else {
      updateTabsetPanel(session, "abas", selected = "Dados Iniciais de Cadastro")
    }
  })
  
  observeEvent(input$prev2, { updateTabsetPanel(session, "abas", selected = "Rede de Atendimento SEMMU") })
  observeEvent(input$next2, { updateTabsetPanel(session, "abas", selected = "Notificação Individual") })
  
  observeEvent(input$prev3, { updateTabsetPanel(session, "abas", selected = "Dados Iniciais de Cadastro") })
  observeEvent(input$next3, {
    shinyjs::removeClass("data_nascimento", "erro")
    shinyjs::removeClass("naturalidade_outros", "erro")
    shinyjs::removeClass("uf_outros", "erro")
    shinyjs::removeClass("quantos_filhos", "erro")
    
    erros <- c()
    # Data de Nascimento
    data_valida <- tryCatch({
      as.Date(input$data_nascimento, format = "%d/%m/%Y")
    }, error = function(e) NA)
    
    idade <- if (!is.na(data_valida)) {
      as.numeric(difftime(Sys.Date(), data_valida, units = "days")) / 365.25
    } else {
      NA
    }
    
    if (is.na(data_valida)) {
      shinyjs::addClass("data_nascimento", "erro")
      erros <- c(erros, "Data de Nascimento inválida")
    } else if (data_valida > Sys.Date()) {
      shinyjs::addClass("data_nascimento", "erro")
      erros <- c(erros, "Data de Nascimento no futuro")
    } else if (idade < 10) {
      shinyjs::addClass("data_nascimento", "erro")
      erros <- c(erros, "Idade mínima: 10 anos")
    }
    # Naturalidade
    if (input$naturalidade == "Outros" && input$naturalidade_outros == "") {
      shinyjs::addClass("naturalidade_outros", "erro")
      erros <- c(erros, "Naturalidade (Outros)")
    }
    # UF
    if (input$uf == "Outros" && input$uf_outros == "") {
      shinyjs::addClass("uf_outros", "erro")
      erros <- c(erros, "UF (Outros)")
    }
    # Quantos filhos
    if (is.na(input$quantos_filhos) || input$quantos_filhos < 0) {
      shinyjs::addClass("quantos_filhos", "erro")
      erros <- c(erros, "Número de filhos")
    }
    # Exibir mensagem ou avançar
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios ou inválidos",
        paste("Verifique os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE
      ))
    } else {
      updateTabsetPanel(session, "abas", selected = "Dados Familiares")
    }
  })
  
  observeEvent(input$prev4, { updateTabsetPanel(session, "abas", selected = "Notificação Individual") })
  observeEvent(input$next4, { updateTabsetPanel(session, "abas", selected = "Dados de Residência") })
  
  observeEvent(input$prev5, { updateTabsetPanel(session, "abas", selected = "Dados Familiares") })
  observeEvent(input$next5, {
    shinyjs::removeClass("municipio_outros", "erro")
    shinyjs::removeClass("bairro", "erro")
    shinyjs::removeClass("logradouro", "erro")
    shinyjs::removeClass("numero", "erro")
    shinyjs::removeClass("zona", "erro")
    shinyjs::removeClass("condicao_moradia", "erro")
    
    erros <- c()
    
    if (input$municipio_residencia == "Outros" && input$municipio_outros == "") {
      shinyjs::addClass("municipio_outros", "erro")
      erros <- c(erros, "Município (Outros)")
    }
    
    if (input$bairro == "") {
      shinyjs::addClass("bairro", "erro")
      erros <- c(erros, "Bairro")
    }
    
    if (input$logradouro == "") {
      shinyjs::addClass("logradouro", "erro")
      erros <- c(erros, "Logradouro")
    }
    
    if (input$numero == "") {
      shinyjs::addClass("numero", "erro")
      erros <- c(erros, "Número")
    }
    
    if (input$zona == "") {
      shinyjs::addClass("zona", "erro")
      erros <- c(erros, "Zona de Residência")
    }
    
    if (input$condicao_moradia == "") {
      shinyjs::addClass("condicao_moradia", "erro")
      erros <- c(erros, "Condição de Moradia")
    }
    
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios ou inválidos",
        paste("Verifique os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE
      ))
    } else {
      updateTabsetPanel(session, "abas", selected = "Descrição da Fonte de Renda")
    }
  })
  
  observeEvent(input$prev6, {updateTabsetPanel(session, "abas", selected = "Dados de Residência")})
  observeEvent(input$enviar, {updateTabsetPanel(session, "abas", selected = "Revisão Final")})
  
  observeEvent(input$prev_revisao, {updateTabsetPanel(session, "abas", selected = "Descrição da Fonte de Renda")})
  
  # Contador de membros
  #membro_count <- reactiveVal(1)
  # Lista de dados
  dados_familia <- reactiveVal(data.frame())
  # Renderiza tabela com botões de ação
  
  output$familia_ui <- renderUI({
    tagList(
      textInput("nome_familia", "Nome da pessoa da família"),
      radioButtons("parentesco_familia", "Vínculo/grau de parentesco", choices = c("Filho(a)", "Cônjuge", "Irmão(ã)", "Pai", "Mãe", "Avô(ó)", "Tio(a)", "Outro")),
      radioButtons("sexo_familia", "Sexo", choices = c("Feminino", "Masculino")),
      numericInput("idade_familia", "Idade", value = NA, min = 0, max = 120),
      radioButtons("frequenta_escola", "Frequenta escola?", choices = c("Sim", "Não")),
      selectInput("escolaridade_familia", "Escolaridade", choices = c("Selecione", "Sem escolaridade", "Ensino Fundamental Incompleto", "Ensino Fundamental Completo", "Ensino Médio Incompleto", "Ensino Médio Completo", "Superior Incompleto", "Superior Completo", "Alfabetização para adultos", "Educação Especial", "Técnico/Cursos Livres", "Não se aplica", "Ignorado" )),
      textInput("reside_com_quem", "Com quem reside")
    )
  })
  
  familia <- reactiveValues(lista = data.frame())
  
  observeEvent(input$adicionar_familia, {
    novo_membro <- data.frame(
      Nome = input$nome_familia,
      Parentesco = input$parentesco_familia,
      Sexo = input$sexo_familia,
      Idade = input$idade_familia,
      FrequentaEscola = input$frequenta_escola,
      Escolaridade = input$escolaridade_familia,
      ResideCom = input$reside_com_quem,
      stringsAsFactors = FALSE
    )
    familia$lista <- rbind(familia$lista, novo_membro)
    
    # 🔄 Limpa os campos do formulário
    updateTextInput(session, "nome_familia", value = "")
    updateSelectInput(session, "parentesco_familia", selected = "Selecione")
    updateSelectInput(session, "sexo_familia", selected = "Selecione")
    updateNumericInput(session, "idade_familia", value = NA)
    updateRadioButtons(session, "frequenta_escola", selected = character(0))
    updateSelectInput(session, "escolaridade_familia", selected = "Selecione")
    updateSelectInput(session, "reside_com_quem", selected = "Selecione")
    
  })
  
  output$tabela_familia <- DT::renderDataTable({
    df <- familia$lista
    if (nrow(df) == 0) return(NULL)
    
    df$Ações <- paste0(
      '<button class="editar btn btn-sm btn-warning" id="editar_', 1:nrow(df), '">Editar</button> ',
      '<button class="remover btn btn-sm btn-danger" id="remover_', 1:nrow(df), '">Remover</button>'
    )
    
    DT::datatable(df, escape = FALSE, selection = "none", options = list(pageLength = 5))
  })
  
  observeEvent(input$remover_membro, {
    idx <- input$remover_membro
    if (!is.null(idx) && idx <= nrow(familia$lista)) {
      familia$lista <- familia$lista[-idx, ]
    }
  })
  
  observeEvent(input$editar_membro, {
    idx <- input$editar_membro
    membro <- familia$lista[idx, ]
    
    updateTextInput(session, "nome_familia", value = membro$Nome)
    updateSelectInput(session, "parentesco_familia", selected = membro$Parentesco)
    updateSelectInput(session, "sexo_familia", selected = membro$Sexo)
    updateNumericInput(session, "idade_familia", value = membro$Idade)
    updateRadioButtons(session, "frequenta_escola", selected = membro$FrequentaEscola)
    updateSelectInput(session, "escolaridade_familia", selected = membro$Escolaridade)
    updateSelectInput(session, "reside_com_quem", selected = membro$ResideCom)
    
    familia$lista <- familia$lista[-idx, ]  # Remove temporariamente para regravar após edição
  })
  
  # 🔹 Rede de Atendimento
  output$resumo_rede <- renderText({
    unidade <- NULL
    profissional <- NULL
    
    if (input$profissional_crm != "") {
      unidade <- "CRM"
      profissional <- input$profissional_crm
    } else if (input$profissional_mainha != "") {
      unidade <- "Mainha"
      profissional <- input$profissional_mainha
    } else if (input$profissional_abrigo != "") {
      unidade <- "Abrigo"
      profissional <- input$profissional_abrigo
    } else if (input$profissional_movel != "") {
      unidade <- "Móvel"
      profissional <- input$profissional_movel
    }
    
    if (!is.null(unidade) && !is.null(profissional)) {
      paste("Unidade:", unidade, "\nProfissional:", profissional)
    } else {
      "Nenhuma unidade preenchida."
    }
  })
  # 🔹 Dados Iniciais de Cadastro
  output$resumo_cadastro <- renderText({
    texto <- paste(
      "Nome Completo:", formatar_ausente(input$nome_completo),
      "\nCPF:", formatar_ausente(input$cpf),
      "\nRG:", formatar_ausente(input$rg),
      "\nTelefone:", formatar_ausente(input$telefone),
      "\nData do Cadastro:", formatar_ausente(format(input$data_cadastro, "%d/%m/%Y %H:%M")),
      "\nTipo de Demanda:", formatar_ausente(input$tipo_demanda)
    )
    
    if (!is.null(input$tipo_demanda) && nzchar(input$tipo_demanda)) {
      if (input$tipo_demanda == "Encaminhada pela Rede Intersetorial") {
        texto <- paste(texto, "\nRede Intersetorial de Origem:", formatar_ausente(input$rede_intersetorial_origem))
      } else if (input$tipo_demanda == "Encaminhamento Interno da Rede SEMMU") {
        texto <- paste(texto, "\nUnidade da SEMMU de Origem:", formatar_ausente(input$unidade_semmu_origem))
      }
    }
    
    texto
  })
  # 🔹 Notificação Individual
  output$resumo_notificacao <- renderText({
    paste(
      "Nome Social:", input$nome_social,
      "\nData de Nascimento:", input$data_nascimento,
      "\nNaturalidade:", ifelse(input$naturalidade == "Outros", input$naturalidade_outros, input$naturalidade),
      "\nUF:", ifelse(input$uf == "Outros", input$uf_outros, input$uf),
      "\nFilhos:", input$quantos_filhos,
      "\nRaça/Cor:", input$raca_cor,
      "\nEscolaridade:", input$escolaridade,
      "\nAtividade Laboral:", ifelse(input$atividade_laboral == "Outros", input$atividade_outros, input$atividade_laboral),
      "\nEstado Civil:", input$estado_civil,
      "\nDeficiência:", ifelse(input$deficiencia == "Outros", input$deficiencia_outros, input$deficiencia),
      "\nOrientação Sexual:", input$orientacao_sexual,
      "\nIdentidade de Gênero:", input$identidade_genero
    )
  })
  
  output$resumo_familia <- DT::renderDataTable({
    df <- dados_familia()
    if (nrow(df) == 0) return(NULL)
    
    # Remove colunas de ação se existirem
    df <- df[, !(names(df) %in% c("Editar", "Remover"))]
    
    DT::datatable(df, escape = TRUE, selection = 'none', rownames = FALSE,  options = list(dom = 't', paging = FALSE)
    )
  }, server = FALSE)
  # 🔹 Dados de Residência
  output$resumo_residencia <- renderText({
    paste(
      "Município:", ifelse(input$municipio_residencia == "Outros", input$municipio_outros, input$municipio_residencia),
      "\nBairro:", input$bairro,
      "\nLogradouro:", input$logradouro,
      "\nNúmero:", input$numero,
      "\nZona:", input$zona,
      "\nCondição de Moradia:", input$condicao_moradia,
      "\nUBS de Referência:", input$ubs_referencia
    )
  })
  # 🔹 Fonte de Renda
  output$resumo_renda <- renderText({
    paste(
      "Renda Média Mensal:", input$renda_media,
      "\nBenefício Social:", input$beneficio_social,
      "\nValor do Benefício:", formatar_monetario(input$valor_beneficio),
      "\nRenda Própria:", formatar_monetario(input$valor_renda_propria),
      "\nRenda Pensão:", formatar_monetario(input$valor_renda_pensao)
    )
  })
  # 🔹 Botões de edição
  observeEvent(input$editar_rede, {
    updateTabsetPanel(session, "abas", selected = "Rede de Atendimento SEMMU")
  })
  
  observeEvent(input$editar_cadastro, {
    updateTabsetPanel(session, "abas", selected = "Dados Iniciais de Cadastro")
  })
  
  observeEvent(input$editar_notificacao, {
    updateTabsetPanel(session, "abas", selected = "Notificação Individual")
  })
  
  observeEvent(input$editar_familia, {
    updateTabsetPanel(session, "abas", selected = "Dados Familiares")
  })
  
  observeEvent(input$editar_residencia, {
    updateTabsetPanel(session, "abas", selected = "Dados de Residência")
  })
  
  observeEvent(input$editar_renda, {
    updateTabsetPanel(session, "abas", selected = "Descrição da Fonte de Renda")
  })
  
  observeEvent(input$confirmar_envio, {
    profissional <- switch(
      input$rede,
      "CRM (Centro de Referência da Mulher)" = input$profissional_crm,
      "Casa de Mainha" = input$profissional_mainha,
      "Casa Abrigo" = input$profissional_abrigo,
      "SEMMU Até Você" = input$profissional_movel
    )
    
    polo <- if (input$rede == "SEMMU Até Você") {
      if (input$polo_visitado == "Outros") input$polo_outros else input$polo_visitado
    } else {
      NA
    }
    
    municipio <- if (input$municipio_residencia == "Outros") input$municipio_outros else input$municipio_residencia
    atividade <- if (input$atividade_laboral == "Outros") input$atividade_outros else input$atividade_laboral
    deficiencia <- if (input$deficiencia == "Outros") input$deficiencia_outros else input$deficiencia
    
    dados <- data.frame(
      DataHoraSistema = format(Sys.time(), "%d/%m/%Y %H:%M:%S"),
      DataHoraInformada = input$data_manual,
      Unidade = input$rede,
      Profissional = profissional,
      PoloVisitado = polo,
      NomeSocial = input$nome_social,
      DataNascimento = input$data_nascimento,
      Naturalidade = if (input$naturalidade == "Outros") input$naturalidade_outros else input$naturalidade,
      UF = if (input$uf == "Outros") input$uf_outros else input$uf,
      QuantosFilhos = input$quantos_filhos,
      Gestante = input$gestante,
      RacaCor = input$raca_cor,
      Escolaridade = input$escolaridade,
      AtividadeLaboral = atividade,
      EstadoCivil = input$estado_civil,
      Deficiencia = deficiencia,
      OrientacaoSexual = input$orientacao_sexual,
      IdentidadeGenero = input$identidade_genero,
      MunicipioResidencia = municipio,
      Bairro = input$bairro,
      Logradouro = input$logradouro,
      Numero = input$numero,
      Quadra = input$quadra,
      Lote = input$lote,
      Complemento = input$complemento,
      ZonaResidencia = input$zona,
      CondicaoMoradia = input$condicao_moradia,
      UBSReferencia = input$ubs_referencia,
      RendaMedia = input$renda_media,
      BeneficioSocial = input$beneficio_social,
      ValorBeneficio = input$valor_beneficio,
      ValorRendaPropria = input$valor_renda_propria,
      ValorRendaPensao = input$valor_renda_pensao,
      stringsAsFactors = FALSE
    )
    
    # Upload do documento
    if (!is.null(input$documento)) {
      nome_arquivo <- paste0("documento_", gsub("[^0-9]", "", Sys.time()), "_", gsub("\\D", "", input$cpf))
      caminho_destino <- file.path("documentos", paste0(nome_arquivo, "_", input$documento$name))
      dir.create("documentos", showWarnings = FALSE)
      file.copy(input$documento$datapath, caminho_destino)
    }
    
    # Salvamento do cadastro principal
    dir.create("data", showWarnings = FALSE)
    write.table(dados, file = "data/cadastros_semmu.csv", sep = ";", row.names = FALSE,
                col.names = !file.exists("data/cadastros_semmu.csv"), append = TRUE)
    
    # Salvamento dos membros da família
    if (exists("familia") && !is.null(familia$lista) && nrow(familia$lista) > 0) {
      membros <- familia$lista
      membros[] <- lapply(membros, function(col) {
        if (is.numeric(col)) {
          ifelse(is.na(col), 0, col)
        } else {
          ifelse(is.na(col) | col == "", "Valor ausente", as.character(col))
        }
      })
      
      nome_familia <- paste0("familia_", input$cpf, "_", Sys.Date(), ".csv")
      caminho_familia <- file.path("data", nome_familia)
      write.csv(membros, caminho_familia, row.names = FALSE, fileEncoding = "UTF-8")
    }
    
    # Confirmação visual
    showModal(modalDialog(
      title = "✅ Cadastro enviado com sucesso!",
      "Os dados foram registrados e salvos com sucesso.",
      easyClose = TRUE,
      footer = modalButton("Fechar")
    ))
    
    updateTabsetPanel(session, "abas", selected = "Início")
  })
  
  observeEvent(input$imprimir_resumo, {session$sendCustomMessage("imprimirTela", "go")})
  
}

shinyApp(ui = ui, server = server)