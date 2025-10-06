inicializar_bd <- function(caminho_sql = "database/setup.sql") {
  cat("🔗 Conectando ao Supabase...\n")
  conn <- conectar_bd()
  
  # Executa script SQL remoto
  if (file.exists(caminho_sql)) {
    cat("📄 Executando script de estrutura:", caminho_sql, "\n")
    sql <- paste(readLines(caminho_sql, warn = FALSE), collapse = "\n")
    blocos <- strsplit(sql, ";")[[1]]
    
    for (bloco in blocos) {
      bloco_limpo <- trimws(bloco)
      if (nzchar(bloco_limpo)) {
        tryCatch({
          DBI::dbExecute(conn, bloco_limpo)
          cat("✅ Executado:", substr(bloco_limpo, 1, 50), "...\n")
        }, error = function(e) {
          cat("⚠️ Erro ao executar bloco SQL:", substr(bloco_limpo, 1, 50), "...\n")
        })
      }
    }
  } else {
    cat("❌ Script SQL não encontrado em:", caminho_sql, "\n")
  }
  
  # Lista tabelas disponíveis
  tabelas <- DBI::dbListTables(conn)
  cat("📊 Tabelas disponíveis no Supabase:\n")
  print(tabelas)
  
  DBI::dbDisconnect(conn)
  cat("🔒 Conexão encerrada.\n")
}