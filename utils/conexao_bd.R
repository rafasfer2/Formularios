conectar_bd <- function() {
  DBI::dbConnect(
    RPostgres::Postgres(),
    dbname   = "postgres",
    host     = "aws-1-sa-east-1.pooler.supabase.com",
    port     = 6543,
    user     = "postgres.dnakyeffnvqcosrjumoa",
    password = "Rafasfer2@2260",
    sslmode  = "require"
  )
}