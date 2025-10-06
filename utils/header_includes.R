# 🧠 Inclusões de cabeçalho: scripts e estilos
header_includes <- tags$head(
  # jQuery Mask Plugin
  tags$script(src = "https://cdnjs.cloudflare.com/ajax/libs/jquery.mask/1.14.16/jquery.mask.min.js"),
  
  # Script de máscaras personalizado
  tags$script(src = "js/mascaras.js"),
  
  # Gatilho para Enter nas abas
  tags$script(HTML("
    $(document).on('keydown', function(e) {
      if (e.key === 'Enter') {
        const abaAtual = $('li.active a[data-value]').attr('data-value');
        const botoes = {
          'inicio': 'next1',
          'cadastro': 'next2',
          'notificacao': 'next3',
          'familia': 'next4',
          'residencia': 'next5',
          'renda': 'enviar',
          'revisao': 'confirmar_envio'
        };
        const idBotao = botoes[abaAtual];
        if (idBotao) {
          $('#' + idBotao).click();
        }
      }
    });
  ")),
  
  # Gatilho para aplicar máscaras ao conectar
  tags$script(HTML("
    $(document).on('shiny:connected', function() {
      Shiny.setInputValue('applyMasks', true);
    });
  ")),
  
  # Estilos CSS organizados por tema
  tags$link(rel = "stylesheet", type = "text/css", href = "css/variables.css"),
  tags$link(rel = "stylesheet", type = "text/css", href = "css/layout.css"),
  tags$link(rel = "stylesheet", type = "text/css", href = "css/buttons.css"),
  tags$link(rel = "stylesheet", type = "text/css", href = "css/forms.css"),
  tags$link(rel = "stylesheet", type = "text/css", href = "css/tabs.css"),
  tags$link(rel = "stylesheet", type = "text/css", href = "css/cards.css"),
  tags$link(rel = "stylesheet", type = "text/css", href = "css/responsive.css")
)