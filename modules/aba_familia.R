aba_familia <- tabPanel(
  title = "Dados Familiares",
  value = "familia",
  
  div(
    class = "aba-conteudo",
    style = "padding: 30px;",
    
    h3("👥 Cadastro de Membros da Família"),
    p("Preencha os dados de cada membro da família e clique em 'Adicionar Membro' para incluir na lista. O CPF da mulher cadastrada será vinculado automaticamente."),
    
    # Formulário de entrada dos dados familiares
    fluidRow(
      column(
        6,
        textInput("nome_familiar", labelObrigatorio("Nome"), placeholder = "Ex: Maria Silva"),
        radioButtons("sexo_familiar", labelObrigatorio("Sexo"), choices = c("Masculino", "Feminino")),
        radioButtons("parentesco", labelObrigatorio("Parentesco"), choices = c(
          "Filho(a)", "Cônjuge", "Irmão(ã)", "Avô(ó)", "Outro"
        )),
        conditionalPanel(
          condition = "input.parentesco == 'Outro'",
          tagList(
            tags$label(tags$strong(tags$em("Informe o parentesco")), style = "color: #0072B2;"),
            textInput("parentesco_outros", label = NULL)
          )
        )
      ),
      column(
        6,
        numericInput("idade_familiar", labelObrigatorio("Idade"), value = NA, min = 0),
        selectInput(
          "escolaridade_familiar",
          labelObrigatorio("Escolaridade"),
          choices = c(
            "Sem escolaridade", "Ensino Fundamental Incompleto", "Ensino Fundamental Completo",
            "Ensino Médio Incompleto", "Ensino Médio Completo", "Superior Incompleto",
            "Superior Completo", "Alfabetização para adultos", "Educação Especial",
            "Técnico/Cursos Livres", "Não se aplica", "Ignorado"
          )
        ),
        radioButtons("frequenta_escola", labelObrigatorio("Frequenta Escola?"), choices = c("Sim", "Não")),
        radioButtons("reside_com", labelObrigatorio("Reside com a assistida?"), choices = c("Sim", "Não"))
      )
    ),
    
    # Botão para adicionar membro à tabela
    fluidRow(
      column(12, br(), actionButton("adicionar_membro", "➕ Adicionar Membro", class = "btn btn-success"))
    ),
    
    tags$hr(),
    
    # Tabela de membros cadastrados
    h4("👨‍👩‍👧‍👦 Membros da Família Cadastrados"),
    DT::dataTableOutput("tabela_familia"),
    
    tags$hr(),
    
    # Navegação entre abas
    fluidRow(
      column(6, actionButton("prev4", "⬅️ Voltar", class = "btn btn-secondary")),
      column(6, div(style = "text-align:right;", actionButton("next4", "Avançar ➡️", class = "btn btn-primary")))
    )
  )
)