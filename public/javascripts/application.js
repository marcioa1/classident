// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery(function() {
	$('input[type="text"].first').focus();
    $("#tabs").tabs();
   	$("#datepicker").datepicker({  
        dateFormat: 'dd-mm-yy',
         dayNames: [  
        'Domingo','Segunda','Terça','Quarta','Quinta','Sexta','Sábado','Domingo'  
        ],  
        dayNamesMin: [  
        'D','S','T','Q','Q','S','S','D'  
        ],  
        dayNamesShort: [  
        'Dom','Seg','Ter','Qua','Qui','Sex','Sáb','Dom'  
        ],  
        monthNames: [  
        'Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro',  
        'Outubro','Novembro','Dezembro'  
        ],  
        monthNamesShort: [  
        'Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set',  
        'Out','Nov','Dez'  
        ],  
        nextText: 'Próximo',  
        prevText: 'Anterior'  

          });


		$("#datepicker2").datepicker({  
	        dateFormat: 'dd-mm-yy',
	         dayNames: [  
	        'Domingo','Segunda','Terça','Quarta','Quinta','Sexta','Sábado','Domingo'  
	        ],  
	        dayNamesMin: [  
	        'D','S','T','Q','Q','S','S','D'  
	        ],  
	        dayNamesShort: [  
	        'Dom','Seg','Ter','Qua','Qui','Sex','Sáb','Dom'  
	        ],  
	        monthNames: [  
	        'Janeiro','Fevereiro','Março','Abril','Maio','Junho','Julho','Agosto','Setembro',  
	        'Outubro','Novembro','Dezembro'  
	        ],  
	        monthNamesShort: [  
	        'Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set',  
	        'Out','Nov','Dez'  
	        ],  
	        nextText: 'Próximo',  
	        prevText: 'Anterior'  
        });
})

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
    $.getJSON('/item_tabelas/busca_descricao',{'id': $("#tratamento_item_tabela_id").selectedValues(),
          'clinica_id': clinica_id},
      function(data){
       resultado = data.split("/");
       $("#descricao_item_tabela").text(resultado[0]);         
       $("#tratamento_valor").val(resultado[1]);         
  });
}

function coloca_data_de_hoje(dia,mes,ano){
    $("#tratamento_data_3i").selectOptions(dia + "");
    $("#tratamento_data_2i").selectOptions(mes + "");
    $("#tratamento_data_1i").selectOptions(ano + "");
}

function selecionou_forma(element){
	if ($("#" + element).selectedOptions().text().toLowerCase()=="cheque") {
      $("#cheque").toggle('blind', { percent: 0 },500 ); 		
	}else {
      $("#cheque").toggle('blind', { percent: 0 },500 ); 		
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
	alert("uma devolucao");
	$("#uma_devolucao").toggle();
}