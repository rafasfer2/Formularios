inicializar_bd <- function(caminho_sql = "database/setup.sql") {
  cat("🔗 Conectando ao banco...\n")
  
  conn <- tryCatch(
    conectar_bd(),
    error = function(e) stop("❌ Falha ao conectar ao banco: ", e$message)
  )
  
  # 📄 Executa script SQL de estrutura, se existir
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
          cat("⚠️ Erro ao executar bloco SQL:\n")
          cat("   Bloco:", substr(bloco_limpo, 1, 50), "...\n")
          cat("   Mensagem:", e$message, "\n")
        })
      }
    }
  } else {
    cat("❌ Script SQL não encontrado em:", caminho_sql, "\n")
  }
  
  # 📊 Lista tabelas disponíveis no banco
  tabelas <- tryCatch(
    DBI::dbListTables(conn),
    error = function(e) {
      cat("⚠️ Erro ao listar tabelas:", e$message, "\n")
      return(NULL)
    }
  )
  
  if (!is.null(tabelas)) {
    cat("📊 Tabelas disponíveis no banco:\n")
    print(tabelas)
  } else {
    cat("⚠️ Nenhuma tabela encontrada ou erro na conexão.\n")
  }
  
  DBI::dbDisconnect(conn)
  cat("🔒 Conexão encerrada.\n")
}