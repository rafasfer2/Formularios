ui <- fluidPage(
  useShinyjs(),                  # Ativa recursos JS como esconder/mostrar elementos
  theme = theme_global,         # Tema institucional carregado via layout_global.R
  header_includes,              # CSS e JS personalizados (máscaras, responsividade)
  
  # 🔄 Renderização condicional da interface principal
  uiOutput("tela_principal")    # Exibe login_ui, painel_ui ou ui_formulario dinamicamente
)