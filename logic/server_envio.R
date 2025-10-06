server_envio <- function(input, output, session, tela_atual, dados_familia) {
  observeEvent(input$confirmar_envio, {
    shinyjs::removeClass(selector = ".erro")
    erros <- c()
    
    req(tempo_inicio())
    tempo_total <- difftime(Sys.time(), tempo_inicio(), units = "mins")
    
    # 🔍 Validação mínima
    campos_obrigatorios <- list(nome = "Nome Completo", cpf = "CPF")
    for (campo in names(campos_obrigatorios)) {
      if (is.null(input[[campo]]) || input[[campo]] == "") {
        shinyjs::addClass(campo, "erro")
        erros <- c(erros, campos_obrigatorios[[campo]])
      }
    }
    
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios ausentes",
        paste("Preencha os seguintes campos antes de enviar:", paste(erros, collapse = ", ")),
        easyClose = TRUE,
        footer = modalButton("Fechar")
      ))
      return()
    }
    
    # 🔄 Tratamento de campos condicionais
    profissional <- switch(input$rede,
                           "CRM (Centro de Referência da Mulher)" = input$profissional_crm,
                           "Casa de Mainha" = input$profissional_mainha,
                           "Casa Abrigo" = input$profissional_abrigo,
                           "SEMMU Até Você" = input$profissional_movel,
                           NULL
    )
    
    polo <- if (input$rede == "SEMMU Até Você") {
      if (input$polo_visitado == "Outros") input$polo_outros else input$polo_visitado
    } else NA
    
    safe <- function(x) if (is.null(x) || length(x) == 0) NA else x
    
    dados <- data.frame(
      data_hora_sistema     = format(Sys.time(), "%Y-%m-%d %H:%M:%S"),
      tempo_preenchimento   = round(as.numeric(tempo_total), 2),
      data_hora_informada   = safe(input$data_manual),
      unidade               = safe(input$rede),
      profissional          = login_status$nome,
      polo_visitado         = safe(polo),
      nome_social           = safe(input$nome_social),
      nome_completo         = safe(input$nome),
      cpf                   = safe(input$cpf),
      telefone              = safe(input$telefone),
      data_nascimento       = safe(input$data_nascimento),
      naturalidade          = safe(if (input$naturalidade == "Outros") input$naturalidade_outros else input$naturalidade),
      uf                    = safe(if (input$uf == "Outros") input$uf_outros else input$uf),
      quantos_filhos        = safe(input$quantos_filhos),
      gestante              = safe(input$gestante),
      raca_cor              = safe(input$raca_cor),
      escolaridade          = safe(input$escolaridade),
      atividade_laboral     = safe(if (input$atividade_laboral == "Outros") input$atividade_outros else input$atividade_laboral),
      estado_civil          = safe(input$estado_civil),
      deficiencia           = safe(if (input$deficiencia == "Outros") input$deficiencia_outros else input$deficiencia),
      orientacao_sexual     = safe(if (input$orientacao_sexual == "Outros") input$orientacao_outros else input$orientacao_sexual),
      identidade_genero     = safe(if (input$identidade_genero == "Outros") input$identidade_outros else input$identidade_genero),
      municipio_residencia  = safe(if (input$municipio_residencia == "Outros") input$municipio_outros else input$municipio_residencia),
      bairro                = safe(input$bairro),
      logradouro            = safe(input$logradouro),
      numero                = safe(input$numero),
      quadra                = safe(input$quadra),
      lote                  = safe(input$lote),
      complemento           = safe(input$complemento),
      zona_residencia       = safe(input$zona),
      condicao_moradia      = safe(input$condicao_moradia),
      ubs_referencia        = safe(input$ubs_referencia),
      renda_media           = safe(input$renda_media),
      beneficio_social      = safe(input$beneficio_social),
      valor_beneficio       = safe(input$valor_beneficio),
      valor_renda_propria   = safe(input$valor_renda_propria),
      valor_renda_pensao    = safe(input$valor_renda_pensao),
      stringsAsFactors      = FALSE
    )
    
    # 👨‍👩‍👧‍👦 Membros da família com CPF vinculado
    membros <- dados_familia$tabela
    if (!"cpf_principal" %in% names(membros)) {
      membros$cpf_principal <- input$cpf
    }
    
    # 💾 Salvamento no banco de dados
    conn <- conectar_bd()
    tryCatch({
      DBI::dbWriteTable(conn, "cadastro_completo", dados, append = TRUE, row.names = FALSE)
      if (nrow(membros) > 0) {
        DBI::dbWriteTable(conn, "composicao_familiar", membros, append = TRUE, row.names = FALSE)
      }
      cat("✅ Cadastro salvo: CPF =", input$cpf, " | Membros:", nrow(membros), "\n")
    }, error = function(e) {
      cat("❌ Erro ao salvar dados:", conditionMessage(e), "\n")
      showModal(modalDialog(
        title = "❌ Erro ao salvar",
        paste("Ocorreu um erro ao tentar salvar os dados:", conditionMessage(e)),
        easyClose = TRUE,
        footer = modalButton("Fechar")
      ))
      return()
    })
    DBI::dbDisconnect(conn)
    
    # ✅ Feedback visual
    showModal(modalDialog(
      title = "✅ Cadastro enviado com sucesso",
      "Os dados foram registrados no banco de dados. Obrigado por preencher o formulário!",
      easyClose = TRUE,
      footer = NULL
    ))
    
    tela_atual("painel")
  })
}