inicializar_bd <- function(caminho_banco = "database/siam.sqlite", caminho_sql = "database/setup.sql") {
  cat("🔍 Verificando banco de dados...\n")
  
  # Cria pasta se não existir
  if (!dir.exists("database")) dir.create("database")
  
  # Remove banco antigo se estiver vazio ou com estrutura incorreta
  if (file.exists(caminho_banco)) {
    conn <- DBI::dbConnect(RSQLite::SQLite(), caminho_banco)
    tabelas <- DBI::dbListTables(conn)
    if ("usuarios" %in% tabelas) {
      estrutura <- DBI::dbGetQuery(conn, "PRAGMA table_info(usuarios)")
      if (!"cpf" %in% estrutura$name) {
        cat("⚠️ Estrutura da tabela 'usuarios' incorreta. Apagando banco...\n")
        DBI::dbDisconnect(conn)
        unlink(caminho_banco)
      } else {
        DBI::dbDisconnect(conn)
      }
    } else {
      DBI::dbDisconnect(conn)
    }
  }
  
  # Cria banco vazio se necessário
  if (!file.exists(caminho_banco)) {
    cat("📦 Criando novo arquivo SQLite...\n")
    file.create(caminho_banco)
  } else {
    cat("✅ Banco de dados localizado em:", caminho_banco, "\n")
  }
  
  # Conecta ao banco
  conn <- DBI::dbConnect(RSQLite::SQLite(), caminho_banco)
  
  # Executa script de estrutura
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
  
  # Verifica e insere usuários iniciais se necessário
  if ("usuarios" %in% DBI::dbListTables(conn)) {
    estrutura <- DBI::dbGetQuery(conn, "PRAGMA table_info(usuarios)")
    if ("cpf" %in% estrutura$name) {
      total <- DBI::dbGetQuery(conn, "SELECT COUNT(*) AS total FROM usuarios")$total
      if (total == 0) {
        cat("👥 Inserindo usuários iniciais...\n")
        DBI::dbExecute(conn, "
          INSERT INTO usuarios (cpf, usuario, senha_hash, nome, perfil, ativo)
          VALUES
            ('00000000191', 'profissional1', 'senha123', 'Arlene Ferreira', 'comum', 1),
            ('00000000272', 'profissional2', 'senha456', 'Juliana Cruz', 'comum', 1),
            ('00000000353', 'admin',        'admin123',  'Administrador', 'admin', 1)
        ")
        cat("✅ Usuários iniciais inseridos.\n")
      } else {
        cat("ℹ️ Usuários já existentes no banco. Nenhuma inserção realizada.\n")
      }
    } else {
      cat("⚠️ Estrutura da tabela 'usuarios' ainda incorreta. Verifique o setup.sql.\n")
    }
  }
  
  # Lista tabelas criadas
  tabelas <- DBI::dbListTables(conn)
  cat("📊 Tabelas disponíveis no banco:\n")
  print(tabelas)
  
  DBI::dbDisconnect(conn)
  cat("🔒 Conexão encerrada.\n")
}