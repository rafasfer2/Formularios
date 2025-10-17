server_login <- function(input, output, session, tela_atual, login_status, usuario_logado) {
  observeEvent(input$entrar, {
    usuario_digitado <- input$usuario
    senha_digitada <- input$senha
    
    con <- conectar_bd()
    
    query <- "SELECT nome, email_institucional, unidade, funcao, senha_hash, usuario FROM usuarios WHERE usuario = $1 AND ativo = 1"
    usuario_encontrado <- DBI::dbGetQuery(con, query, params = list(usuario_digitado))
    
    DBI::dbDisconnect(con)
    
    if (nrow(usuario_encontrado) == 1) {
      senha_hash <- digest::digest(senha_digitada, algo = "sha256")
      
      if (senha_hash == usuario_encontrado$senha_hash) {
        login_status$autenticado <- TRUE
        login_status$nome <- usuario_encontrado$nome
        login_status$email <- usuario_encontrado$email_institucional
        login_status$unidade <- usuario_encontrado$unidade
        login_status$funcao <- usuario_encontrado$funcao
        login_status$perfil <- NULL
        
        # Armazena o objeto completo do usuário para uso posterior
        login_status$dados_usuario <- usuario_encontrado
        
        # Atualiza o usuário logado reativo
        usuario_logado(usuario_encontrado$usuario)
        
        tela_atual("painel")
      } else {
        showModal(modalDialog(
          title = "Erro de autenticação",
          "Senha incorreta. Tente novamente.",
          easyClose = TRUE,
          footer = NULL
        ))
      }
    } else {
      showModal(modalDialog(
        title = "Usuário não encontrado",
        "Verifique o nome de usuário digitado.",
        easyClose = TRUE,
        footer = NULL
      ))
    }
  })
}