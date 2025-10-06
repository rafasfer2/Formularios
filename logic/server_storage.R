# Função para salvar os dados do formulário
salvarDadosFormulario <- function(input, dados_familia) {
  # Cria pasta de saída se não existir
  dir.create("dados_submetidos", showWarnings = FALSE)
  
  # Gera nome de arquivo com data e hora
  nome_arquivo <- paste0("dados_submetidos/cadastro_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".csv")
  
  # Dados principais
  dados <- data.frame(
    DataCadastro = input$data_manual,
    Nome = input$nome,
    CPF = input$cpf,
    RG = input$rg,
    Telefone = input$telefone,
    Unidade = input$rede,
    Profissional = switch(input$rede,
                          "CRM (Centro de Referência da Mulher)" = input$profissional_crm,
                          "Casa de Mainha" = input$profissional_mainha,
                          "Casa Abrigo" = input$profissional_abrigo,
                          "SEMMU Até Você" = input$profissional_movel
    ),
    PoloVisitado = if (input$rede == "SEMMU Até Você") {
      if (input$polo_visitado == "Outros") input$polo_outros else input$polo_visitado
    } else {
      NA
    },
    Demanda = input$demanda,
    stringsAsFactors = FALSE
  )
  
  # Junta com dados familiares
  familia <- dados_familia()
  if (nrow(familia) > 0) {
    familia$CadastroID <- nome_arquivo
    dados <- rbind(dados, rep("", ncol(dados)))  # separador visual
    dados <- rbind(dados, familia)
  }
  
  # Salva como CSV
  write.csv(dados, nome_arquivo, row.names = FALSE)
  
  return(nome_arquivo)
}

# Função de envio final
logicaEnvio <- function(input, output, session, dados_familia) {
  observeEvent(input$confirmar_envio, {
    arquivo <- salvarDadosFormulario(input, dados_familia)
    showModal(modalDialog(
      title = "✅ Cadastro enviado com sucesso!",
      paste("Os dados foram salvos em:", arquivo),
      easyClose = TRUE
    ))
    output$resposta <- renderText(paste("Arquivo salvo:", arquivo))
  })
}