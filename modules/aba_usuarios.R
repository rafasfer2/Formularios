aba_usuarios <- tabPanel("Usuários",
                         fluidRow(
                           column(6,
                                  h4("Cadastrar novo usuário"),
                                  textInput("novo_nome", "Nome completo"),
                                  textInput("novo_usuario", "Nome de usuário"),
                                  passwordInput("nova_senha", "Senha"),
                                  textInput("novo_email", "E-mail institucional"),
                                  textInput("novo_unidade", "Unidade"),
                                  textInput("novo_funcao", "Função"),
                                  selectInput("novo_perfil", "Perfil", choices = c("admin", "desenvolvedor", "atendente")),
                                  actionButton("cadastrar_usuario", "Cadastrar", class = "btn-primary")
                           ),
                           column(6,
                                  h4("Usuários cadastrados"),
                                  DT::dataTableOutput("tabela_usuarios")
                           )
                         )
)