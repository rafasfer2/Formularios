familia <- reactiveValues(lista = data.frame(
  Nome = character(),
  Parentesco = character(),
  Sexo = character(),
  Idade = integer(),
  FrequentaEscola = character(),
  Escolaridade = character(),
  ResideCom = character(),
  stringsAsFactors = FALSE
))

observeEvent(input$adicionar_membro, {
  novo <- data.frame(
    Nome = input$nome_familiar,
    Parentesco = input$parentesco,
    Sexo = input$sexo_familiar,
    Idade = input$idade_familiar,
    FrequentaEscola = input$frequenta_escola,
    Escolaridade = input$escolaridade_familiar,
    ResideCom = input$reside_com,
    stringsAsFactors = FALSE
  )
  
  familia$lista <- rbind(familia$lista, novo)
  
  updateTextInput(session, "nome_familiar", value = "")
  updateSelectInput(session, "parentesco", selected = "")
  updateSelectInput(session, "sexo_familiar", selected = "")
  updateNumericInput(session, "idade_familiar", value = NA)
  updateSelectInput(session, "frequenta_escola", selected = "")
  updateSelectInput(session, "escolaridade_familiar", selected = "")
  updateSelectInput(session, "reside_com", selected = "")
})

output$tabela_familia <- DT::renderDataTable({
  df <- familia$lista
  if (nrow(df) == 0) return(NULL)
  
  df$Editar <- sprintf('<button class="btn btn-warning btn-sm editar" data-linha="%s">✏️</button>', seq_len(nrow(df)))
  df$Remover <- sprintf('<button class="btn btn-danger btn-sm remover" data-linha="%s">🗑️</button>', seq_len(nrow(df)))
  
  DT::datatable(df, escape = FALSE, selection = "none", rownames = FALSE,
                options = list(dom = 't', paging = FALSE))
})