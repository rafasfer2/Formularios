library(shiny)
library(shinyjs)
library(bslib)
library(DT)
library(shinythemes)

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
  useShinyjs(),
  theme = bs_theme(version = 5, bootswatch = "flatly"),
  #######################################################################
  ###########        Início - 🔷 Cabeçalho e Estilos Globais ############
  tags$head(
    tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.16/jquery.mask.min.js"), 
    tags$script(
      HTML(
        " Shiny.addCustomMessageHandler('applyMasks', function(message) { 
        $('#cpf').mask('000.000.000-00'); 
        $('#telefone').mask('(00) 00000-0000'); 
        $('#rg').mask('00.000.000-0'); 
        $('#cep').mask('00000-000'); 
        $('#data_manual').mask('00/00/0000 00:00'); 
        $('#data_nascimento').mask('00/00/0000'); }); 
        ")),
    
    tags$style(HTML("
    :root {
      --cor-principal: #5c2a7a;
      --cor-secundaria: #d63384;
      --cor-destaque: #ffc107;
      --cor-clara: #f8f9fa;
      --cor-escura: #2c3e50;
      --cor-sucesso: #4CAF50;
      --cor-erro: #f44336;
      --fonte-principal: 'Segoe UI', sans-serif;
    }

    body {
      font-family: var(--fonte-principal);
      background-color: var(--cor-clara);
      margin: 0;
      padding: 0;
    }

    .cabecalho-global {
      background-color: var(--cor-principal);
      color: white;
      padding: 10px 20px;
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 20px;
      box-shadow: 0 2px 4px rgba(0,0,0,0.1);
    }

    .cabecalho-global img {
      height: 100px;
    }

    .cabecalho-global h3 {
      margin: 0;
      font-size: 24px;
    }

    .cabecalho-global p {
      margin: 0;
      font-size: 14px;
    }

    .rodape-global {
      background-color: var(--cor-clara);
      color: #000;
      text-align: center;
      padding: 15px;
      font-size: 14px;
      border-top: 1px solid #ccc;
    }

    .btn-primary {
      background-color: var(--cor-principal);
      border-color: var(--cor-principal);
    }

    .btn-primary:hover {
      background-color: var(--cor-secundaria);
      border-color: var(--cor-secundaria);
    }

    .form-control:focus {
      border-color: var(--cor-principal);
      box-shadow: 0 0 0 0.2rem rgba(92,42,122,0.25);
    }

  /* Aba padrão */
  .nav-tabs > li > a {
    background-color: var(--cor-clara);
    color: var(--cor-principal);
    font-weight: bold;
    font-size: 18px;
    padding: 12px 20px;
    border-radius: 8px 8px 0 0;
    border: 1px solid transparent;
    margin-right: 6px;
    position: relative;
    transition: background-color 0.3s ease, color 0.3s ease;
  }

  .nav-tabs > li > a {
    background-color: var(--cor-clara);
    color: var(--cor-principal);
    font-weight: bold;
    font-size: 18px;
    padding: 12px 20px;
    border-radius: 8px 8px 0 0;
    border: 1px solid transparent;
    margin-right: 6px;
    position: relative;
    transition: background-color 0.3s ease, color 0.3s ease;
  }

  .nav-tabs > li.active > a,
  .nav-tabs > li.active > a:focus,
  .nav-tabs > li.active > a:hover {
    background-color: var(--cor-secundaria) !important;
    color: #ffffff !important;
    border: 1px solid var(--cor-secundaria) !important;
    box-shadow: 0 4px 6px rgba(0,0,0,0.1);
  }
  .nav-tabs > li.active > a::after {
    content: '';
    position: absolute;
    bottom: -1px;
    left: 0;
    width: 100%;
    height: 4px;
    background-color: var(--cor-destaque);
    border-radius: 0 0 4px 4px;
    animation: slideIn 0.4s ease forwards;
  }

  @keyframes slideIn {
    from { width: 0; }
    to { width: 100%; }
  }

  .aba-icone {
    font-size: 14px;
    margin-right: 6px;
    vertical-align: middle;
  }
  
    .nav-tabs > li.concluido > a {
    background-color: #e8f5e9 !important;  /* verde claro */
    color: #2e7d32 !important;
    border: 1px solid #c8e6c9 !important;
  }

  .nav-tabs > li.pendente > a {
    background-color: #ffebee !important;  /* vermelho claro */
    color: #c62828 !important;
    border: 1px solid #ffcdd2 !important;
  }


    .form-check-input:checked + .form-check-label {
      background-color: var(--cor-principal);
      color: white;
      font-weight: bold;
      padding: 6px 12px;
      border-radius: 5px;
      display: block;
      margin-bottom: 5px;
    }

    .form-check-label {
      display: block;
      padding: 6px 12px;
      margin-bottom: 5px;
      cursor: pointer;
      border-radius: 5px;
      transition: background-color 0.3s;
    }

    .form-check-label:hover {
      background-color: #e6e6e6;
    }

    .status-card {
      display: flex;
      align-items: center;
      background-color: #f0f0f0;
      border-left: 5px solid #ccc;
      padding: 10px 15px;
      margin-bottom: 10px;
      border-radius: 4px;
      font-weight: bold;
      box-shadow: 0 1px 3px rgba(0,0,0,0.1);
    }

    .status-card.concluido {
      border-left-color: var(--cor-sucesso);
      background-color: #e8f5e9;
      color: #2e7d32;
    }

    .status-card.pendente {
      border-left-color: var(--cor-erro);
      background-color: #ffebee;
      color: #c62828;
    }

    .status-icon {
      font-size: 14px;
      margin-right: 2px;
    }

    @media (max-width: 768px) {
      .cabecalho-global {
        flex-direction: column;
        text-align: center;
      }

      .cabecalho-global img {
        margin-bottom: 10px;
      }
    }
  "))
  ),
  ###########        Final - 🔷 Cabeçalho e Estilos Globais  ############
  #######################################################################
  ###########       Início - Cabeçalho global com logo       ############
  tags$div(
    style = "display: flex; flex-direction: column; min-height: 100vh;",
    
    # Cabeçalho global com logo
    div(
      class = "cabecalho-global",
      div(img(src = "SEMMU-BRANCO.png", class = "logo-semmu")),
      div(
        h3(tags$strong("Formulário de Cadastro Inicial"), style = "margin: 0;"),
        p("SIAM - Sistema Integrado de Atendimento à Mulher", style = "margin: 0; font-size: 14px;"),
        style = "text-align: right;"
      )
    ),
    ###########        Final - Cabeçalho global com logo       ############
    #######################################################################
    div(
      class = "main-container",
      style = "flex: 1; padding-bottom: 80px;",
      tabsetPanel(
        id = "abas",
        # Aba de capa sempre visível
        tabPanel(
          title = "Início",
          value = "inicio",
          div(
            class = "capa",
            h3(tags$strong("Bem-vindo ao Formulário de Cadastro Inicial")),
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
              tags$li(tags$em(tags$strong("Versão 2.1 de 04/09/2025:"), " Upload do Documento inserido.")),
              tags$li(tags$em(tags$strong("Versão 2.0 de 21/07/2025:"), " Padronização conforme SINAN.")),
              tags$li(tags$em(tags$strong("Versão 1.0 de 04/06/2025:"), " Primeira versão funcional."))
            ),
            br(),
            div(style = "text-align:center;", actionButton("iniciar", "Preencher formulário", class = "btn-success btn-lg")),
            br(), br()
          )
        ),
        #######################################################################
        ###########     next0 Início - Rede de Atendimento SEMMU   ############
        tabPanel(
          title = "Rede de Atendimento SEMMU",
          value = "rede",
          conditionalPanel(
            condition = "input.iniciar > 0",
            div(
              radioButtons("rede", labelObrigatorio("Selecione a unidade de atendimento:"), choices = c("CRM (Centro de Referência da Mulher)", "Casa de Mainha", "Casa Abrigo", "SEMMU Até Você")),
              
              conditionalPanel(
                condition = "input.rede == 'CRM (Centro de Referência da Mulher)'",
                selectInput("profissional_crm", labelObrigatorio("Profissional Responsável:"), choices = c("Selecione", "Arlene Ferreira da Cruz Piovezan", "Juliana Pereira Cruz Menezes", "Elane Oliveira Corrêa"))
              ),
              
              conditionalPanel(
                condition = "input.rede == 'Casa de Mainha'",
                selectInput("profissional_mainha", labelObrigatorio("Profissional Responsável:"), choices = c("Selecione", "Daiane Almino Ribeiro", "⁠Elizabeth Rodrigues de Bessa", "Fabiane Lima de Souza", "Keylla Alves da Silva"))
              ),
              
              conditionalPanel(
                condition = "input.rede == 'Casa Abrigo'",
                selectInput("profissional_abrigo", labelObrigatorio("Profissional Responsável:"), choices = c("Selecione", "Alba Maria Rodrigues", "⁠Lucinei Aparecida Santos da Luz", "⁠Eva Silva de Lima", "Natália de Deus"))
              ),
              
              conditionalPanel(
                condition = "input.rede == 'SEMMU Até Você'",
                tagList(
                  selectInput("profissional_movel", labelObrigatorio("Profissional Responsável:"), choices = c("Selecione", "Elisangela Moreira", "Eleusa", "Josélia Viana", "Sandra Araújo", "Keylla Alves da Silva")),
                  selectInput("polo_visitado", labelObrigatorio("Polo Visitado:"), choices = c("Selecione", "Cedere 1", "Palmares 2", "Valentim Serra", "Paulo Fonteles", "Vila Carimã", "Vila Brasil", "Vila Alto Bonito", "Vila Sansão", "Outros")),
                  conditionalPanel(
                    condition = "input.polo_visitado == 'Outros'",
                    textInput("polo_outros", "Informe o nome do polo visitado")
                  )
                )
              ),
              
              actionButton("next1", "Próximo", class = "btn-primary")
            )
          )
        ),
        ###########     next0  Final - Rede de Atendimento SEMMU   ############
        #######################################################################
        ###########     next1 Início - Dados Iniciais de Cadastro  #############
        tabPanel(
          title = "Dados Iniciais de Cadastro",
          value = "cadastro",
          conditionalPanel(
            condition = "input.iniciar > 0",
            div(
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
                selectInput("rede_intersetorial", 
                            tags$label(strong("Rede Intersetorial")),
                            choices = c("PARAPAZ", "CREAS", "CRAS", "UBS", "HGP", "UBS", "UPA", "Conselho Tutelar", "DEAM", "DEACA", "Ministério Público","SEHAB", "SEMAS", "SEMSI", "SEMED", "Outros")),
                textInput("obs_localidade", tags$label(strong("Observações de Localidade")), placeholder = "Ex: Bairro distante, zona rural, etc.")
              ),
              conditionalPanel(
                condition = "input.demanda == 'Encaminhamento Interno da Rede SEMMU'",
                tags$hr(),
                selectInput("rede_semmu", 
                            tags$label(strong("Rede SEMMU")), 
                            choices = c("CRM", "Casa de Mainha", "Casa Abrigo", "SEMMU Até Você", "SEMMU Sede", "Outros"))),
              
              actionButton("prev2", "Voltar", class = "btn-secondary"),
              actionButton("next2", "Próximo", class = "btn-primary")
            )
          )
        ),
        ###########     prev2  Final - Dados Iniciais de Cadastro  ############
        #######################################################################
        ###########     next2 Início - Notificação Individual      ##############
        tabPanel(
          title = "Notificação Individual",
          value = "notificacao",
          conditionalPanel(
            condition = "input.iniciar > 0",
            div(
              textInput("nome_social", "Nome Social"),
              textInput("data_nascimento", "Data de Nascimento", placeholder = "21/09/1990"),
              selectInput(
                "naturalidade", 
                labelObrigatorio("Naturalidade (Código IBGE)"), 
                choices = c("Parauapebas (1505536)", "Canaã dos Carajás (1502152)", "Curionópolis (1502772)", "Eldorado dos Carajás (1502954)", "Marabá (1504208)", "Belém (1501402)", "Outros")),
              conditionalPanel(
                condition = "input.naturalidade == 'Outros'",
                textInput("naturalidade_outros", "Informe a naturalidade")
              ),
              selectInput("uf", "UF", choices = c("PA", "MA", "TO", "Outros")),
              conditionalPanel(
                condition = "input.uf == 'Outros'",
                textInput("uf_outros", "Informe a UF")
              ),
              numericInput("quantos_filhos", labelObrigatorio("Quantos filhos possui?"), value = NA, min = 0),
              selectInput("gestante", "Gestante", choices = c("Não", "1° Trimestre (1 a 3 meses)", "2° Trimestre (3 a 6 meses)","3° Trimestre (6 a 9 meses)", "Ignorado")),
              selectInput("raca_cor", "Raça/Cor", choices = c("Branca", "Preta", "Amarela", "Parda", "Indígena", "Ignorado")),
              selectInput(
                "escolaridade", "Escolaridade",
                choices = c(
                  "Sem escolaridade",
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
                  "Ignorado"
                )
              )
            ),
            selectInput(
              "atividade_laboral", 
              "Atividade Laboral", 
              choices = c(
                "Cuidados do Lar não remunerado", "Autônoma Formal (MEI)", "Autônoma Informal", "Trabalho Formal (CLT)", "Desempregada", "Estudante", "Pensão/Aposentadoria", "Servidora Pública", "Outros")),
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
            
            actionButton("prev3", "Voltar", class = "btn-secondary"),
            actionButton("next3", "Próximo", class = "btn-primary")
          )
        ),
        ###########     prev3  Final - Notificação Individual      ############
        #######################################################################
        ###########     next3 Início - Dados Familiares            ############
        tabPanel(
          title = "Dados Familiares", 
          value = "familia",
          conditionalPanel(
            condition = "input.iniciar > 0",
            div(
              fluidRow(
                column(4, textInput("nome_familiar", "Nome", placeholder = "Ex: Maria Silva")),
                column(4, radioButtons("parentesco", "Parentesco", choices = c("", "Filho(a)", "Cônjuge", "Irmão(ã)", "Avô(ó)", "Outro"))),
                column(4, radioButtons("sexo_familiar", "Sexo", choices = c("", "Masculino", "Feminino")))
              ),
              fluidRow(
                column(4, numericInput("idade_familiar", "Idade", value = NA, min = 0)),
                column(4, radioButtons("frequenta_escola", "Frequenta Escola?", choices = c("Sim", "Não"))),
                column(
                  4, 
                  selectInput(
                    "escolaridade_familiar", 
                    "Escolaridade", 
                    choices = c(
                      "Sem escolaridade",
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
                      "Ignorado"))
                )
              ),
              
              fluidRow(
                column(4, radioButtons("reside_com", "Reside com a assistida?", choices = c("Sim", "Não"))),
                column(8, br(), actionButton("adicionar_membro", "➕ Adicionar Membro", class = "btn-success"))
              ),
              
              tags$hr(),
              
              h4("👨‍👩‍👧‍👦 Membros da Família Cadastrados"),
              DT::dataTableOutput("tabela_familia"),
              
              tags$hr(),
              
              fluidRow(
                column(6, actionButton("prev4", "⬅️ Voltar", class = "btn-secondary")),
                column(6, div(style = "text-align:right;", actionButton("next4", "Avançar ➡️", class = "btn-primary")))
              )
            )
          )
        ),
        ###########     prev4 Final  - Dados Familiares            ############
        #######################################################################
        ###########     next4 Início - Dados de Residência        ############
        tabPanel(
          title = "Dados de Residência",
          value = "residencia",
          conditionalPanel(
            condition = "input.iniciar > 0",
            div(
              selectInput(
                "municipio_residencia", "Município de Residência (Código IBGE)", 
                choices = c(
                  "Parauapebas (1505536)", "Canaã dos Carajás (1502152)", "Curionópolis (1502772)", "Eldorado dos Carajás (1502954)", "Marabá (1504208)", "Belém (1501402)", "Outros")),
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
              actionButton("prev5", "Voltar", class = "btn-secondary"),
              actionButton("next5", "Próximo", class = "btn-primary")
            )
          )
        ),
        ###########     prev5 Final  - Dados de Residência         ############
        #######################################################################
        ###########     next5 Início - Descrição da Fonte de Renda ############
        tabPanel(
          title = "Descrição da Fonte de Renda",
          value = "renda",
          conditionalPanel(
            condition = "input.iniciar > 0",
            div(
              selectInput(
                "renda_media", "Renda Média Mensal",  
                choices = c(
                  "Sem renda", 
                  "Até 1/4 do salário mínimo", 
                  "De 1/4 a 1/2 salário mínimo", 
                  "De 1/2 a 1 salário mínimo", 
                  "De 1 a 2 salários mínimos",  
                  "De 2 a 3 Salários Mínimos", 
                  "De 3 a 5 Salários Mínimos", 
                  "Acima de 5 salários mínimos", 
                  "Não informado")
              ),
              selectInput(
                "beneficio_social", "Benefício Social", 
                choices = c("Nenhum", "Bolsa Família", "BPC (Benefício de Prestação Continuada)", "Auxílio Brasil", "Auxílio Emergencial", "Auxílio Doença", "Outros")),
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
            )
          )
        ),
        ###########     prev6  Final - Descrição da Fonte de Renda ############
        #######################################################################
        ###########     enviar Início - Revisão Final             ############
        tabPanel(
          title = "Revisão Final",
          value = "revisao",
          conditionalPanel(
            condition = "input.iniciar > 0",
            div(
              h3("📋 Revisão dos Dados Preenchidos"),
              uiOutput("resumo_dados"),
              br(),
              actionButton("prev_revisao", "Voltar", class = "btn-secondary"),
              actionButton("confirmar_envio", "Confirmar e Enviar", class = "btn-success")
            )
          )
        )
        ###########     prev_revisao Final - Revisão Final         ############
        #######################################################################
      ),
    ) 
  ),
  div(
    class = "rodape-global",
    style = "text-align: left;",
    HTML(
      "Secretaria da Mulher de Parauapebas (SEMMU)<br>
        Localizada na R. Rio Dourado – Beira Rio, Parauapebas – PA, 68515-000<br>
        Desenvolvido por Rafael Fernandes — Professor |
        Contato: <a href='mailto:rafasfer2@gmail.com'>rafasfer2@gmail.com</a> |
        GitHub: <a href='https://github.com/rafasfer2' target='_blank'>github.com/rafasfer2</a>"
    )
  )
  ###########         # fim da main-container                ############
  #######################################################################
)
#########################################
########### FIM DO CÓDIGO UI ############
########### FIM DO CÓDIGO UI ############
#########################################
server <- function(input, output, session) {
  
  limparErros <- function(campos) {
    lapply(campos, function(campo) shinyjs::removeClass(campo, "erro"))
  }   # Função auxiliar para limpar erros
  validarCampo <- function(condicao, id, mensagem, erros) {
    if (condicao) {
      shinyjs::addClass(id, "erro")
      erros <- c(erros, mensagem)
    }
    return(erros)
  } # Função auxiliar para validar campos
  
  observe({ session$sendCustomMessage("applyMasks", list()) }) # Aplica máscaras nos campos ao carregar
  ######################################################################
  ###########              Navegação entre abas             ############
  observeEvent(input$iniciar, { updateTabsetPanel(session, "abas", selected = "Rede de Atendimento SEMMU")  }) # Navegação inicial
  observeEvent(input$prev2, { updateTabsetPanel(session, "abas", selected = "Rede de Atendimento SEMMU") })
  observeEvent(input$prev3, { updateTabsetPanel(session, "abas", selected = "Dados Iniciais de Cadastro") })
  observeEvent(input$prev4, { updateTabsetPanel(session, "abas", selected = "Notificação Individual") })
  observeEvent(input$prev5, { updateTabsetPanel(session, "abas", selected = "Dados Familiares") })
  observeEvent(input$prev6, { updateTabsetPanel(session, "abas", selected = "Dados de Residência")})
  observeEvent(input$prev_revisao, { updateTabsetPanel(session, "abas", selected = "Descrição da Fonte de Renda")})
  
  observeEvent(input$next1, { updateTabsetPanel(session, "abas", selected = "Dados Iniciais de Cadastro") })
  observeEvent(input$next2, { updateTabsetPanel(session, "abas", selected = "Notificação Individual") })
  observeEvent(input$next3, {
    limparErros(c("nome_social", "data_nascimento", "naturalidade_outros", "uf_outros", "quantos_filhos"))
    erros <- c()
    
    # ⚠️ Nome Social NÃO é obrigatório — validação removida
    
    # Validação da Data de Nascimento
    data_valida <- tryCatch({
      as.Date(input$data_nascimento, format = "%d/%m/%Y")
    }, error = function(e) NA)
    
    idade <- if (!is.na(data_valida)) {
      as.numeric(difftime(Sys.Date(), data_valida, units = "days")) / 365.25
    } else {
      NA
    }
    
    erros <- validarCampo(is.na(data_valida), "data_nascimento", "Data de Nascimento inválida", erros)
    erros <- validarCampo(!is.na(data_valida) && data_valida > Sys.Date(), "data_nascimento", "Data de Nascimento no futuro", erros)
    erros <- validarCampo(!is.na(idade) && idade < 10, "data_nascimento", paste0("Idade mínima: 10 anos (atual: ", round(idade, 1), ")"), erros)
    
    erros <- validarCampo(input$naturalidade == "Outros" && input$naturalidade_outros == "", "naturalidade_outros", "Naturalidade (Outros)", erros)
    erros <- validarCampo(input$uf == "Outros" && input$uf_outros == "", "uf_outros", "UF (Outros)", erros)
    erros <- validarCampo(is.na(input$quantos_filhos) || input$quantos_filhos < 0, "quantos_filhos", "Número de filhos", erros)
    
    # Exibir modal ou avançar
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios ou inválidos",
        paste("Verifique os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE
      ))
    } else {
      updateTabsetPanel(session, "abas", selected = "familia")
    }
  })   #{ updateTabsetPanel(session, "abas", selected = "Dados Familiares") })
  observeEvent(input$next4, { updateTabsetPanel(session, "abas", selected = "Dados de Residência") })
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
      updateTabsetPanel(session, "abas", selected = "Descrição da fonte de renda")
    }
  })   #{ updateTabsetPanel(session, "abas", selected = "Descrição da Fonte de Renda") })
  observeEvent(input$enviar, {
    updateTabsetPanel(session, "abas", selected = "Revisão Final")
  })  #{ updateTabsetPanel(session, "abas", selected = "Revisão Final") })
  ###########              Navegação entre abas             ############
  ######################################################################
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
  
  familia <- reactiveValues(lista = data.frame(
    Nome = character(),
    Parentesco = character(),
    Sexo = character(),
    Idade = integer(),
    FrequentaEscola = character(),
    Escolaridade = character(),
    ResideCom = character(),
    stringsAsFactors = FALSE
  ))
  
  observeEvent(input$adicionar_membro, {
    novo <- data.frame(
      Nome = input$nome_familiar,
      Parentesco = input$parentesco,
      Sexo = input$sexo_familiar,
      Idade = input$idade_familiar,
      FrequentaEscola = input$frequenta_escola,
      Escolaridade = input$escolaridade_familiar,
      ResideCom = input$reside_com,
      stringsAsFactors = FALSE
    )
    
    familia$lista <- rbind(familia$lista, novo)
    
    # Limpar campos após adicionar
    updateTextInput(session, "nome_familiar", value = "")
    updateSelectInput(session, "parentesco", selected = "")
    updateSelectInput(session, "sexo_familiar", selected = "")
    updateNumericInput(session, "idade_familiar", value = NA)
    updateSelectInput(session, "frequenta_escola", selected = "")
    updateSelectInput(session, "escolaridade_familiar", selected = "")
    updateSelectInput(session, "reside_com", selected = "")
  })
  
  output$tabela_familia <- DT::renderDataTable({
    df <- familia$lista
    if (nrow(df) == 0) return(NULL)
    
    # Adiciona colunas de ação
    df$Editar <- sprintf(
      '<button class="btn btn-warning btn-sm editar" data-linha="%s">✏️</button>',
      seq_len(nrow(df))
    )
    df$Remover <- sprintf(
      '<button class="btn btn-danger btn-sm remover" data-linha="%s">🗑️</button>',
      seq_len(nrow(df))
    )
    
    DT::datatable(
      df,
      escape = FALSE,
      selection = "none",
      rownames = FALSE,
      options = list(dom = 't', paging = FALSE)
    )
  })
  
  observeEvent(input$alterar_membro, {
    linha <- input$tabela_familia_rows_selected
    if (is.null(linha)) {
      showModal(modalDialog("Selecione um membro para alterar.", easyClose = TRUE))
      return()
    }
    
    membro <- familia$lista[linha, ]
    
    showModal(modalDialog(
      title = "✏️ Alterar Membro da Família",
      textInput("editar_nome", "Nome", value = membro$Nome),
      selectInput("editar_parentesco", "Parentesco", choices = c("Filho", "Filha", "Cônjuge", "Outro"), selected = membro$Parentesco),
      selectInput("editar_sexo", "Sexo", choices = c("Masculino", "Feminino", "Outro"), selected = membro$Sexo),
      numericInput("editar_idade", "Idade", value = membro$Idade, min = 0),
      selectInput("editar_frequenta", "Frequenta Escola?", choices = c("Sim", "Não"), selected = membro$FrequentaEscola),
      selectInput("editar_escolaridade", "Escolaridade", choices = c("Fundamental", "Médio", "Superior", "Não informado"), selected = membro$Escolaridade),
      selectInput("editar_reside", "Reside com a assistida?", choices = c("Sim", "Não"), selected = membro$ResideCom),
      footer = tagList(
        modalButton("Cancelar"),
        actionButton("confirmar_edicao", "Salvar Alterações", class = "btn-success")
      )
    ))
  })
  
  observeEvent(input$confirmar_edicao, {
    linha <- input$tabela_familia_rows_selected
    familia$lista[linha, ] <- data.frame(
      Nome = input$editar_nome,
      Parentesco = input$editar_parentesco,
      Sexo = input$editar_sexo,
      Idade = input$editar_idade,
      FrequentaEscola = input$editar_frequenta,
      Escolaridade = input$editar_escolaridade,
      ResideCom = input$editar_reside,
      stringsAsFactors = FALSE
    )
    removeModal()
  })
  
  observeEvent(input$remover_membro, {
    linha <- input$tabela_familia_rows_selected
    if (is.null(linha)) {
      showModal(modalDialog("Selecione um membro para remover.", easyClose = TRUE))
      return()
    }
    
    showModal(modalDialog(
      title = "🗑️ Remover Membro",
      paste("Deseja remover o membro:", familia$lista[linha, "Nome"], "?"),
      footer = tagList(
        modalButton("Cancelar"),
        actionButton("confirmar_remocao", "Remover", class = "btn-danger")
      )
    ))
  })
  
  observeEvent(input$confirmar_remocao, {
    linha <- input$tabela_familia_rows_selected
    familia$lista <- familia$lista[-linha, ]
    removeModal()
  })
  
  observeEvent(input$editar_linha_familia, {
    linha <- input$editar_linha_familia
    membro <- familia$lista[linha, ]
    
    showModal(modalDialog(
      title = "✏️ Editar Membro da Família",
      textInput("editar_nome", "Nome", value = membro$Nome),
      selectInput("editar_parentesco", "Parentesco", choices = c("Filho", "Filha", "Cônjuge", "Outro"), selected = membro$Parentesco),
      selectInput("editar_sexo", "Sexo", choices = c("Masculino", "Feminino", "Outro"), selected = membro$Sexo),
      numericInput("editar_idade", "Idade", value = membro$Idade, min = 0),
      selectInput("editar_frequenta", "Frequenta Escola?", choices = c("Sim", "Não"), selected = membro$FrequentaEscola),
      selectInput("editar_escolaridade", "Escolaridade", choices = c("Fundamental", "Médio", "Superior", "Não informado"), selected = membro$Escolaridade),
      selectInput("editar_reside", "Reside com a assistida?", choices = c("Sim", "Não"), selected = membro$ResideCom),
      footer = tagList(
        modalButton("Cancelar"),
        actionButton("confirmar_edicao", "Salvar Alterações", class = "btn-success")
      )
    ))
    
    observeEvent(input$confirmar_edicao, {
      familia$lista[linha, ] <- data.frame(
        Nome = input$editar_nome,
        Parentesco = input$editar_parentesco,
        Sexo = input$editar_sexo,
        Idade = input$editar_idade,
        FrequentaEscola = input$editar_frequenta,
        Escolaridade = input$editar_escolaridade,
        ResideCom = input$editar_reside,
        stringsAsFactors = FALSE
      )
      removeModal()
    })
  })
  
  observeEvent(input$remover_linha_familia, {
    linha <- input$remover_linha_familia
    nome <- familia$lista[linha, "Nome"]
    
    showModal(modalDialog(
      title = "🗑️ Remover Membro",
      paste("Deseja remover o membro:", nome, "?"),
      footer = tagList(
        modalButton("Cancelar"),
        actionButton("confirmar_remocao", "Remover", class = "btn-danger")
      )
    ))
    
    observeEvent(input$confirmar_remocao, {
      familia$lista <- familia$lista[-linha, ]
      removeModal()
    })
  })
  
  # 1. ReactiveValues para controle de conclusão das abas
  abas_concluidas <- reactiveValues(
    cadastro = FALSE,
    rede = FALSE,
    notificacao = FALSE,
    familia = FALSE,
    residencia = FALSE,
    renda = FALSE,
    revisao = FALSE,
    finalizado = FALSE
  )
  # 2. Lista de campos obrigatórios (apenas para abas com campos fixos)
  campos_obrigatorios <- list(
    cadastro = c("campo_inicial_1", "campo_inicial_2"),
    residencia     = c("campo_residencia_1", "campo_residencia_2"),
    renda          = c("campo_renda_1", "campo_renda_2"),
    revisao        = c("campo_revisao_1", "campo_revisao_2"),
    finalizado     = c("campo_finalizado_1")
  )
  
  
  # 3. Função genérica para verificar campos fixos
  verificarCampos <- function(input, campos) {
    all(sapply(campos, function(id) {
      !is.null(input[[id]]) && trimws(input[[id]]) != ""
    }))
  }
  
  # 4. Verificação automática para abas com campos fixos
  observe({
    lapply(names(campos_obrigatorios), function(aba) {
      campos <- campos_obrigatorios[[aba]]
      abas_concluidas[[aba]] <- verificarCampos(input, campos)
    })
  })
  
  # 5. Verificação condicional para aba "Rede de Atendimento SEMMU"
  observe({
    abas_concluidas$rede <- switch(
      input$rede,
      "CRM (Centro de Referência da Mulher)" = !is.null(input$profissional_crm) && input$profissional_crm != "Selecione",
      "Casa de Mainha" = !is.null(input$profissional_mainha) && input$profissional_mainha != "Selecione",
      "Casa Abrigo" = !is.null(input$profissional_abrigo) && input$profissional_abrigo != "Selecione",
      "SEMMU Até Você" = !is.null(input$profissional_movel) && input$profissional_movel != "Selecione" &&
        !is.null(input$polo_visitado) && input$polo_visitado != "Selecione" &&
        (input$polo_visitado != "Outros" || (!is.null(input$polo_outros) && input$polo_outros != "")),
      FALSE
    )
  })
  
  # 6. Verificação condicional para aba "Notificação Individual"
  observe({
    campos_basicos <- !is.null(input$naturalidade) && input$naturalidade != "" &&
      !is.null(input$uf) && input$uf != "" &&
      !is.null(input$quantos_filhos) && !is.na(input$quantos_filhos)
    
    naturalidade_ok <- input$naturalidade != "Outros" || (!is.null(input$naturalidade_outros) && input$naturalidade_outros != "")
    uf_ok           <- input$uf != "Outros" || (!is.null(input$uf_outros) && input$uf_outros != "")
    atividade_ok    <- input$atividade_laboral != "Outros" || (!is.null(input$atividade_outros) && input$atividade_outros != "")
    deficiencia_ok  <- input$deficiencia != "Outros" || (!is.null(input$deficiencia_outros) && input$deficiencia_outros != "")
    
    abas_concluidas$notificacao <- campos_basicos && naturalidade_ok && uf_ok && atividade_ok && deficiencia_ok
  })
  
  # 7. Verificação condicional para aba "Dados Familiares"
  observe({
    abas_concluidas$familia <- !is.null(input$tabela_familia_rows_selected) && length(input$tabela_familia_rows_selected) > 0
  })
  
  output$painel_principal <- renderUI({
    if (is.null(input$iniciar) || input$iniciar == 0) {
      # Painel de capa
      tabsetPanel(
        id = "abas",
        tabPanel(
          title = "Início",
          value = "inicio",
          div(
            class = "capa",
            h3(tags$strong("Bem-vindo ao Formulário de Cadastro Inicial")),
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
              tags$li(tags$em(tags$strong("Versão 2.1 de 04/09/2025:"), " Upload do Documento inserido.")),
              tags$li(tags$em(tags$strong("Versão 2.0 de 21/07/2025:"), " Padronização conforme SINAN.")),
              tags$li(tags$em(tags$strong("Versão 1.0 de 04/06/2025:"), " Primeira versão funcional."))
            ),
            br(),
            div(style = "text-align:center;", actionButton("iniciar", "Preencher formulário", class = "btn-success btn-lg")),
            br(), br()
          )
        )
      )
    } else {
      # Painéis do formulário
      tabsetPanel(
        id = "abas",
        tabPanel("Rede de Atendimento SEMMU", ...),
        tabPanel("Notificação Individual", ...),
        tabPanel("Dados Familiares", ...),
        tabPanel("Dados de Residência", ...),
        tabPanel("Fonte de Renda", ...),
        tabPanel("Revisão Final", ...),
        tabPanel("Finalizado", ...)
      )
    }
  })
  
  
  # 8. Renderização das abas com ícones de conclusão
  output$abas_ui <- renderUI({
    fluidPage(
      div(
        class = "main-container",
        style = "flex: 1; padding-bottom: 80px;",
        fluidRow(
          column(
            10,
            tabsetPanel(
              id = "abas",
              tabPanel("Rede de Atendimento SEMMU", ...),
              tabPanel("Dados Iniciais de Cadastro", ...),
              tabPanel("Notificação Individual", ...),
              tabPanel("Dados Familiares", ...),
              tabPanel("Dados de Residência", ...),
              tabPanel("Descrição da Fonte de Renda", ...),
              tabPanel("Revisão Final", ...)
            )
          )
        )
      )
    )
  })
  
  absolutePanel(
    top = 100,
    right = 0,  # garante alinhamento total à direita
    width = 250,
    fixed = TRUE,
    draggable = FALSE,
    style = "
    background-color: #f9f9f9;
    border-left: 1px solid #ccc;
    padding: 15px;
    box-shadow: -2px 0 5px rgba(0,0,0,0.1);
    z-index: 1000;
  ",
    h4("🗂️ Progresso do Preenchimento"),
    uiOutput("painel_status")
  )
  
  output$painel_status <- renderUI({
    abas <- list(
      rede = "Rede de Atendimento SEMMU",
      cadastro = "Dados Iniciais de Cadastro",
      notificacao = "Notificação Individual",
      familia = "Dados Familiares",
      residencia = "Dados de Residência",
      renda = "Fonte de Renda",
      revisao = "Revisão Final",
    )
    
    # Exemplo de preenchimento fictício (substitua com lógica real)
    status_abas <- reactiveValues(
      rede = TRUE,
      cadastro = FALSE,
      notificacao = FALSE,
      familia = FALSE,
      residencia = FALSE,
      renda = FALSE,
      revisao = FALSE
    )
    
    # Geração da interface visual
    tagList(
      h4("📊 Status do Preenchimento"),
      tags$div(
        class = "painel-status",
        style = "display: flex; flex-wrap: wrap; gap: 10px;",
        lapply(names(abas), function(nome) {
          preenchido <- status_abas[[nome]]
          cor <- if (preenchido) "#28a745" else "#ffc107"
          icone <- if (preenchido) "✅" else "⏳"
          tags$div(
            style = paste0("border: 1px solid #ccc; padding: 10px; border-radius: 6px; background-color: ", cor, "; color: white; width: 220px;"),
            tags$strong(icone, " ", abas[[nome]])
          )
        })
      )
    )
  })
}

shinyApp(ui = ui, server = server)