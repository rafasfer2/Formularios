server_resumo <- function(input, output, session, dados_familia) {
  
  # Função auxiliar para formatar valores monetários
  formatar_moeda <- function(valor) {
    if (is.null(valor) || valor == "") return("R$ 0,00")
    valor_num <- suppressWarnings(as.numeric(gsub("[^0-9]", "", valor)))
    if (is.na(valor_num)) return("R$ 0,00")
    paste0("R$ ", formatC(valor_num / 100, format = "f", digits = 2, big.mark = ".", decimal.mark = ","))
  }
  
  # Função auxiliar para valores seguros
  safe <- function(x) if (is.null(x) || x == "") "—" else x
  
  # Renderização do resumo completo
  output$resumo_dados <- renderUI({
    profissional <- switch(input$rede,
                           "CRM (Centro de Referência da Mulher)" = input$profissional_crm,
                           "Casa de Mainha" = input$profissional_mainha,
                           "Casa Abrigo" = input$profissional_abrigo,
                           "SEMMU Até Você" = input$profissional_movel,
                           NULL
    )
    
    polo <- if (input$rede == "SEMMU Até Você") {
      if (input$polo_visitado == "Outros") input$polo_outros else input$polo_visitado
    } else NULL
    
    demanda <- safe(input$demanda)
    rede_intersetorial <- if (demanda == "Encaminhada pela Rede Intersetorial") safe(input$rede_intersetorial) else NULL
    rede_semmu <- if (demanda == "Encaminhamento Interno da Rede SEMMU") safe(input$rede_semmu) else NULL
    
    tagList(
      div(style = "margin-bottom: 30px;",
          h4("🌐 Rede de Atendimento SEMMU"),
          tags$pre(paste(
            "Unidade:", safe(input$rede),
            "\nProfissional:", safe(profissional),
            if (!is.null(polo)) paste("\nPolo Visitado:", safe(polo)) else ""
          ))
      ),
      
      div(style = "margin-bottom: 30px;",
          h4("📍 Dados Iniciais de Cadastro"),
          tags$pre(paste(
            "Nome Completo:", safe(input$nome),
            "\nCPF:", safe(input$cpf),
            "\nData de Nascimento:", safe(input$data_nascimento),
            "\nTelefone:", safe(input$telefone),
            "\nRG:", safe(input$rg),
            "\nTipo de Demanda:", demanda,
            if (!is.null(rede_intersetorial)) paste("\nRede Intersetorial:", rede_intersetorial) else "",
            if (!is.null(rede_semmu)) paste("\nRede SEMMU:", rede_semmu) else ""
          ))
      ),
      
      div(style = "margin-bottom: 30px;",
          h4("📄 Notificação Individual"),
          tags$pre(paste(
            "Nome Social:", safe(input$nome_social),
            "\nData de Nascimento:", safe(input$data_nascimento),
            "\nNaturalidade:", safe(if (input$naturalidade == "Outros") input$naturalidade_outros else input$naturalidade),
            "\nUF:", safe(if (input$uf == "Outros") input$uf_outros else input$uf),
            "\nGestante:", safe(input$gestante),
            "\nRaça/Cor:", safe(input$raca_cor),
            "\nEstado Civil:", safe(input$estado_civil),
            "\nEscolaridade:", safe(input$escolaridade),
            "\nAtividade Laboral:", safe(if (input$atividade_laboral == "Outros") input$atividade_outros else input$atividade_laboral),
            "\nDeficiência / Transtorno:", safe(if (input$deficiencia == "Outros") input$deficiencia_outros else input$deficiencia),
            "\nOrientação Sexual:", safe(if (input$orientacao_sexual == "Outros") input$orientacao_outros else input$orientacao_sexual),
            "\nIdentidade de Gênero:", safe(if (input$identidade_genero == "Outros") input$identidade_outros else input$identidade_genero)
          ))
      ),
      
      div(style = "margin-bottom: 30px;",
          h4("👥 Composição Familiar"),
          DT::dataTableOutput("tabela_familia_resumo")
      ),
      
      div(style = "margin-bottom: 30px;",
          h4("🏠 Dados de Residência"),
          tags$pre(paste(
            "Município:", safe(if (input$municipio_residencia == "Outros") input$municipio_outros else input$municipio_residencia),
            "\nBairro:", safe(input$bairro),
            "\nLogradouro:", safe(input$logradouro),
            "\nNúmero:", safe(input$numero),
            "\nComplemento:", safe(input$complemento),
            "\nZona:", safe(input$zona),
            "\nCondição de Moradia:", safe(input$condicao_moradia)
          ))
      ),
      
      div(style = "margin-bottom: 30px;",
          h4("💰 Descrição da Fonte de Renda"),
          tags$pre(paste(
            "Renda Média:", safe(input$renda_media),
            "\nBenefício Social:", safe(input$beneficio_social),
            "\nValor do Benefício:", formatar_moeda(input$valor_beneficio),
            "\nRenda Própria:", formatar_moeda(input$valor_renda_propria),
            "\nRenda Pensão:", formatar_moeda(input$valor_renda_pensao)
          ))
      )
    )
  })
  
  # Renderização da tabela de composição familiar
  output$tabela_familia_resumo <- DT::renderDataTable({
    df <- dados_familia$tabela
    if (is.null(df) || nrow(df) == 0) return(NULL)
    
    df <- df[, !(names(df) %in% c("editar", "excluir", "ações")), drop = FALSE]
    
    DT::datatable(
      df,
      rownames = FALSE,
      options = list(dom = 't', paging = FALSE, ordering = FALSE)
    )
  })
}