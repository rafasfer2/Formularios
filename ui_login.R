login_ui <- fluidPage(
  useShinyjs(),
  theme = theme_global,
  header_includes,
  
  # Script para Enter funcionar corretamente
  tags$script(HTML(
    "document.addEventListener('keydown', function(event) {
      if (event.key === 'Enter') {
        setTimeout(function() {
          var btn = document.getElementById('entrar');
          if (btn) btn.click();
        }, 100);
      }
    });"
  )),
  
  # Container principal com cabeçalho e conteúdo
  div(
    style = "display: flex; flex-direction: column; min-height: 100vh;",
    
    # Cabeçalho institucional
    cabecalho_global(),
    
    # Área central que cresce e centraliza o cartão
    div(
      style = "flex-grow: 1; display: flex; align-items: center; justify-content: center; background-color: #f8f9fa;",
      div(
        class = "login-card",
        style = "width: 400px; padding: 30px; background-color: white; border-radius: 8px; box-shadow: 0 0 10px rgba(0,0,0,0.1);",
        
        # Logo preto e título
        div(
          style = "text-align: center; margin-bottom: 20px;",
          img(src = "img/logo_semmu_preto.png", width = "120px"),
          h4("Acesso ao SIAM", style = "margin-top: 10px;")
        ),
        
        # Campos de login
        textInput("usuario", labelObrigatorio("Usuário"), width = "100%"),
        passwordInput("senha", labelObrigatorio("Senha"), width = "100%"),
        
        # Botão de login
        actionButton("entrar", "Entrar", class = "btn btn-primary", style = "width: 100%; margin-top: 15px;"),
        
        # Links de suporte
        div(
          style = "text-align: center; margin-top: 15px;",
          tags$a(href = "#", "Primeiro acesso", style = "margin-right: 15px; font-size: 13px;"),
          tags$a(href = "#", "Esqueceu a senha?", style = "font-size: 13px;")
        ),
        
        # Mensagem de erro
        div(id = "erro_login", style = "color: red; margin-top: 10px; display: none;",
            "Usuário ou senha inválidos.")
      )
    ),
    
    # Rodapé institucional
    rodape_global()
  )
)