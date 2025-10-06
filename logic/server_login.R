server_login <- function(input, output, session, tela_atual, login_status) {
  observeEvent(input$entrar, {
    # Garante que os campos foram preenchidos
    req(input$usuario, input$senha)
    
    # Filtra credenciais válidas
    credencial <- dplyr::filter(
      usuarios_validos,
      usuario == input$usuario,
      senha == input$senha
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