# Carregamento das abas do formulário
source("modules/aba_rede.R")             # 🌐 Rede de Atendimento
source("modules/aba_dados_iniciais.R")   # 📍 Dados Pessoais
source("modules/aba_notificacao.R")      # 📢 Notificação
source("modules/aba_familia.R")          # 👨‍👩‍👧‍👦 Família
source("modules/aba_residencia.R")       # 🏠 Residência
source("modules/aba_renda.R")            # 💰 Renda
source("modules/aba_revisao.R")          # 📋 Revisão Final

# Interface principal do formulário
ui_formulario <- fluidPage(
  useShinyjs(),
  theme = theme_global,
  header_includes,
  
  div(
    style = "display: flex; flex-direction: column; min-height: 100vh;",
    
    # 🟣 Cabeçalho institucional
    cabecalho_global(),
    
    # 📄 Conteúdo principal com abas
    div(
      class = "main-container",
      style = "flex: 1; padding-bottom: 80px;",
      tabsetPanel(
        id = "abas",
        aba_rede,
        aba_dados_iniciais,
        aba_notificacao,
        aba_familia,
        aba_residencia,
        aba_renda,
        aba_revisao  # ✅ Última aba: revisão final
      )
    ),
    
    # ⚫ Rodapé institucional
    rodape_global()
  )
)