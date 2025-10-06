# Lista de pacotes usados no SIAM
pacotes <- c(
  "shiny",
  "shinyjs",
  "bslib",
  "DT",
  "DBI",
  "RSQLite",
  "digest",
  "jsonlite",
  "lubridate",
  "stringr",
  "readr",
  "tidyverse"
)

# Instala apenas os que ainda não estão presentes
instalar <- pacotes[!pacotes %in% installed.packages()[, "Package"]]

if (length(instalar) > 0) {
  install.packages(instalar, repos = "https://cloud.r-project.org")
  message("✅ Pacotes instalados com sucesso: ", paste(instalar, collapse = ", "))
} else {
  message("🎉 Todos os pacotes já estavam instalados.")
}