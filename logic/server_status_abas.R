abas_concluidas <- reactiveValues(
  cadastro = FALSE,
  rede = FALSE,
  notificacao = FALSE,
  familia = FALSE,
  residencia = FALSE,
  renda = FALSE,
  revisao = FALSE,
  finalizado = FALSE
)

campos_obrigatorios <- list(
  cadastro     = c("campo_inicial_1", "campo_inicial_2"),
  residencia   = c("campo_residencia_1", "campo_residencia_2"),
  renda        = c("campo_renda_1", "campo_renda_2"),
  revisao      = c("campo_revisao_1", "campo_revisao_2"),
  finalizado   = c("campo_finalizado_1")
)

verificarCampos <- function(input, campos) {
  all(sapply(campos, function(id) {
    !is.null(input[[id]]) && trimws(input[[id]]) != ""
  }))
}

observe({
  lapply(names(campos_obrigatorios), function(aba) {
    campos <- campos_obrigatorios[[aba]]
    abas_concluidas[[aba]] <- verificarCampos(input, campos)
  })
})

observe({
  abas_concluidas$rede <- switch(
    input$rede,
    "CRM (Centro de Referência da Mulher)" = !is.null(input$profissional_crm) && input$profissional_crm != "Selecione",
    "Casa de Mainha" = !is.null(input$profissional_mainha) && input$profissional_mainha != "Selecione",
    "Casa Abrigo" = !is.null(input$profissional_abrigo) && input$profissional_abrigo != "Selecione",
    "SEMMU Até Você" = !is.null(input$profissional_movel) && input$profissional_movel != "Selecione" &&
      !is.null(input$polo_visitado) && input$polo_visitado != "Selecione" &&
      (input$polo_visitado != "Outros" || (!is.null(input$polo_outros) && input$polo_outros != "")),
    FALSE
  )
})

observe({
  campos_basicos <- !is.null(input$naturalidade) && input$naturalidade != "" &&
    !is.null(input$uf) && input$uf != "" &&
    !is.null(input$quantos_filhos) && !is.na(input$quantos_filhos)
  
  naturalidade_ok <- input$naturalidade != "Outros" || (!is.null(input$naturalidade_outros) && input$naturalidade_outros != "")
  uf_ok           <- input$uf != "Outros" || (!is.null(input$uf_outros) && input$uf_outros != "")
  atividade_ok    <- input$atividade_laboral != "Outros" || (!is.null(input$atividade_outros) && input$atividade_outros != "")
  deficiencia_ok  <- input$deficiencia != "Outros" || (!is.null(input$deficiencia_outros) && input$deficiencia_outros != "")
  
  abas_concluidas$notificacao <- campos_basicos && naturalidade_ok && uf_ok && atividade_ok && deficiencia_ok
})

observe({
  abas_concluidas$familia <- !is.null(input$tabela_familia_rows_selected) && length(input$tabela_familia_rows_selected) > 0
})