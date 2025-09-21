
library(shiny)
library(shinythemes)
library(shinyjs)

# Função auxiliar para rótulo com asterisco vermelho
labelObrigatorio <- function(texto) {
  tagList(
    tags$label(
      tags$span(strong(texto)),
      tags$span("*", style = "color:red; margin-left:5px;")
    )
  )
}

ui <- fluidPage(
  theme = shinytheme("flatly"),
  useShinyjs(),
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
    "))
  ),
  
  titlePanel(tags$strong("Formulário de Cadastro Inicial SEMMU")),
  div(
    class = "main-container",
    tabsetPanel(
      id = "abas",
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
          div(class = "rodape-inicio",
              HTML(
                "
              📍 Secretaria da Mulher de Parauapebas (SEMMU)<br>
              Localizada na R. Rio Dourado – Beira Rio, Parauapebas – PA, 68515-000
             "
              )
          )
        )
      ),
      tabPanel(
        "Rede de Atendimento SEMMU",
        radioButtons("rede", "Selecione a unidade de atendimento:", choices = c("CRM (Centro de Referência da Mulher)", "Casa de Mainha", "Casa Abrigo", "SEMMU Até Você")),
        
        conditionalPanel(
          condition = "input.rede == 'CRM (Centro de Referência da Mulher)'",
          selectInput("profissional_crm", "Profissional Responsável:",choices = c("Selecione", "Arlene Ferreira da Cruz Piovezan", "Juliana Pereira Cruz Menezes", "Elane Oliveira Corrêa"))),
        conditionalPanel(
          condition = "input.rede == 'Casa de Mainha'",
          selectInput("profissional_mainha", "Profissional Responsável:", choices = c("Selecione", "Daiane Almino Ribeiro", "⁠Elizabeth Rodrigues de Bessa", "Fabiane Lima de Souza","Keylla Alves da Silva"))),
        conditionalPanel(
          condition = "input.rede == 'Casa Abrigo'",
          selectInput("profissional_abrigo", "Profissional Responsável:", choices = c("Selecione", "Alba Maria Rodrigues", "⁠Lucinei Aparecida Santos da Luz","⁠Eva Silva de Lima","Natália de Deus")) ),
        conditionalPanel(
          condition = "input.rede == 'SEMMU Até Você'",
          tagList(
            selectInput("profissional_movel", "Profissional Responsável:",choices = c("Selecione", "Elisangela Moreira", "Eleusa","Josélia Viana","Sandra Araújo","Keylla Alves da Silva")),
            selectInput("polo_visitado", "Polo Visitado:",choices = c("Selecione", "Polo 01 - Cedere 1", "Polo 02 - Palmares 2", "Polo 03 - Valentim Serra", "Polo 04 - Paulo Fonteles", "Polo 05 - Vila Carimã", "Polo 06 - Vila Brasil", "Polo 07 - Vila Alto Bonito", "Polo 08 - Vila Sansão", "Outros")),
            conditionalPanel(
              condition = "input.polo_visitado == 'Outros'",
              textInput("polo_outros", "Informe o nome do polo visitado")
            )
          )
        ),
        actionButton("next1", "Próximo", class = "btn-primary")
      ),
      tabPanel(
        "Dados Iniciais de Cadastro",
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
        selectInput("demanda", NULL, choices = c("Espontânea", "Encaminhada pela Rede Intersetorial", "Encaminhamento Interno da Rede SEMMU")),
        
        # Subseções dinâmicas
        conditionalPanel(
          condition = "input.demanda == 'Encaminhada pela Rede Intersetorial'",
          tags$hr(),
          tags$label(strong("Rede Intersetorial")),
          selectInput("rede_intersetorial", NULL,choices = c("PARAPAZ", "CREAS", "CRAS", "UBS", "HGP", "UBS", "UPA", "Conselho Tutelar", "DEAM", "DEACA", "Ministério Público","SEHAB", "SEMAS", "SEMSI", "SEMED", "Outros")),
          tags$label(strong("Observações de Localidade")),
          textInput("obs_localidade", NULL, placeholder = "Ex: Bairro distante, zona rural, etc.")
        ),
        conditionalPanel(
          condition = "input.demanda == 'Encaminhamento Interno da Rede SEMMU'",
          tags$hr(),
          tags$label(strong("Rede SEMMU")),
          selectInput("rede_semmu", NULL, choices = c("CRM", "Casa de Mainha", "Casa Abrigo", "SEMMU Até Você", "SEMMU Sede", "Outros"))),
        
        actionButton("prev2", "Voltar", class = "btn-secondary"),
        actionButton("next2", "Próximo", class = "btn-primary")
      ),
      tabPanel(
        "Notificação Individual",
        textInput("nome_social", "Nome Social"),
        
        textInput("data_nascimento", NULL, placeholder = "21/09/1990"),
        
        selectInput("naturalidade", "Naturalidade (Código IBGE)", choices = c("Parauapebas (1505536)", "Canaã dos Carajás (1502152)", "Curionópolis (1502772)", "Eldorado dos Carajás (1502954)", "Marabá (1504208)", "Belém (1501402)", "Outros")),
        conditionalPanel(
          condition = "input.naturalidade == 'Outros'",
          textInput("naturalidade_outros", "Informe a naturalidade")
        ),
        
        selectInput("uf", "UF", choices = c("PA", "MA", "TO", "Outros")),
        conditionalPanel(
          condition = "input.uf == 'Outros'",
          textInput("uf_outros", "Informe a UF")
        ),
        
        numericInput("quantos_filhos", "Quantos filhos possui?", value = NA, min = 0),
        
        selectInput("gestante", "Gestante", choices = c("Não", "1° Trimestre (1 a 3 meses)", "2° Trimestre (3 a 6 meses)","3° Trimestre (6 a 9 meses)", "Ignorado")),
        
        selectInput("raca_cor", "Raça/Cor", choices = c("Branca", "Preta", "Amarela", "Parda", "Indígena", "Ignorado")),
        
        selectInput("escolaridade", "Escolaridade",
                    choices = c("Sem escolaridade",
                                "Ensino Fundamental Incompleto",
                                "Ensino Fundamental Completo",
                                "Ensino Médio Incompleto",
                                "Ensino Médio Completo",
                                "Superior Incompleto",
                                "Superior Completo",
                                "Alfabetização para adultos",
                                "Educação Especial",
                                "Técnico/Cursos Livres",
                                "Não se aplica",
                                "Ignorado")),
        
        selectInput("atividade_laboral", "Atividade Laboral", choices = c("Cuidados do Lar não remunerado", "Autônoma Formal (MEI)", "Autônoma Informal", "Trabalho Formal (CLT)", "Desempregada", "Estudante", "Pensão/Aposentadoria", "Servidora Pública", "Outros")),
        conditionalPanel(
          condition = "input.atividade_laboral == 'Outros'",
          textInput("atividade_outros", "Informe a atividade laboral")
        ),
        selectInput("estado_civil", "Situação Conjugal / Estado Civil", choices = c("Solteira", "Casada", "Separada", "Viúva", "União estável")),
        selectInput("deficiencia", "Deficiência / Transtorno", choices = c("Auditiva", "Visual", "Intelectual", "Física", "Psicossocial", "Transtorno Mental", "Transtorno de Comportamento","Múltipla", "Não possui", "Outros")),
        conditionalPanel(
          condition = "input.deficiencia == 'Outros'",
          textInput("deficiencia_outros", "Informe a deficiência ou transtorno")
        ),
        selectInput("orientacao_sexual", "Orientação Sexual", choices = c("Heterossexual", "Homossexual", "Bissexual", "Outros")),
        selectInput("identidade_genero", "Identidade de Gênero", choices = c("Mulher cisgênero", "Mulher transgênero", "Travesti", "Não binária", "Prefere não informar", "Outros")),
        
        actionButton("prev5", "Voltar", class = "btn-secondary"),
        actionButton("next5", "Próximo", class = "btn-primary")
      ),
      
      tabPanel(
        "Dados de Residência",
        selectInput("municipio_residencia", "Município de Residência (Código IBGE)", choices = c("Parauapebas (1505536)", "Canaã dos Carajás (1502152)", "Curionópolis (1502772)", "Eldorado dos Carajás (1502954)", "Marabá (1504208)", "Belém (1501402)", "Outros")),
        conditionalPanel(
          condition = "input.municipio_residencia == 'Outros'",
          textInput("municipio_outros", "Informe o município de residência")
        ),
        
        textInput("bairro", "Bairro"),
        textInput("logradouro", "Logradouro (Rua, Avenida, ...)"),
        textInput("numero", "Número"),
        textInput("quadra", "Quadra"),
        textInput("lote", "Lote"),
        textInput("complemento", "Complemento (apto., casa, ...)"),
        
        selectInput("zona", "Zona de residência", choices = c("", "Urbana", "Rural", "Periurbana", "Indígena", "Quilombola")),
        
        selectInput("condicao_moradia", "Condição de Moradia", choices = c("Casa própria", "Alugada", "Cedida", "Ocupação", "Abrigo", "Situação de rua", "Outros")),
        conditionalPanel(
          condition = "input.condicao_moradia == 'Outros'",
          textInput("condicao_moradia_outros", "Informe a condição de moradia")
        ),
        
        textInput("ubs_referencia", "UBS de Referência"),
        
        actionButton("prev6", "Voltar", class = "btn-secondary"),
        actionButton("next6", "Próximo", class = "btn-primary")
      ),
      tabPanel(
        "Descrição da Fonte de Renda",
        selectInput("renda_media", "Renda Média Mensal",  choices = c("Sem renda", "Até 1/4 do salário mínimo", "De 1/4 a 1/2 salário mínimo", "De 1/2 a 1 salário mínimo", "De 1 a 2 salários mínimos",  "De 2 a 3 Salários Mínimos", "De 3 a 5 Salários Mínimos", "Acima de 5 salários mínimos", "Não informado")),
        
        selectInput("beneficio_social", "Benefício Social", choices = c("Nenhum", "Bolsa Família", "BPC (Benefício de Prestação Continuada)", "Auxílio Brasil", "Auxílio Emergencial", "Auxílio Doença", "Outros")),
        conditionalPanel(
          condition = "input.beneficio_social == 'Outros'",
          textInput("beneficio_social_outros", "Informe o Benefício Social")
        ),
        numericInput("valor_beneficio", "Valor do Benefício Social (R$)", value = NA, min = 0),
        numericInput("valor_renda_propria", "Valor de Renda Própria (R$)", value = NA, min = 0),
        numericInput("valor_renda_pensao", "Valor de Renda Pensão (R$)", value = NA, min = 0),
        
        actionButton("prev7", "Voltar", class = "btn-secondary"),
        actionButton("enviar", "Enviar", class = "btn-success"),
        verbatimTextOutput("resposta")
      ),
      tabPanel(
        "Revisão Final",
        h3("📋 Revisão dos Dados Preenchidos"),
        uiOutput("resumo_dados"),
        br(),
        actionButton("prev_revisao", "Voltar", class = "btn-secondary"),
        actionButton("confirmar_envio", "Confirmar e Enviar", class = "btn-success")
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
  # Aplica máscaras nos campos ao carregar
  observe({ session$sendCustomMessage("applyMasks", list()) })
  # Navegação inicial
  observeEvent(input$iniciar, { updateTabsetPanel(session, "abas", selected = "Rede de Atendimento SEMMU") })
  # Navegação entre abas
  observeEvent(input$next1, { updateTabsetPanel(session, "abas", selected = "Dados Iniciais de Cadastro") })
  
  observeEvent(input$prev2, { updateTabsetPanel(session, "abas", selected = "Início") })
  
  observeEvent(input$next2, { updateTabsetPanel(session, "abas", selected = "Notificação Individual") })
  
  observeEvent(input$prev5, { updateTabsetPanel(session, "abas", selected = "Dados Iniciais de Cadastro") })
  
  observeEvent(input$next5, {
    shinyjs::removeClass("nome_social", "erro")
    shinyjs::removeClass("data_nascimento", "erro")
    shinyjs::removeClass("naturalidade_outros", "erro")
    shinyjs::removeClass("uf_outros", "erro")
    shinyjs::removeClass("quantos_filhos", "erro")
    
    erros <- c()
    
    # Nome Social
    if (input$nome_social == "") {
      shinyjs::addClass("nome_social", "erro")
      erros <- c(erros, "Nome Social")
    }
    
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
      updateTabsetPanel(session, "abas", selected = "Dados de Residência")
    }
  })
  
  observeEvent(input$prev6, {
    updateTabsetPanel(session, "abas", selected = "Notificação Individual")
  })
  
  observeEvent(input$next6, {
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
      updateTabsetPanel(session, "abas", selected = "Descrição da fonte de renda")
    }
  })
  
  observeEvent(input$prev7, {
    updateTabsetPanel(session, "abas", selected = "Dados de Residência")
  })
  
  observeEvent(input$enviar, {
    updateTabsetPanel(session, "abas", selected = "Revisão Final")
  })
  
  observeEvent(input$prev_revisao, {
    updateTabsetPanel(session, "abas", selected = "Descrição da fonte de renda")
  })
  
  output$resumo_dados <- renderUI({
    tagList(
      h4("🧭 Unidade de Atendimento"),
      verbatimTextOutput("resumo_unidade"),
      h4("👤 Dados Pessoais"),
      verbatimTextOutput("resumo_pessoais"),
      h4("🏠 Dados de Residência"),
      verbatimTextOutput("resumo_residencia"),
      h4("💰 Informações de Renda"),
      verbatimTextOutput("resumo_renda")
    )
  })
  
  output$resumo_unidade <- renderText({
    profissional <- switch(input$rede,
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
    paste("Unidade:", input$rede,
          "\nProfissional:", profissional,
          if (!is.na(polo)) paste("\nPolo Visitado:", polo) else "")
  })
  
  output$resumo_pessoais <- renderText({
    paste("Nome Social:", input$nome_social,
          "\nData de Nascimento:", input$data_nascimento,
          "\nRaça/Cor:", input$raca_cor,
          "\nEscolaridade:", input$escolaridade,
          "\nAtividade Laboral:", input$atividade_laboral,
          "\nEstado Civil:", input$estado_civil,
          "\nDeficiência:", input$deficiencia,
          "\nOrientação Sexual:", input$orientacao_sexual,
          "\nIdentidade de Gênero:", input$identidade_genero)
  })
  
  output$resumo_residencia <- renderText({
    municipio <- if (input$municipio_residencia == "Outros") input$municipio_outros else input$municipio_residencia
    paste("Município:", municipio,
          "\nBairro:", input$bairro,
          "\nLogradouro:", input$logradouro,
          "\nNúmero:", input$numero,
          "\nQuadra:", input$quadra,
          "\nLote:", input$lote,
          "\nComplemento:", input$complemento,
          "\nZona:", input$zona,
          "\nCondição de Moradia:", input$condicao_moradia,
          "\nUBS de Referência:", input$ubs_referencia)
  })
  
  output$resumo_renda <- renderText({
    paste("Renda Média:", input$renda_media,
          "\nBenefício Social:", input$beneficio_social,
          "\nValor do Benefício (R$):", input$valor_beneficio,
          "\nRenda Própria (R$):", input$valor_renda_propria,
          "\nRenda Pensão (R$):", input$valor_renda_pensao)
  })
  observeEvent(input$confirmar_envio, {
    profissional <- switch(input$rede,
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
    
    # Salvamento em CSV
    write.table(dados, file = "cadastros_semmu.csv", sep = ";", row.names = FALSE,
                col.names = !file.exists("cadastros_semmu.csv"), append = TRUE)
    
    showModal(modalDialog(
      title = "✅ Cadastro enviado com sucesso!",
      "Os dados foram registrados e salvos com sucesso.",
      easyClose = TRUE,
      footer = modalButton("Fechar")
    ))
    
    updateTabsetPanel(session, "abas", selected = "Início")
  })
}

shinyApp(ui = ui, server = server)
