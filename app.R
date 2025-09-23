library(shiny)
library(DT)
library(shinyjs)
library(bslib)

labelObrigatorio <- function(texto) {
  div(class = "obrigatorio", tags$label(strong(texto)))
}

ui <- fluidPage(
  useShinyjs(),
  id = "formulario_ui",
  
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  
  tags$head(
    # Estilos visuais para campos obrigatórios e inválidos
    tags$style(HTML("
    .obrigatorio label::after {
      content: ' *';
      color: red;
      font-weight: bold;
    }
    .campo-invalido input,
    .campo-invalido select,
    .campo-invalido textarea {
      border: 2px solid red !important;
      background-color: #ffe6e6;
    }
  ")),
    
    # Biblioteca de máscara
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.16/jquery.mask.min.js"),
    
    # Máscaras aplicadas em tempo real
    tags$script(HTML("
    $(document).on('shiny:inputInitialized', function() {
      $('#telefone').mask('(00) 00000-0000');
      $('#cpf').mask('000.000.000-00');
      $('#rg').mask('00.000.000-0');
      $('#data_manual').mask('00/00/0000 00:00');
      $('#data_nascimento').mask('00/00/0000 00:00');
      $('#numero').mask('00000');
      $('#valor_beneficio').mask('000000.00', {reverse: true});
      $('#valor_renda_propria').mask('000000.00', {reverse: true});
      $('#valor_renda_pensao').mask('000000.00', {reverse: true});
    });

      $(document).on('input', '#telefone', function() {
        $(this).mask('(00) 00000-0000');
      });
      $(document).on('input', '#cpf', function() {
        $(this).mask('000.000.000-00');
      });
      $(document).on('input', '#rg', function() {
        $(this).mask('00.000.000-0');
      });
      $(document).on('input', '#data_manual', function() {
        $(this).mask('00/00/0000 00:00');
      });
      $(document).on('input', '#data_nascimento', function() {
        $(this).mask('00/00/0000 00:00');
      });
      $(document).on('input', '#numero', function() {
        $(this).mask('00000');
      });
      $(document).on('input', '#valor_beneficio', function() {
        $(this).mask('000000.00', {reverse: true});
      });
      $(document).on('input', '#valor_renda_propria', function() {
        $(this).mask('000000.00', {reverse: true});
      });
      $(document).on('input', '#valor_renda_pensao', function() {
        $(this).mask('000000.00', {reverse: true});
      });
    ")),
    
    # Comando de impressão
    tags$script(HTML("
      Shiny.addCustomMessageHandler('imprimirTela', function(message) {
        window.print();
      });
    ")),
    
    tags$style(HTML("
    .campo-invalido input,
    .campo-invalido select,
    .campo-invalido textarea,
    .campo-invalido .form-check-input {
      border: 2px solid red !important;
      background-color: #ffe6e6;
  }
")),
    
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.16/jquery.mask.min.js"),
    tags$script(HTML("
    $(document).on('shiny:inputInitialized', function() {
      $('#valor_beneficio').mask('000000.00', {reverse: true});
      $('#valor_renda_propria').mask('000000.00', {reverse: true});
      $('#valor_renda_pensao').mask('000000.00', {reverse: true});
    });
    $(document).on('input', '#valor_beneficio', function() {
      $(this).mask('000000.00', {reverse: true});
    });
    $(document).on('input', '#valor_renda_propria', function() {
      $(this).mask('000000.00', {reverse: true});
    });
    $(document).on('input', '#valor_renda_pensao', function() {
      $(this).mask('000000.00', {reverse: true});
    });
  "))
  ),
  
  titlePanel(tags$strong("Formulário de Cadastro Inicial - SEMMU")),
  
  tabsetPanel(
    id = "formulario_tabs",
              tabPanel(
                "Início",
                div(
                  class = "capa",
                  h1("📋 Bem-vindo ao Formulário de Cadastro Inicial"),
                  p("Este formulário é utilizado para coletar dados sociodemográficos das mulheres atendidas pela Rede de Atendimento da SEMMU."),
                  
                  tags$hr(),
                  h4("📌 Instruções de Preenchimento"),
                  tags$ul(
                    tags$li("✔️ Todos os campos marcados com * são obrigatórios."),
                    tags$li("📁 Os dados são armazenados localmente em formato CSV."),
                    tags$li("🔄 É possível realizar múltiplos cadastros consecutivos."),
                    tags$li("🧠 É necessário registrar o nome do profissional responsável pelo atendimento.")
                  ),
                  
                  tags$hr(),
                  h4("🛠️ Notas de Atualização"),
                  tags$ul(
                    tags$li(tags$strong("Versão 2.1 – 04/09/2025:"), " Upload de documento ativado."),
                    tags$li(tags$strong("Versão 2.0 – 21/07/2025:"), " Padronização conforme SINAN."),
                    tags$li(tags$strong("Versão 1.0 – 04/06/2025:"), " Primeira versão funcional.")
                  ),
                  
                  br(),
                  div(style = "text-align:center;",
                      actionButton("iniciar", "🟢 Preencher Formulário", class = "btn-success btn-lg")
                  ),
                  
                  br(), br(),
                  div(class = "rodape-inicio",
                      HTML("📍 <strong>Secretaria da Mulher de Parauapebas (SEMMU)</strong><br>Localizada na R. Rio Dourado – Beira Rio, Parauapebas – PA, 68515-000")
                  )
                )
              ),
              
              # Aba 2 – Rede de Atendimento SEMMU
              tabPanel("Rede de Atendimento SEMMU",
                       radioButtons("rede", "Unidade de Atendimento *", choices = c("CRM", "Casa de Mainha", "Casa Abrigo", "SEMMU Até Você")),
                       conditionalPanel("input.rede == 'CRM'", selectInput("profissional_crm", "Profissional:", choices = c("Selecione", "Arlene", "Juliana", "Elane"))),
                       conditionalPanel("input.rede == 'Casa de Mainha'", selectInput("profissional_mainha", "Profissional:", choices = c("Selecione", "Daiane", "Elizabeth", "Fabiane", "Keylla"))),
                       conditionalPanel("input.rede == 'Casa Abrigo'", selectInput("profissional_abrigo", "Profissional:", choices = c("Selecione", "Alba", "Lucinei", "Eva", "Natália"))),
                       conditionalPanel("input.rede == 'SEMMU Até Você'",
                                        selectInput("profissional_movel", "Profissional:", choices = c("Selecione", "Elisangela", "Eleusa", "Josélia", "Sandra", "Keylla")),
                                        radioButtons("polo_visitado", "Polo Visitado:", choices = c("Selecione", "Polo 01", "Polo 02", "Outros")),
                                        conditionalPanel("input.polo_visitado == 'Outros'", textInput("polo_outros", "Nome do Polo"))
                       ),
                       actionButton("proximo2", "Próximo ➡️", class = "btn-primary")
              ),
              
              # Aba 3 – Dados de Cadastro Inicial
              tabPanel(
                "Dados Iniciais de Cadastro",
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
                      radioButtons("tipo_demanda", NULL, choices = c(
                        "Espontânea", 
                        "Encaminhada pela Rede Intersetorial", 
                        "Encaminhamento Interno da Rede SEMMU"
                      )),
                      
                      conditionalPanel(
                        condition = "input.tipo_demanda == 'Encaminhada pela Rede Intersetorial'",
                        tags$hr(),
                        labelObrigatorio("Rede Intersetorial"),
                        radioButtons("rede_intersetorial", NULL, choices = c(
                          "PARAPAZ", "CREAS", "CRAS", "UBS", "HGP", "UPA", "Conselho Tutelar", "DEAM", "DEACA", 
                          "Ministério Público", "SEHAB", "SEMAS", "SEMSI", "SEMED", "Outros"
                        )),
                        tags$label(strong("Observações de Localidade")),
                        textInput("obs_localidade", NULL, placeholder = "Ex: Bairro distante, zona rural, etc.")
                      ),
                      
                      conditionalPanel(
                        condition = "input.tipo_demanda == 'Encaminhamento Interno da Rede SEMMU'",
                        tags$hr(),
                        labelObrigatorio("Rede SEMMU"),
                        radioButtons("rede_semmu", NULL, choices = c(
                          "CRM", "Casa de Mainha", "Casa Abrigo", "SEMMU Até Você", "SEMMU Sede", "Outros"
                        ))
                      )
                    )
                  ),
                  br(),
                  fluidRow(
                    column(6, actionButton("prev2", "⬅️ Voltar", class = "btn-secondary")),
                    column(6, div(style = "text-align:right;", actionButton("proximo3", "Próximo ➡️", class = "btn-primary")))
                  )
                )
              ),
              
              # Aba 4 – Notificação Individual
    tabPanel("Notificação Individual",
             div(
               labelObrigatorio("Data de Nascimento"),
               textInput("data_nascimento", label = NULL, placeholder = "dd/mm/yyyy hh:mm")
             ),
             div(
               labelObrigatorio("Naturalidade"),
               selectInput("naturalidade", label = NULL, choices = c("Itabira", "Belo Horizonte", "Outro"))
             ),
             div(
               labelObrigatorio("UF"),
               selectInput("uf", label = NULL, choices = c("MG", "SP", "RJ", "BA", "RS", "Outro"))
             ),
             div(
               labelObrigatorio("Quantidade de Filhos"),
               numericInput("quantos_filhos", label = NULL, value = NA, min = 0)
             ),
             div(
               labelObrigatorio("Gestante"),
               radioButtons("gestante", label = NULL, inline = TRUE, choices = c(
                 "Não", "1° Trimestre (1 a 3 meses)", "2° Trimestre (3 a 6 meses)",
                 "3° Trimestre (6 a 9 meses)", "Ignorado"
               ))
             ),
             div(
               labelObrigatorio("Raça/Cor"),
               radioButtons("raca_cor", label = NULL, inline = TRUE, choices = c(
                 "Branca", "Preta", "Parda", "Amarela", "Indígena", "Ignorado"
               ))
             ),
             div(
               labelObrigatorio("Escolaridade"),
               radioButtons("escolaridade", label = NULL, inline = FALSE, choices = c(
                 "Analfabeta", "Fundamental", "Médio", "Superior", "Pós-graduação", "Ignorado"
               ))
             ),
             div(
               labelObrigatorio("Atividade Laboral"),
               radioButtons("atividade_laboral", label = NULL, inline = TRUE, choices = c(
                 "Empregada", "Desempregada", "Autônoma", "Estudante", "Aposentada", "Ignorado"
               ))
             ),
             div(
               labelObrigatorio("Estado Civil"),
               radioButtons("estado_civil", label = NULL, inline = TRUE, choices = c(
                 "Solteira", "Casada", "Separada", "Divorciada", "Viúva", "União Estável", "Ignorado"
               ))
             ),
             div(
               labelObrigatorio("Deficiência ou Transtorno"),
               radioButtons("deficiencia", label = NULL, inline = FALSE, choices = c(
                 "Nenhuma", "Auditiva", "Visual", "Intelectual", "Física", "Transtorno Mental", "Ignorado"
               ))
             ),
             div(
               labelObrigatorio("Orientação Sexual"),
               radioButtons("orientacao_sexual", label = NULL, inline = TRUE, choices = c(
                 "Heterossexual", "Homossexual", "Bissexual", "Outro", "Ignorado"
               ))
             ),
             div(
               labelObrigatorio("Identidade de Gênero"),
               radioButtons("identidade_genero", label = NULL, inline = TRUE, choices = c(
                 "Cisgênero", "Transgênero", "Não-binário", "Outro", "Ignorado"
               ))
             ),
             br(),
             actionButton("proximo4", "Próximo ➡️", class = "btn-primary")
    ),
              
              # Aba 5 – Dados Familiares
    tabPanel("Dados Familiares",
             h4("👨‍👩‍👧‍👦 Membros da Família que residem com a assistida"),
             
             div(
               labelObrigatorio("Nome do Membro"),
               textInput("nome_familia", label = NULL)
             ),
             div(
               labelObrigatorio("Vínculo/grau de parentesco"),
               radioButtons("parentesco_familia", label = NULL, inline = TRUE, choices = c(
                 "Filho(a)", "Cônjuge", "Irmão(ã)", "Pai", "Mãe", "Avô(ó)", "Tio(a)", "Outro"
               ))
             ),
             div(
               labelObrigatorio("Sexo"),
               radioButtons("sexo_familia", label = NULL, inline = TRUE, choices = c(
                 "Masculino", "Feminino", "Outro"
               ))
             ),
             div(
               labelObrigatorio("Idade"),
               numericInput("idade_familia", label = NULL, value = NA, min = 0)
             ),
             div(
               labelObrigatorio("Frequenta Escola?"),
               radioButtons("frequenta_escola", label = NULL, inline = TRUE, choices = c("Sim", "Não"))
             ),
             div(
               labelObrigatorio("Escolaridade"),
               radioButtons("escolaridade_familia", label = NULL, inline = FALSE, choices = c(
                 "Creche", "Pré-escola", "Fundamental", "Médio", "Superior", "Não se aplica"
               ))
             ),
             div(
               labelObrigatorio("Reside com a assistida?"),
               radioButtons("reside_com_quem", label = NULL, inline = TRUE, choices = c("Sim", "Não"))
             ),
             
             br(),
             actionButton("adicionar_familia", "➕ Adicionar Membro", class = "btn-success"),
             br(), br(),
             
             DT::dataTableOutput("tabela_familia"),
             
             br(),
             actionButton("proximo5", "Próximo ➡️", class = "btn-primary")
    ),
              
              # Aba 6 – Dados de Residência
    tabPanel("Dados de Residência",
             h4("🏠 Informações sobre o local de moradia"),
             
             div(
               labelObrigatorio("Município de Residência"),
               selectInput("municipio_residencia", label = NULL, choices = c("Itabira", "Belo Horizonte", "Outro"))
             ),
             div(
               labelObrigatorio("Bairro"),
               textInput("bairro", label = NULL)
             ),
             div(
               labelObrigatorio("Logradouro"),
               textInput("logradouro", label = NULL)
             ),
             div(
               labelObrigatorio("Número"),
               textInput("numero", label = NULL, placeholder = "Ex: 123")
             ),
             div(
               labelObrigatorio("Zona de Residência"),
               radioButtons("zona", label = NULL, inline = TRUE, choices = c("Urbana", "Rural", "Ignorado"))
             ),
             div(
               labelObrigatorio("Condição de Moradia"),
               radioButtons("condicao_moradia", label = NULL, inline = FALSE, choices = c(
                 "Própria", "Alugada", "Cedida", "Ocupação", "Abrigo", "Situação de Rua", "Ignorado"
               ))
             ),
             div(
               labelObrigatorio("UBS de Referência"),
               textInput("ubs_referencia", label = NULL)
             ),
             
             br(),
             actionButton("proximo6", "Próximo ➡️", class = "btn-primary")
    ),
              
              # Aba 7 – Descrição da Fonte de Renda
    tabPanel("Descrição da Fonte de Renda",
             h4("💰 Informações sobre renda e benefícios"),
             
             div(
               labelObrigatorio("Faixa de Renda Mensal"),
               radioButtons("renda_media", label = NULL, inline = FALSE, choices = c(
                 "Sem renda", "Até R$ 600", "De R$ 601 a R$ 1.200", "De R$ 1.201 a R$ 2.500",
                 "Acima de R$ 2.500", "Ignorado"
               ))
             ),
             div(
               labelObrigatorio("Recebe Benefício Social?"),
               radioButtons("beneficio_social", label = NULL, inline = TRUE, choices = c("Sim", "Não"))
             ),
             div(
               numericInput("valor_beneficio", "Valor do Benefício Social (R$)", value = NA, min = 0)
             ),
             div(
               numericInput("valor_renda_propria", "Valor de Renda Própria (R$)", value = NA, min = 0)
             ),
             div(
               numericInput("valor_renda_pensao", "Valor de Renda Pensão (R$)", value = NA, min = 0)
             ),
             
             br(),
             actionButton("proximo7", "Próximo ➡️", class = "btn-primary")
    ),

              # Aba 8 - Revisão final
              tabPanel(
                "Revisão Final",
                div(
                  style = "max-height: 80vh; overflow-y: auto; padding-right: 15px;",
                  fluidRow(column(12, h4("📌 Revisão dos Dados Informados"))),
                  
                  fluidRow(column(12, verbatimTextOutput("resumo_cadastro"))),
                  actionButton("editar_cadastro", "✏️ Editar Cadastro", class = "btn-sm btn-warning"),
                  
                  tags$hr(),
                  fluidRow(column(12, verbatimTextOutput("resumo_rede"))),
                  actionButton("editar_rede", "✏️ Editar Rede", class = "btn-sm btn-warning"),
                  
                  tags$hr(),
                  fluidRow(column(12, verbatimTextOutput("resumo_notificacao"))),
                  actionButton("editar_notificacao", "✏️ Editar Notificação", class = "btn-sm btn-warning"),
                  
                  tags$hr(),
                  fluidRow(column(12, DT::dataTableOutput("resumo_familia"))),
                  actionButton("editar_familia", "✏️ Editar Família", class = "btn-sm btn-warning"),
                  
                  tags$hr(),
                  fluidRow(column(12, verbatimTextOutput("resumo_residencia"))),
                  actionButton("editar_residencia", "✏️ Editar Residência", class = "btn-sm btn-warning"),
                  
                  tags$hr(),
                  fluidRow(column(12, verbatimTextOutput("resumo_renda"))),
                  actionButton("editar_renda", "✏️ Editar Renda", class = "btn-sm btn-warning"),
                  
                  tags$hr(),
                  fluidRow(
                    column(6, actionButton("voltar7", "⬅️ Voltar", class = "btn-secondary")),
                    column(6, div(style = "text-align:right;",
                                  actionButton("imprimir_resumo", "🖨️ Imprimir", class = "btn-info"),
                                  actionButton("salvar", "💾 Salvar Cadastro", class = "btn-success")
                    ))
                  )
                )
              ),
              # Aba 9 - Finalizado
              
              tabPanel(
                "Finalizado",
                div(
                  style = "max-height: 80vh; overflow-y: auto; padding: 30px; text-align: center;",
                  h2("✅ Cadastro Concluído com Sucesso!"),
                  br(),
                  p("Os dados foram salvos e estão disponíveis no painel administrativo."),
                  p("Você pode realizar um novo cadastro ou retornar à aba inicial."),
                  br(), br(),
                  actionButton("novo_cadastro", "🟢 Novo Cadastro", class = "btn-success btn-lg")
                )
              ),
              
              tabPanel("Administração",
                       h4("📊 Painel de Cadastros"),
                       DT::dataTableOutput("tabela_cadastros"),
                       br(),
                       downloadButton("baixar_csv", "📥 Baixar todos os dados"),
                       br(), br(),
                       uiOutput("baixar_documento_ui"),
                       downloadButton("baixar_documento", "📎 Baixar Documento Selecionado")
              )
  ) # Fim do tabsetPanel
)

server <- function(input, output, session) {
  `%||%` <- function(a, b) if (!is.null(a) && a != "") a else b
  
  validarCampo <- function(id, valor, mensagem, session) {
    if (is.null(valor) || valor == "") {
      shinyjs::addClass(selector = paste0("#", id), class = "campo-invalido")
      showModal(modalDialog(title = "⚠️ Campo obrigatório", mensagem, easyClose = TRUE))
      return(FALSE)
    } else {
      shinyjs::removeClass(selector = paste0("#", id), class = "campo-invalido")
      return(TRUE)
    }
    
    if (!validarCampo("data_nascimento", input$data_nascimento, "Preencha a data e hora de nascimento.", session)) return()
  }
  resetFormulario <- function(session) {
    shinyjs::reset("formulario_ui")  # ID do container principal
    familia$lista <- data.frame()    # Limpa a tabela de membros
  }
  
  # 🔄 Navegação entre abas
  observeEvent(input$iniciar, { updateTabsetPanel(session, "formulario_tabs", selected = "Rede de Atendimento SEMMU") })
  observeEvent(input$proximo2, {
    updateTabsetPanel(session, "formulario_tabs", selected = "Dados Iniciais de Cadastro")
  })
  observeEvent(input$proximo3, {
    if (!validarCampo("data_manual", input$data_manual, "Preencha a data e hora do cadastro.", session)) return()
    if (!validarCampo("nome_completo", input$nome_completo, "Preencha o nome completo da assistida.", session)) return()
    if (!validarCampo("cpf", input$cpf, "Preencha o CPF.", session)) return()
    if (!validarCampo("telefone", input$telefone, "Preencha o telefone.", session)) return()
    if (!validarCampo("tipo_demanda", input$tipo_demanda, "Selecione o tipo de demanda.", session)) return()
    
    if (input$tipo_demanda == "Encaminhada pela Rede Intersetorial" &&
        !validarCampo("rede_intersetorial", input$rede_intersetorial, "Selecione a rede intersetorial.", session)) return()
    
    if (input$tipo_demanda == "Encaminhamento Interno da Rede SEMMU" &&
        !validarCampo("rede_semmu", input$rede_semmu, "Selecione a rede SEMMU.", session)) return()
    
    updateTabsetPanel(session, "formulario_tabs", selected = "Notificação Individual")
  })
  observeEvent(input$proximo4, {
    campos <- list(
      list(input$data_nascimento, "Preencha a data de nascimento."),
      list(input$naturalidade, "Selecione a naturalidade."),
      list(input$uf, "Selecione a UF."),
      list(input$quantos_filhos, "Informe quantos filhos possui."),
      list(input$gestante, "Selecione a situação gestacional."),
      list(input$raca_cor, "Selecione a raça/cor."),
      list(input$escolaridade, "Selecione a escolaridade."),
      list(input$atividade_laboral, "Selecione a atividade laboral."),
      list(input$estado_civil, "Selecione o estado civil."),
      list(input$deficiencia, "Selecione a deficiência ou transtorno."),
      list(input$orientacao_sexual, "Selecione a orientação sexual."),
      list(input$identidade_genero, "Selecione a identidade de gênero.")
    )
    for (campo in campos) {
      if (!validarCampo(campo[[1]], campo[[2]])) return()
    }
    updateTabsetPanel(session, "formulario_tabs", selected = "Dados Familiares")
  })
  observeEvent(input$proximo4, {
    campos <- list(
      list("data_nascimento", input$data_nascimento, "Preencha a data de nascimento."),
      list("naturalidade", input$naturalidade, "Selecione a naturalidade."),
      list("uf", input$uf, "Selecione a UF."),
      list("quantos_filhos", input$quantos_filhos, "Informe a quantidade de filhos."),
      list("gestante", input$gestante, "Selecione a situação gestacional."),
      list("raca_cor", input$raca_cor, "Selecione a raça/cor."),
      list("escolaridade", input$escolaridade, "Selecione a escolaridade."),
      list("atividade_laboral", input$atividade_laboral, "Selecione a atividade laboral."),
      list("estado_civil", input$estado_civil, "Selecione o estado civil."),
      list("deficiencia", input$deficiencia, "Selecione a deficiência ou transtorno."),
      list("orientacao_sexual", input$orientacao_sexual, "Selecione a orientação sexual."),
      list("identidade_genero", input$identidade_genero, "Selecione a identidade de gênero.")
    )
    
    for (campo in campos) {
      if (!validarCampo(campo[[1]], campo[[2]], campo[[3]], session)) return()
    }
    
    updateTabsetPanel(session, "formulario_tabs", selected = "Dados Familiares")
  })
  observeEvent(input$proximo5, {
    if (nrow(familia$lista) == 0) {
      showModal(modalDialog(
        title = "⚠️ Nenhum membro cadastrado",
        "Adicione pelo menos um membro familiar antes de continuar.",
        easyClose = TRUE
      ))
      return()
    }
    
    updateTabsetPanel(session, "formulario_tabs", selected = "Dados de Residência")
  })
  observeEvent(input$proximo6, {
    campos <- list(
      list("municipio_residencia", input$municipio_residencia, "Selecione o município de residência."),
      list("bairro", input$bairro, "Preencha o bairro."),
      list("logradouro", input$logradouro, "Preencha o logradouro."),
      list("numero", input$numero, "Preencha o número."),
      list("zona", input$zona, "Selecione a zona de residência."),
      list("condicao_moradia", input$condicao_moradia, "Selecione a condição de moradia."),
      list("ubs_referencia", input$ubs_referencia, "Preencha a UBS de referência.")
    )
    
    for (campo in campos) {
      if (!validarCampo(campo[[1]], campo[[2]], campo[[3]], session)) return()
    }
    
    updateTabsetPanel(session, "formulario_tabs", selected = "Descrição da Fonte de Renda")
  })
  observeEvent(input$proximo7, {
    campos <- list(
      list("renda_media", input$renda_media, "Selecione a faixa de renda mensal."),
      list("beneficio_social", input$beneficio_social, "Selecione o benefício social."),
      list("valor_beneficio", input$valor_beneficio, "Informe o valor do benefício."),
      list("valor_renda_propria", input$valor_renda_propria, "Informe o valor da renda própria."),
      list("valor_renda_pensao", input$valor_renda_pensao, "Informe o valor da pensão.")
    )
    
    for (campo in campos) {
      if (!validarCampo(campo[[1]], campo[[2]], campo[[3]], session)) return()
    }
    
    updateTabsetPanel(session, "formulario_tabs", selected = "Revisão Final")
  })
  observeEvent(input$voltar7,  { updateTabsetPanel(session, "formulario_tabs", selected = "Descrição da Fonte de Renda") })
  observeEvent(input$novo_cadastro, {
    updateTabsetPanel(session, "formulario_tabs", selected = "Rede de Atendimento SEMMU")
  })
  
  # 🧍 Profissional e polo
  profissional <- reactive({
    switch(input$rede,
           "CRM" = input$profissional_crm,
           "Casa de Mainha" = input$profissional_mainha,
           "Casa Abrigo" = input$profissional_abrigo,
           "SEMMU Até Você" = input$profissional_movel,
           NULL
    )
  })
  
  polo <- reactive({
    if (input$rede == "SEMMU Até Você") {
      if (input$polo_visitado == "Outros") input$polo_outros else input$polo_visitado
    } else {
      NA
    }
  })
  
  # 👨‍👩‍👧‍👦 Membros da família
  familia <- reactiveValues(lista = data.frame(
    Nome = character(),
    Parentesco = character(),
    Sexo = character(),
    Idade = numeric(),
    FrequentaEscola = character(),
    Escolaridade = character(),
    ResideCom = character(),
    stringsAsFactors = FALSE
  ))
  
  observeEvent(input$adicionar_familia, {
    campos <- list(
      list("nome_familia", input$nome_familia, "Preencha o nome do membro."),
      list("parentesco_familia", input$parentesco_familia, "Selecione o parentesco."),
      list("sexo_familia", input$sexo_familia, "Selecione o sexo."),
      list("idade_familia", input$idade_familia, "Informe a idade."),
      list("frequenta_escola", input$frequenta_escola, "Selecione se frequenta escola."),
      list("escolaridade_familia", input$escolaridade_familia, "Selecione a escolaridade."),
      list("reside_com_quem", input$reside_com_quem, "Selecione se reside com a assistida.")
    )
    
    for (campo in campos) {
      if (!validarCampo(campo[[1]], campo[[2]], campo[[3]], session)) return()
    }
    
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
    
    # Limpa os campos após adicionar
    updateTextInput(session, "nome_familia", value = "")
    updateRadioButtons(session, "parentesco_familia", selected = character(0))
    updateSelectInput(session, "sexo_familia", selected = character(0))
    updateNumericInput(session, "idade_familia", value = NA)
    updateRadioButtons(session, "frequenta_escola", selected = character(0))
    updateSelectInput(session, "escolaridade_familia", selected = character(0))
    updateSelectInput(session, "reside_com_quem", selected = character(0))
  })
  
  observeEvent(input$adicionar_familia, {
    campos <- list(
      list("nome_familia", input$nome_familia, "Preencha o nome do membro."),
      list("parentesco_familia", input$parentesco_familia, "Selecione o parentesco."),
      list("sexo_familia", input$sexo_familia, "Selecione o sexo."),
      list("idade_familia", input$idade_familia, "Informe a idade."),
      list("frequenta_escola", input$frequenta_escola, "Selecione se frequenta escola."),
      list("escolaridade_familia", input$escolaridade_familia, "Selecione a escolaridade."),
      list("reside_com_quem", input$reside_com_quem, "Selecione se reside com a assistida.")
    )
    
    for (campo in campos) {
      if (!validarCampo(campo[[1]], campo[[2]], campo[[3]], session)) return()
    }
    
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
    
    # Limpa os campos
    updateTextInput(session, "nome_familia", value = "")
    updateSelectInput(session, "parentesco_familia", selected = "Pai")
    updateSelectInput(session, "sexo_familia", selected = "Masculino")
    updateNumericInput(session, "idade_familia", value = NA)
    updateRadioButtons(session, "frequenta_escola", selected = character(0))
    updateSelectInput(session, "escolaridade_familia", selected = "Creche")
    updateSelectInput(session, "reside_com_quem", selected = "Sim")
  })
  
  output$tabela_familia <- DT::renderDataTable({
    df <- familia$lista
    if (nrow(df) == 0) return(NULL)
    datatable(df, options = list(pageLength = 5), rownames = FALSE)
  })
  
  # 📋 Resumo final
  output$resumo_rede <- renderText({
    unidade <- input$rede %||% ""
    prof <- profissional() %||% ""
    polo_nome <- polo() %||% ""
    
    frase_polo <- if (polo_nome != "" && polo_nome != "Selecione") paste0(", no polo ", polo_nome) else ""
    
    paste0("Atendimento realizado na unidade ", unidade, " por ", prof, frase_polo, ".")
  })
  output$resumo_cadastro <- renderText({
    nome <- input$nome %||% ""
    cpf <- input$cpf %||% ""
    rg <- input$rg %||% ""
    telefone <- input$telefone %||% ""
    data <- input$data_cadastro %||% ""
    tipo <- input$tipo_demanda %||% ""
    origem <- input$demanda %||% ""
    
    paste0(
      "Cadastro realizado em ", data, " para a assistida ", nome,
      ", CPF ", cpf, ", RG ", rg,
      ". Contato informado: ", telefone,
      ". Tipo de demanda: ", tipo,
      ", originada por: ", origem, "."
    )
  })
  output$resumo_notificacao <- renderText({
    naturalidade <- if (!is.null(input$naturalidade) && input$naturalidade == "Outros") input$naturalidade_outros else input$naturalidade
    uf <- if (!is.null(input$uf) && input$uf == "Outros") input$uf_outros else input$uf
    atividade <- if (!is.null(input$atividade_laboral) && input$atividade_laboral == "Outros") input$atividade_outros else input$atividade_laboral
    deficiencia <- if (!is.null(input$deficiencia) && input$deficiencia == "Outros") input$deficiencia_outros else input$deficiencia
    
    paste0(
      "Nome social: ", input$nome_social %||% "", ". Nascida em ", input$data_nascimento %||% "",
      ", natural de ", naturalidade %||% "", ", estado ", uf %||% "",
      ". Possui ", input$quantos_filhos %||% "0", " filho(s), gestante: ", input$gestante %||% "",
      ". Raça/cor: ", input$raca_cor %||% "", ", escolaridade: ", input$escolaridade %||% "",
      ". Atividade laboral: ", atividade %||% "", ", estado civil: ", input$estado_civil %||% "",
      ", deficiência/transtorno: ", deficiencia %||% "",
      ". Orientação sexual: ", input$orientacao_sexual %||% "",
      ", identidade de gênero: ", input$identidade_genero %||% "", "."
    )
  })
  output$resumo_familia <- DT::renderDataTable({
    datatable(familia$lista, options = list(pageLength = 5), rownames = FALSE)
  })
  output$resumo_renda <- renderText({
    beneficio <- if (!is.null(input$beneficio_social) && input$beneficio_social == "Outros") input$beneficio_social_outros else input$beneficio_social
    
    paste0(
      "Faixa de renda mensal: ", input$renda_media %||% "",
      ". Benefício social: ", beneficio %||% "",
      ", valor do benefício: R$ ", input$valor_beneficio %||% "0",
      ", renda própria: R$ ", input$valor_renda_propria %||% "0",
      ", pensão: R$ ", input$valor_renda_pensao %||% "0", "."
    )
  })
  output$resumo_renda <- renderText({
    paste0(
      "Faixa de renda mensal: ", input$renda_media, 
      ". Benefício social: ", if (input$beneficio_social == "Outros") input$beneficio_social_outros else input$beneficio_social,
      ", valor do benefício: R$ ", input$valor_beneficio,
      ", renda própria: R$ ", input$valor_renda_propria,
      ", pensão: R$ ", input$valor_renda_pensao, "."
    )
  })
  
  # 🖨️ Impressão
  observeEvent(input$imprimir_resumo, {
    session$sendCustomMessage("imprimirTela", list())
  })
  
  # 🔁 Botões de edição
  observeEvent(input$editar_cadastro, { updateTabsetPanel(session, "formulario_tabs", selected = "Dados de Cadastro Inicial") })
  observeEvent(input$editar_rede,     { updateTabsetPanel(session, "formulario_tabs", selected = "Rede de Atendimento SEMMU") })
  observeEvent(input$editar_notificacao, { updateTabsetPanel(session, "formulario_tabs", selected = "Notificação Individual") })
  observeEvent(input$editar_familia,  { updateTabsetPanel(session, "formulario_tabs", selected = "Dados Familiares") })
  observeEvent(input$editar_residencia, { updateTabsetPanel(session, "formulario_tabs", selected = "Dados de Residência") })
  observeEvent(input$editar_renda,    { updateTabsetPanel(session, "formulario_tabs", selected = "Descrição da Fonte de Renda") })
  observeEvent(input$novo_cadastro, {
    showModal(modalDialog(
      title = "🔄 Iniciar Novo Cadastro?",
      "Isso apagará os dados preenchidos. Deseja continuar?",
      footer = tagList(
        modalButton("Cancelar"),
        actionButton("confirmar_novo", "Sim, iniciar novo", class = "btn-danger")
      ),
      easyClose = TRUE
    ))
  })
  observeEvent(input$confirmar_novo, {
    removeModal()
    resetFormulario(session)
    updateTabsetPanel(session, "formulario_tabs", selected = "Rede de Atendimento SEMMU")
  })
  
  observeEvent(input$salvar, {
    if (!dir.exists("documentos")) dir.create("documentos")
    
    # Validações obrigatórias
    if (is.null(input$data_manual) || input$data_manual == "") {
      showModal(modalDialog("⚠️ Preencha a data e hora do cadastro.", easyClose = TRUE))
      return()
    }
    
    if (is.null(input$nome_completo) || input$nome_completo == "") {
      showModal(modalDialog("⚠️ Preencha o nome completo da assistida.", easyClose = TRUE))
      return()
    }
    
    if (is.null(input$cpf) || input$cpf == "") {
      showModal(modalDialog("⚠️ Preencha o CPF.", easyClose = TRUE))
      return()
    }
    
    if (is.null(input$telefone) || input$telefone == "") {
      showModal(modalDialog("⚠️ Preencha o telefone.", easyClose = TRUE))
      return()
    }
    
    if (is.null(input$tipo_demanda) || input$tipo_demanda == "") {
      showModal(modalDialog("⚠️ Selecione o tipo de demanda.", easyClose = TRUE))
      return()
    }
    
    # Validação condicional: se demanda for intersetorial
    if (input$tipo_demanda == "Encaminhada pela Rede Intersetorial" &&
        (is.null(input$rede_intersetorial) || input$rede_intersetorial == "")) {
      showModal(modalDialog("⚠️ Selecione a rede intersetorial.", easyClose = TRUE))
      return()
    }
    
    # Validação condicional: se demanda for interna SEMMU
    if (input$tipo_demanda == "Encaminhamento Interno da Rede SEMMU" &&
        (is.null(input$rede_semmu) || input$rede_semmu == "")) {
      showModal(modalDialog("⚠️ Selecione a rede SEMMU.", easyClose = TRUE))
      return()
    }
    
    # Validação final: nome, CPF, profissional, tipo de demanda
    if (!validarCampo("nome_completo", input$nome_completo, "Preencha o nome completo da assistida.", session)) return()
    if (!validarCampo("cpf", input$cpf, "Preencha o CPF.", session)) return()
    if (!validarCampo("telefone", input$telefone, "Preencha o telefone.", session)) return()
    if (!validarCampo("tipo_demanda", input$tipo_demanda, "Selecione o tipo de demanda.", session)) return()
    if (nrow(familia$lista) == 0) {
      showModal(modalDialog("⚠️ Adicione pelo menos um membro familiar.", easyClose = TRUE))
      return()
    }
    
    nome_documento <- NA
    if (!is.null(input$documento_id)) {
      nome_documento <- input$documento_id$name
      caminho_destino <- file.path("documentos", nome_documento)
      file.copy(input$documento_id$datapath, caminho_destino)
    }
    
    dados <- data.frame(
      Data_Cadastro = input$data_cadastro,
      Unidade = input$rede,
      Profissional_Responsavel = profissional(),
      Polo_Visitado = polo(),
      Nome = input$nome,
      CPF = input$cpf,
      RG = input$rg,
      Telefone = input$telefone,
      Tipo_Demanda = input$tipo_demanda,
      Origem_Demanda = input$demanda,
      Rede_Intersetorial = input$rede_intersetorial,
      Observacoes_Localidade = input$obs_localidade,
      Rede_SEMMU = input$rede_semmu,
      Nome_Social = input$nome_social,
      Data_Nascimento = input$data_nascimento,
      Naturalidade = if (input$naturalidade == "Outros") input$naturalidade_outros else input$naturalidade,
      UF = if (input$uf == "Outros") input$uf_outros else input$uf,
      Filhos = input$quantos_filhos,
      Gestante = input$gestante,
      Raca_Cor = input$raca_cor,
      Escolaridade = input$escolaridade,
      Atividade_Laboral = if (input$atividade_laboral == "Outros") input$atividade_outros else input$atividade_laboral,
      Estado_Civil = input$estado_civil,
      Deficiencia = if (input$deficiencia == "Outros") input$deficiencia_outros else input$deficiencia,
      Orientacao_Sexual = input$orientacao_sexual,
      Identidade_Genero = input$identidade_genero,
      Municipio_Residencia = if (input$municipio_residencia == "Outros") input$municipio_outros else input$municipio_residencia,
      Bairro = input$bairro,
      Logradouro = input$logradouro,
      Numero = input$numero,
      Quadra = input$quadra,
      Lote = input$lote,
      Complemento = input$complemento,
      Zona = input$zona,
      Condicao_Moradia = if (input$condicao_moradia == "Outros") input$condicao_moradia_outros else input$condicao_moradia,
      UBS_Referencia = input$ubs_referencia,
      Faixa_Renda = input$renda_media,
      Beneficio_Social = if (input$beneficio_social == "Outros") input$beneficio_social_outros else input$beneficio_social,
      Valor_Beneficio = input$valor_beneficio,
      Valor_Renda_Propria = input$valor_renda_propria,
      Valor_Renda_Pensao = input$valor_renda_pensao,
      Documento_Enviado = nome_documento,
      Membros_Familia = paste(apply(familia$lista, 1, function(row) {
        paste(row["Nome"], "-", row["Idade"], "anos -", row["Parentesco"], "-", row["Sexo"], "-", row["FrequentaEscola"], "-", row["Escolaridade"], "-", row["ResideCom"])
      }), collapse = " | ")
    )
    
    nome_arquivo <- paste0("formulario_SEMMU_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv")
    write.csv(dados, nome_arquivo, row.names = FALSE)
    
    updateTabsetPanel(session, "formulario_tabs", selected = "Finalizado")
  })
  observe({
    arquivos <- list.files(pattern = "^formulario_SEMMU_.*\\.csv$")
    if (length(arquivos) > 0) {
      dados <- do.call(rbind, lapply(arquivos, read.csv, stringsAsFactors = FALSE))
      output$tabela_cadastros <- DT::renderDataTable({
        datatable(dados, options = list(pageLength = 10), rownames = FALSE)
      })
      
      output$baixar_csv <- downloadHandler(
        filename = function() { "cadastros_SEMMU.csv" },
        content = function(file) {
          write.csv(dados, file, row.names = FALSE)
        }
      )
    }
  })
  
  output$baixar_documento_ui <- renderUI({
    arquivos <- list.files("documentos", full.names = TRUE)
    if (length(arquivos) == 0) return(NULL)
    selectInput("doc_selecionado", "📎 Selecionar Documento para Download:",
                choices = basename(arquivos))
  })
  
  output$baixar_documento <- downloadHandler(
    filename = function() { input$doc_selecionado },
    content = function(file) {
      file.copy(file.path("documentos", input$doc_selecionado), file)
    }
  )
}

shinyApp(ui = ui, server = server)
