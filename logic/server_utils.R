limparErros <- function(campos) {
  lapply(campos, function(campo) shinyjs::removeClass(campo, "erro"))
}

validarCampo <- function(condicao, id, mensagem, erros) {
  if (condicao) {
    shinyjs::addClass(id, "erro")
    erros <- c(erros, mensagem)
  }
  return(erros)
}

navegarFormulario <- function(input, session) {
  observeEvent(input$iniciar, { updateTabsetPanel(session, "abas", selected = "Rede de Atendimento SEMMU") })
  observeEvent(input$next1, { updateTabsetPanel(session, "abas", selected = "Dados Iniciais de Cadastro") })
  observeEvent(input$next2, { updateTabsetPanel(session, "abas", selected = "Notificação Individual") })
  observeEvent(input$next4, { updateTabsetPanel(session, "abas", selected = "Dados de Residência") })
  observeEvent(input$enviar, { updateTabsetPanel(session, "abas", selected = "Revisão Final") })
  
  observeEvent(input$prev2, { updateTabsetPanel(session, "abas", selected = "Rede de Atendimento SEMMU") })
  observeEvent(input$prev3, { updateTabsetPanel(session, "abas", selected = "Dados Iniciais de Cadastro") })
  observeEvent(input$prev4, { updateTabsetPanel(session, "abas", selected = "Notificação Individual") })
  observeEvent(input$prev5, { updateTabsetPanel(session, "abas", selected = "Dados Familiares") })
  observeEvent(input$prev6, { updateTabsetPanel(session, "abas", selected = "Dados de Residência") })
  observeEvent(input$prev_revisao, { updateTabsetPanel(session, "abas", selected = "Descrição da Fonte de Renda") })
}