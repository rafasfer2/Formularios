# 🎨 Tema visual global com personalização
theme_global <- bs_theme(
  version = 5,
  bootswatch = "flatly",
  primary = "#5c2a7a",
  font_scale = 1.1,
  base_font = font_google("Roboto")
)

# 🔷 Cabeçalho institucional reutilizável
cabecalho_global <- function() {
  div(
    class = "cabecalho-global",
    style = "display: flex; justify-content: space-between; align-items: center; padding: 20px; background-color: #5c2a7a; color: white;",
    
    div(img(src = "img/logo_semmu_branco.png", class = "logo-semmu", style = "height: 80px;")),
    
    div(
      h3(tags$strong("Formulário de Cadastro Inicial"), style = "margin: 0;"),
      p("SIAM - Sistema Integrado de Atendimento à Mulher", style = "margin: 0; font-size: 14px;"),
      style = "text-align: right;"
    )
  )
}

# 🔻 Rodapé institucional reutilizável
rodape_global <- function() {
  div(
    class = "rodape-global",
    style = "text-align: left; padding: 20px; background-color: #f8f9fa; font-size: 14px;",
    HTML(
      "Secretaria da Mulher de Parauapebas (SEMMU)<br>
      Localizada na R. Rio Dourado – Beira Rio, Parauapebas – PA, 68515-000<br>
      Desenvolvido por Rafael Fernandes — Professor |
      Contato: <a href='mailto:rafasfer2@gmail.com'>rafasfer2@gmail.com</a> |
      GitHub: <a href='https://github.com/rafasfer2' target='_blank'>github.com/rafasfer2</a>"
    )
  )
}