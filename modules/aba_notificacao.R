aba_notificacao <- tabPanel(
  title = "Notificação Individual",
  value = "notificacao",
  
  div(
    class = "aba-conteudo",
    style = "padding: 30px;",
    
    h3("📄 Dados da Notificação Individual"),
    p("Preencha os dados sociodemográficos da assistida. Campos com * são obrigatórios."),
    
    fluidRow(
      column(
        4,
        textInput("nome_social", tags$strong("Nome Social")),
        textInput("data_nascimento", labelObrigatorio("Data de Nascimento"), placeholder = "21/09/1990"),
        
        selectInput(
          "naturalidade",
          labelObrigatorio("Naturalidade (Código IBGE)"),
          choices = c(
            "Parauapebas (1505536)", "Canaã dos Carajás (1502152)", "Curionópolis (1502772)",
            "Eldorado dos Carajás (1502954)", "Marabá (1504208)", "Belém (1501402)", "Outros"
          )
        ),
        conditionalPanel(
          condition = "input.naturalidade == 'Outros'",
          tagList(
            tags$label(tags$strong(tags$em("Informe a naturalidade")), style = "color: #0072B2;"),
            textInput("naturalidade_outros", label = NULL)
          )
        ),
        
        selectInput("uf", tags$strong("UF"), choices = c("PA", "MA", "TO", "Outros")),
        conditionalPanel(
          condition = "input.uf == 'Outros'",
          tagList(
            tags$label(tags$strong(tags$em("Informe a UF")), style = "color: #0072B2;"),
            textInput("uf_outros", label = NULL)
          )
        ),
        
        #numericInput("quantos_filhos", labelObrigatorio("Quantos filhos possui?"), value = NA, min = 0),
        
      ),
      column(
        4,
        radioButtons("gestante", labelObrigatorio("Gestante"), choices = c(
          "Não", "1° Trimestre (1 a 3 meses)", "2° Trimestre (3 a 6 meses)", "3° Trimestre (6 a 9 meses)", "Ignorado"
        )),
        
        radioButtons("raca_cor", labelObrigatorio("Raça/Cor"), choices = c(
          "Branca", "Preta", "Amarela", "Parda", "Indígena", "Ignorado"
        )),
        
        radioButtons("estado_civil", labelObrigatorio("Situação Conjugal / Estado Civil"), choices = c(
          "Solteira", "Casada", "Separada", "Viúva", "União estável"
        )),
        
      ),
      column(
        4,
        
        selectInput("escolaridade",
                    label = tags$strong(tags$em("Escolaridade")),
                    choices = c(
                      "Sem escolaridade", "Ensino Fundamental Incompleto", "Ensino Fundamental Completo",
                      "Ensino Médio Incompleto", "Ensino Médio Completo", "Superior Incompleto",
                      "Superior Completo", "Alfabetização para adultos", "Educação Especial",
                      "Técnico/Cursos Livres", "Não se aplica", "Ignorado"
                    )
        ),
        
        selectInput("atividade_laboral",
                    label = tags$strong(tags$em("Atividade Laboral")),
                    choices = c(
                      "Cuidados do Lar não remunerado", "Autônoma Formal (MEI)", "Autônoma Informal", "Trabalho Formal (CLT)",
                      "Desempregada", "Estudante", "Pensão/Aposentadoria", "Servidora Pública", "Outros"
                    )
        ),
        conditionalPanel(
          condition = "input.atividade_laboral == 'Outros'",
          tagList(
            tags$label(tags$strong(tags$em("Informe a atividade laboral")), style = "color: #0072B2;"),
            textInput("atividade_outros", label = NULL)
          )
        ),
        
        selectInput("deficiencia",
                    label = tags$strong(tags$em("Deficiência / Transtorno")),
                    choices = c(
                      "Não possui", "Auditiva", "Visual", "Intelectual", "Física", "Psicossocial",
                      "Transtorno Mental", "Transtorno de Comportamento", "Múltipla", "Outros"
                    )
        ),
        conditionalPanel(
          condition = "input.deficiencia == 'Outros'",
          tagList(
            tags$label(tags$strong(tags$em("Informe a deficiência ou transtorno")), style = "color: #0072B2;"),
            textInput("deficiencia_outros", label = NULL)
          )
        ),
        
        selectInput("orientacao_sexual",
                    label = tags$strong(tags$em("Orientação Sexual")),
                    choices = c("Heterossexual", "Homossexual", "Bissexual", "Outros")
        ),
        conditionalPanel(
          condition = "input.orientacao_sexual == 'Outros'",
          tagList(
            tags$label(tags$strong(tags$em("Informe a orientação sexual")), style = "color: #0072B2;"),
            textInput("orientacao_outros", label = NULL)
          )
        ),
        
        selectInput("identidade_genero",
                    label = tags$strong(tags$em("Identidade de Gênero")),
                    choices = c("Mulher cisgênero", "Mulher transgênero", "Travesti", "Não binária", "Prefere não informar", "Outros")
        ),
        conditionalPanel(
          condition = "input.identidade_genero == 'Outros'",
          tagList(
            tags$label(tags$strong(tags$em("Informe a identidade de gênero")), style = "color: #0072B2;"),
            textInput("identidade_outros", label = NULL)
          )
        )
      ),
      
      br(),
      fluidRow(
        column(6, actionButton("prev3", "⬅️ Voltar", class = "btn btn-secondary")),
        column(6, div(style = "text-align:right;", actionButton("next3", "Avançar ➡️", class = "btn btn-primary")))
      )
    )
  )
)