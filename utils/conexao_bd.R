# utils/conexao_bd.R

conectar_bd <- function() {
  DBI::dbConnect(
    RSQLite::SQLite(),
    dbname = "database/siam.sqlite"
  )
}