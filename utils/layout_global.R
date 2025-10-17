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
    style = "display: flex; justify-content: space-between; align-items: center; padding: 20px 20px 0 20px; background-color: #5c2a7a; color: white; margin-bottom: 0;",
    
    div(img(src = "img/logo_semmu_branco.png", class = "logo-semmu", style = "height: 80px; margin-top: -10px; margin-bottom: 10px;")),
    
    div(
      h3(tags$strong("Formulário de Cadastro Inicial"), style = "margin: 0;"),
      p("SIAM - Sistema Integrado de Atendimento à Mulher", style = "margin: 0; font-size: 14px;"),
      style = "text-align: right;"
    )
  )
}

# 🔷 Informações do usuário no cabeçalho
info_usuario_global <- function() {
  div(
    style = "padding: 0; margin: 0;",
    div(
      style = "display: flex; justify-content: space-between; align-items: flex-start; padding: 0 20px 10px 20px; background-color: #f0f4f8; border-bottom: 1px solid #ccc;",
      
      # Nome do usuário e unidade à esquerda com estilos e cores diferenciadas
      div(
        style = "display: flex; flex-direction: column; align-items: flex-start; gap: 2px; margin: 0;",
        span(
          HTML('<strong style="color: #28a745;">Usuária:</strong> '),
          span(style = "color: #5c2a7a; font-weight: 700;", textOutput("nome_usuario", inline = TRUE))
        ),
        div(
          style = "display: flex; align-items: center; gap: 4px;",
          HTML('<strong style="color: #28a745;">Coordenação:</strong>'),
          htmlOutput("unidade_usuario")
        )
      ),
      
      # Tempo de acesso e botão sair à direita
      div(
        style = "display: flex; flex-direction: column; align-items: flex-end; gap: 5px; color: #2c3e50; font-weight: 400; font-style: italic; font-size: 0.9em; margin: 0;",
        span(textOutput("tempo_acesso", inline = TRUE)),
        actionLink("logout", "Sair", style = "font-weight: bold; font-style: normal; color: #5c2a7a; cursor: pointer; font-size: 1.1em; margin: 0;")
      )
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