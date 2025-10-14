# 🔖 Rótulo com asterisco vermelho para campos obrigatórios
labelObrigatorio <- function(texto) {
  tagList(
    tags$label(
      tags$span(strong(texto)),
      tags$span("*", style = "color:red; margin-left:5px;")
    )
  )
}

# 🆔 Gera um ID único para cada cadastro
gerarID <- function() {
  paste0("SIAM-", format(Sys.time(), "%Y%m%d%H%M%S"))
}

# 💾 Salva dados em CSV (acrescenta se já existir)
salvarDados <- function(dados, caminho = "dados/cadastros.csv") {
  if (!file.exists(caminho)) {
    write.csv(dados, caminho, row.names = FALSE)
  } else {
    dados_existentes <- read.csv(caminho, stringsAsFactors = FALSE)
    dados_novos <- rbind(dados_existentes, dados)
    write.csv(dados_novos, caminho, row.names = FALSE)
  }
}

# 🔄 Limpa campos de texto após envio
limparFormulario <- function(session, campos) {
  lapply(campos, function(campo) updateTextInput(session, campo, value = ""))
}