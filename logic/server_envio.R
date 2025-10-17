server_envio <- function(input, output, session, tempo_inicio, email_usuario) {
  observeEvent(input$enviar_formulario, {
    tryCatch({
      print("Botão enviar clicado")  # Debug
      
      # Tempo de preenchimento
      tempo_final <- Sys.time()
      tempo_preenchimento <- as.numeric(difftime(tempo_final, tempo_inicio(), units = "mins"))
      
      # Dados principais do formulário
      dados_forms <- reactiveValuesToList(input)
      dados_forms$data_hora_sistema <- tempo_final
      dados_forms$tempo_preenchimento <- tempo_preenchimento
      dados_forms$email_preenchedor <- email_usuario()
      
      # Validação básica
      if (is.null(dados_forms$cpf) || dados_forms$cpf == "") {
        showModal(modalDialog(
          title = "Erro",
          "O campo CPF é obrigatório.",
          easyClose = TRUE,
          footer = NULL
        ))
        return()
      }
      
      # Conexão com banco
      con <- conectar_bd()
      
      # Inserção no cadastro principal
      DBI::dbWriteTable(con, "cadastro_completo", as.data.frame(dados_forms), append = TRUE, row.names = FALSE)
      
      # Inserção dos membros da família (se houver)
      if (!is.null(input$tabela_familia)) {
        dados_familia <- input$tabela_familia
        dados_familia$cpf_principal <- dados_forms$cpf
        DBI::dbWriteTable(con, "composicao_familiar", dados_familia, append = TRUE, row.names = FALSE)
      }
      
      DBI::dbDisconnect(con)
      
      # Sincronização com Google Sheets (silenciosa)
      try({
        source("utils/sincronizar_cadastro.R")
        sincronizar_cadastro()
      }, silent = TRUE)
      
      try({
        source("utils/sincronizar_familia.R")
        sincronizar_familia()
      }, silent = TRUE)
      
      # Mensagem de sucesso com botão que fecha o modal e reinicia o formulário
      showModal(modalDialog(
        title = "Cadastro enviado com sucesso!",
        "Os dados foram salvos e sincronizados.",
        easyClose = FALSE,
        footer = tagList(
          modalButton("Fechar"),
          actionButton("fechar_modal", "OK")
        )
      ))
      
    }, error = function(e) {
      showModal(modalDialog(
        title = "Erro ao enviar",
        paste("Ocorreu um erro ao salvar os dados:", e$message),
        easyClose = TRUE,
        footer = modalButton("Fechar")
      ))
    })
  })
  
  # Evento para fechar modal e recarregar formulário (registrado uma vez)
  observeEvent(input$fechar_modal, {
    removeModal()
    session$reload()
  })
}