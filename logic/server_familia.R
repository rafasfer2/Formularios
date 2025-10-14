# server_familia.R

# Inicializa o objeto reativo para armazenar os membros da família
familia <- reactiveValues(lista = data.frame(
  nome = character(),
  parentesco = character(),
  sexo = character(),
  idade = integer(),
  frequenta_escola = character(),
  escolaridade = character(),
  reside_com = character(),
  stringsAsFactors = FALSE
))

# Evento para adicionar um novo membro à lista
observeEvent(input$adicionar_membro, {
  novo <- data.frame(
    nome = input$nome_familiar,
    parentesco = input$parentesco,
    sexo = input$sexo_familiar,
    idade = input$idade_familiar,
    frequenta_escola = input$frequenta_escola,
    escolaridade = input$escolaridade_familiar,
    reside_com = input$reside_com,
    stringsAsFactors = FALSE
  )
  
  familia$lista <- rbind(familia$lista, novo)
  
  # Limpa os campos após adicionar
  updateTextInput(session, "nome_familiar", value = "")
  updateSelectInput(session, "parentesco", selected = "")
  updateSelectInput(session, "sexo_familiar", selected = "")
  updateNumericInput(session, "idade_familiar", value = NA)
  updateSelectInput(session, "frequenta_escola", selected = "")
  updateSelectInput(session, "escolaridade_familiar", selected = "")
  updateSelectInput(session, "reside_com", selected = "")
})

# Renderiza a tabela com os membros adicionados
output$tabela_familia <- DT::renderDataTable({
  df <- familia$lista
  if (nrow(df) == 0) return(NULL)
  
  # Adiciona botões de ação (ainda não funcionais)
  df$editar <- sprintf(
    '<button class="btn btn-warning btn-sm editar" data-linha="%s">✏️</button>',
    seq_len(nrow(df))
  )
  df$remover <- sprintf(
    '<button class="btn btn-danger btn-sm remover" data-linha="%s">🗑️</button>',
    seq_len(nrow(df))
  )
  
  DT::datatable(
    df,
    escape = FALSE,
    selection = "none",
    rownames = FALSE,
    options = list(dom = 't', paging = FALSE)
  )
})