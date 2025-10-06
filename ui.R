source("global.R")

ui <- fluidPage(
  useShinyjs(),
  theme = theme_global,
  header_includes,
  
  # 🔄 Renderização condicional da interface principal
  uiOutput("tela_principal")  # Aqui será renderizado login_ui, painel_ui ou ui_formulario
)