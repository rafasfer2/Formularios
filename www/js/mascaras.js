// Máscaras para campos específicos do formulário SIAM
// Aplicadas dinamicamente quando os inputs mudam (shiny:inputchanged)
$(document).on('shiny:inputchanged', function() {
  $('#cpf').mask('000.000.000-00');               // CPF
  $('#telefone').mask('(00) 00000-0000');         // Telefone celular
  $('#rg').mask('00.000.000-0');                  // RG
  $('#cep').mask('00000-000');                    // CEP
  $('#data_manual').mask('00/00/0000 00:00');     // Data com hora
  $('#data_nascimento').mask('00/00/0000');       // Data de nascimento
});

// Máscara para campos de valor monetário (classe .moeda)
$(document).ready(function() {
  $('.moeda').mask('000.000.000,00', {reverse: true});
});