server_login <- function(input, output, session, tela_atual, login_status) {
  observeEvent(input$entrar, {
    req(input$usuario, input$senha)
    
    senha_digitada <- digest::digest(input$senha, algo = "sha256")
    
    credencial <- dplyr::filter(
      usuarios_validos,
      usuario == input$usuario,
      senha == senha_digitada
    )
    
    if (nrow(credencial) == 1) {
      login_status$autenticado <- TRUE
      login_status$nome <- credencial$nome
      login_status$perfil <- credencial$perfil
      tela_atual("painel")
      
      shinyjs::hide("erro_login")
      limparErros(c("usuario", "senha"))
    } else {
      shinyjs::show("erro_login")
      shinyjs::addClass("usuario", "erro")
      shinyjs::addClass("senha", "erro")
    }
  })
}