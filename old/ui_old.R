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