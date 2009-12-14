// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery(function() {
    $('input[type="text"].first').focus();
    $("#tabs").tabs();
    
    $("#datepicker").datepicker();
    $("#datepicker2").datepicker();
    $("#datepicker3").datepicker();
    $("#datepicker4").datepicker();
        
})

function outra_clinica(){
    $("#seleciona_clinica").show();
}

function conta_caracteres(){
    if ($("#nome").val().length > 5){
      $("#pesquisar_button").attr('disabled',false);    
    }else{
      $("#pesquisar_button").attr('disabled',true); 
    }
}

function selecionou_item_tabela(clinica_id){
    $.getJSON('/item_tabelas/busca_descricao',{'id': $("#tratamento_item_tabela_id").selectedValues(),
          'clinica_id': clinica_id},
      function(data){
       resultado = data.split("/");
       $("#descricao_item_tabela").text(resultado[0]);         
       $("#tratamento_valor").val(resultado[1]);         
  });
}
//TODO acho que nao  é mais necessario
function coloca_data_de_hoje(dia,mes,ano){
    $("#tratamento_data_3i").selectOptions(dia + "");
    $("#tratamento_data_2i").selectOptions(mes + "");
    $("#tratamento_data_1i").selectOptions(ano + "");
}

function selecionou_forma(element){
    if ($("#" + element).selectedOptions().text().toLowerCase()=="cheque") {
      $("#cheque").show();        
    }else {
      $("#cheque").hide();        
    }
}

function alterou_data_tratamento(){
    data = $("#datepicker").datepicker('getDate');
    if (data==null){
      $("#tratamento_data_3i").selectOptions("");
      $("#tratamento_data_2i").selectOptions("");
      $("#tratamento_data_1i").selectOptions("");
    }else {
      dia = data.getDate();
      mes = data.getMonth() + 1;
      ano = data.getFullYear();
      $("#tratamento_data_3i").selectOptions(dia+"");
      $("#tratamento_data_2i").selectOptions(mes+"");
      $("#tratamento_data_1i").selectOptions(ano+"");
    }
}

function alterou_data_cadastro(){
    data = $("#datepicker").datepicker('getDate');
    if (data==null){
      $("#paciente_nascimento_3i").selectOptions("");
      $("#paciente_nascimento_2i").selectOptions("");
      $("#paciente_nascimento_1i").selectOptions("");
    }else {
      dia = data.getDate();
      mes = data.getMonth() + 1;
      ano = data.getFullYear();
      $("#paciente_nascimento_3i").selectOptions(dia+"");
      $("#paciente_nascimento_2i").selectOptions(mes+"");
      $("#paciente_nascimento_1i").selectOptions(ano+"");
    }
}


function hoje(){
    alert("hoje");
    $("#datepicker").datepicker('setDate', new Date());
}

function copia_valor(){
    $("#recebimento_cheque_attributes_valor").val($("#recebimento_valor").val());
}

function abre_uma_devolucao(){
    $("#devolvido_uma_vez").toggle('blind', { percent: 0 },500);
}
function abre_reapresentacao(){
    $("#reapresentado").toggle('blind', { percent: 0 },500);
}
function abre_segunda_devolucao(){
    $("#devolvido_duas_vezes").toggle('blind', { percent: 0 },500);
}
function enviar_administracao(){
    var selecionados = ""
    var chk = $('input:checkbox');
    for (var i = 0; i < chk.length; i++){ 
             var item = chk[i].id; 
             if($("#" + item).is(':checked')){
               selecionados += item + ","
             }
    }
    $.getJSON("recebe_cheques", {cheques: selecionados}, function(data){
      $("form:last").trigger("submit");
      alert(data);
    });
}

function selecionar(){
	if($("#selecao").text()=="todos") {
		$("#selecao").text("nenhum");
		$("#tipo_pagamento_id").each(function(){
		    $("#tipo_pagamento_id option").attr("selected","selected"); 
		});
		
	}else {
		$("#selecao").text("todos");
		$("#tipo_pagamento_id").each(function(){
		    $("#tipo_pagamento_id option").removeAttr("selected"); 
		});
		
	}
}

function abre_cheque(id){
	window.open("/cheques/"+ id,"abriu o cheque" ,"height=240,width=310,status=no");
}