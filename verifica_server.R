arquivo <- "server.R"
linhas <- readLines(arquivo, warn = FALSE)

for (i in seq_along(linhas)) {
  tryCatch({
    parse(text = linhas[i])
  }, error = function(e) {
    cat("❌ Erro na linha", i, ":", linhas[i], "\n")
    cat("→", conditionMessage(e), "\n\n")
  })
}