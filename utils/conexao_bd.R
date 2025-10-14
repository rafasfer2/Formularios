conectar_bd <- function() {
  tryCatch({
    con <- DBI::dbConnect(
      RPostgres::Postgres(),
      host = "aws-1-sa-east-1.pooler.supabase.com",
      port = 5432,
      dbname = "postgres",
      user = "postgres.dnakyeffnvqcosrjumoa",
      password = "Rafasfer2@2260",
      sslmode = "require"
    )
    message("✅ Conexão com Supabase estabelecida com sucesso.")
    return(con)
  }, error = function(e) {
    stop("❌ Erro ao conectar ao Supabase: ", e$message)
  })
}