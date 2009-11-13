// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

$(document).ready(function(){
    $("#tabs").tabs();
  });

function outra_clinica(){
    $("#seleciona_clinica").show();
}

function conta_caracteres(){
    if ($("#nome").val().length > 7){
      $("#pesquisar_button").attr('disabled',false);    
    }else{
      $("#pesquisar_button").attr('disabled',true); 
    }
}

function selecionou_item_tabela(clinica_id){
    $.getJSON('/item_tabelas/busca_descricao',{'id': $("#item_tabela_id").selectedValues(),
          'clinica_id': clinica_id},
      function(data){
       resultado = data.split("/");
       $("#descricao_item_tabela").text(resultado[0]);         
       $("#tratamento_valor").val(resultado[1]);         
  });
}