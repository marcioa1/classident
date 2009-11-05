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