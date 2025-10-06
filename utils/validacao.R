# utils/validacao.R

# Função para limpar erros visuais
limparErros <- function(campos) {
  lapply(campos, function(campo) shinyjs::removeClass(campo, "erro"))
}

# Função para validar campos com condição
validarCampo <- function(condicao, campo_id, mensagem, erros) {
  if (!is.null(condicao) && isTRUE(condicao)) {
    shinyjs::addClass(campo_id, "erro")
    erros <- c(erros, mensagem)
  }
  return(erros)
}

# Função de navegação entre abas com validação
navegarFormulario <- function(input, session) {
  # Botões de avanço simples
  observeEvent(input$iniciar, {
    updateTabsetPanel(session, "abas", selected = "Rede de Atendimento SEMMU")
  })
  observeEvent(input$next1, {
    updateTabsetPanel(session, "abas", selected = "Dados Iniciais de Cadastro")
  })
  observeEvent(input$next2, {
    updateTabsetPanel(session, "abas", selected = "Notificação Individual")
  })
  observeEvent(input$next4, {
    updateTabsetPanel(session, "abas", selected = "Dados de Residência")
  })
  observeEvent(input$enviar, {
    updateTabsetPanel(session, "abas", selected = "Revisão Final")
  })
  
  # Botões de retorno simples
  observeEvent(input$prev2, {
    updateTabsetPanel(session, "abas", selected = "Rede de Atendimento SEMMU")
  })
  observeEvent(input$prev3, {
    updateTabsetPanel(session, "abas", selected = "Dados Iniciais de Cadastro")
  })
  observeEvent(input$prev4, {
    updateTabsetPanel(session, "abas", selected = "Notificação Individual")
  })
  observeEvent(input$prev5, {
    updateTabsetPanel(session, "abas", selected = "Dados Familiares")
  })
  observeEvent(input$prev6, {
    updateTabsetPanel(session, "abas", selected = "Dados de Residência")
  })
  observeEvent(input$prev_revisao, {
    updateTabsetPanel(session, "abas", selected = "Descrição da Fonte de Renda")
  })
  
  # Validação da aba "Notificação Individual"
  observeEvent(input$next3, {
    limparErros(c("data_nascimento", "naturalidade_outros", "uf_outros", "quantos_filhos"))
    erros <- c()
    
    data_valida <- tryCatch({
      as.Date(input$data_nascimento, format = "%d/%m/%Y")
    }, error = function(e) NA)
    
    idade <- if (!is.na(data_valida)) {
      as.numeric(difftime(Sys.Date(), data_valida, units = "days")) / 365.25
    } else {
      NA
    }
    
    erros <- validarCampo(is.na(data_valida), "data_nascimento", "Data de Nascimento inválida", erros)
    erros <- validarCampo(!is.na(data_valida) && data_valida > Sys.Date(), "data_nascimento", "Data de Nascimento no futuro", erros)
    erros <- validarCampo(!is.na(idade) && idade < 10, "data_nascimento", paste0("Idade mínima: 10 anos (atual: ", round(idade, 1), ")"), erros)
    erros <- validarCampo(input$naturalidade == "Outros" && input$naturalidade_outros == "", "naturalidade_outros", "Naturalidade (Outros)", erros)
    erros <- validarCampo(input$uf == "Outros" && input$uf_outros == "", "uf_outros", "UF (Outros)", erros)
    erros <- validarCampo(is.na(input$quantos_filhos) || input$quantos_filhos < 0, "quantos_filhos", "Número de filhos", erros)
    
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios ou inválidos",
        paste("Verifique os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE
      ))
    } else {
      updateTabsetPanel(session, "abas", selected = "Dados Familiares")
    }
  })
  
  # Validação da aba "Dados de Residência"
  observeEvent(input$next5, {
    limparErros(c("municipio_outros", "bairro", "logradouro", "numero", "zona", "condicao_moradia"))
    erros <- c()
    
    erros <- validarCampo(input$municipio_residencia == "Outros" && input$municipio_outros == "", "municipio_outros", "Município (Outros)", erros)
    erros <- validarCampo(input$bairro == "", "bairro", "Bairro", erros)
    erros <- validarCampo(input$logradouro == "", "logradouro", "Logradouro", erros)
    erros <- validarCampo(input$numero == "", "numero", "Número", erros)
    erros <- validarCampo(input$zona == "", "zona", "Zona de Residência", erros)
    erros <- validarCampo(input$condicao_moradia == "", "condicao_moradia", "Condição de Moradia", erros)
    
    if (length(erros) > 0) {
      showModal(modalDialog(
        title = "⚠️ Campos obrigatórios ou inválidos",
        paste("Verifique os seguintes campos:", paste(erros, collapse = ", ")),
        easyClose = TRUE
      ))
    } else {
      updateTabsetPanel(session, "abas", selected = "Descrição da Fonte de Renda")
    }
  })
}