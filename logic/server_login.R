server_login <- function(input, output, session, tela_atual, login_status) {
  observeEvent(input$botao_login, {
    usuario_digitado <- input$usuario
    senha_digitada <- input$senha
    
    # Verifica se o usuário existe
    usuario_encontrado <- usuarios_validos %>%
      filter(usuario == usuario_digitado)
    
    if (nrow(usuario_encontrado) == 1) {
      senha_hash <- digest::digest(senha_digitada, algo = "sha256")
      
      if (senha_hash == usuario_encontrado$senha) {
        # Autenticação bem-sucedida
        login_status$autenticado <- TRUE
        login_status$nome <- usuario_encontrado$nome
        login_status$perfil <- usuario_encontrado$perfil
        
        showModal(modalDialog(
          title = "Login realizado com sucesso!",
          paste("Bem-vindo(a),", usuario_encontrado$nome),
          easyClose = TRUE,
          footer = NULL
        ))
        
        tela_atual("painel")
      } else {
        # Senha incorreta
        showModal(modalDialog(
          title = "Erro de autenticação",
          "Senha incorreta. Tente novamente.",
          easyClose = TRUE,
          footer = NULL
        ))
      }
    } else {
      # Usuário não encontrado
      showModal(modalDialog(
        title = "Usuário não encontrado",
        "Verifique o nome de usuário digitado.",
        easyClose = TRUE,
        footer = NULL
      ))
    }
  })
}