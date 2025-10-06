server_dashboard <- function(input, output, session, tela_atual, login_status) {
  # 👤 Saudação personalizada com nome do profissional logado
  output$nome_usuario <- renderText({
    req(login_status$nome)
    paste("Olá,", login_status$nome)
  })
  
  # 🟢 Botão para iniciar o formulário
  observeEvent(input$iniciar_formulario, {
    tela_atual("formulario")
  })
}