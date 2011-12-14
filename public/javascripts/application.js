// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
jQuery(function() {
    $('input[type="text"].first').focus();
    $("#tabs").tabs();
    
    $("#datepicker").datepicker();
    $("#datepicker2").datepicker();
    $("#datepicker3").datepicker();
    $("#datepicker4").datepicker();
    $("#datepicker5").datepicker();
    $("#datepicker6").datepicker();
    $(".datepicker").datepicker({ disabled: true, minDate: -15});
});


function outra_clinica(){
    $("#seleciona_clinica").show();
};

function conta_caracteres(){
    if ($("#nome").val().length > 2){
      $("#pesquisar_button").attr('disabled',false);    
    }else{
      $("#pesquisar_button").attr('disabled',true); 
    }
}

function selecionou_item_tabela(item_id){
    $.getJSON('/item_tabelas/busca_descricao',{
          'id': item_id 
      },
      function(data){
       resultado = data.split(";");
       $("#tratamento_descricao").val(resultado[0]);
       $("#iniciais").val(resultado[0]);
       $("#tratamento_valor_pt").val(resultado[1]);  
       $("#tratamento_dentista_id").focus();       
      }
    );
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

function copia_valor(){
    $("#valor_do_cheque").val($("#recebimento_valor_real").val());
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
function abre_spc(){
    $("#spc_fields").toggle('blind', { percent: 0 },500);
}
function abre_solucionado(){
    $("#solucao_fields").toggle('blind', { percent: 0 },500);
}
function abre_arquivo_morto(){
    $("#arquivo_morto_fields").toggle('blind', { percent: 0 },500);
}
function enviar_administracao(){
    var selecionados = "";
    var chk = $('input:checkbox');
    for (var i = 0; i < chk.length; i++){ 
             var item = chk[i].id; 
             if($("#" + item).is(':checked')){
               selecionados += item + ",";
             }
    }
    $.getJSON("envia_cheques_a_administracao", {cheques: selecionados}, function(data){
      $("form:last").trigger("submit");
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
    window.open("/cheques/"+ id,"abriu o cheque" ,"height=260,width=480,status=no");
}

function abre_pagamento(id){
    window.open("/pagamentos/"+ id,"abre o pagamento" ,"heigth=800,width=800,status=no,resizable=yes,scrollbars=yes");
}

function pesquisa_disponiveis(){
  jQuery.ajax({
     url : "/cheques/busca_disponiveis",
     type: 'GET',
     data: {valor: $("#pagamento_valor_pago_real").val(),
            bom_para: $("#pagamento_data_de_pagamento_pt").val()},
     success: function(data){
       $("#lista_de_cheques").replaceWith("<span id='lista_de_cheques'>" + data + "</span>");
     }
  });
}

function formata_valor(elemento){
  elemento.priceFormat({  
     prefix: "",  
     centsSeparator: ",",  
     thousandsSeparator: "."  
  });
}

function seleciona_todas_as_formas_de_recebimento(){
	if ($('#todas').is(':checked')){
    $("input[name*='forma']").attr('checked',true);
  } else{
    $("input[name*='forma']").attr('checked',false);
  }
}


jQuery(function() {
$.loading({
   onAjax: true,
   text: 'Carregando ...',
   align: 'center',
   mask: true
 });
});
 
function confirma_recebimento_de_cheque(){
    var selecionados = "";
    var chk = $('input:checkbox');
    for (var i = 0; i < chk.length; i++){ 
             var item = chk[i].id; 
             if($("#" + item).is(':checked')){
               selecionados += item + ",";
             }
    }
    $.ajax({
      url: "registra_recebimento_de_cheques",
      data:  {cheques: selecionados},
      success: function(data){
        alert("cheques recebidos com sucesso.");
        $("form:last").trigger("submit");
      },
      error: function(data){
        alert("Cheques não foram registrados corretamente.");
      }
      
    });
}



function pagar_dentista(valor,tratamento_id,dentista_id){
    anterior = $('#valor').text();
    valor_total = parseFloat(anterior);
    if ($("#pagar_dentista_" + tratamento_id).is(':checked')==true)
      valor_total = valor_total + valor;
    else
      valor_total = valor_total - valor;
    $('#valor').text(valor_total);
    var link = "<span id='link_pagamento'><a href='/pagamentos/new?valor=" + 
             valor_total + "&dentista_id=" + dentista_id + "'>efetua pagamento</a></span>";
    $('#link_pagamento').replaceWith(link);
}

function pagamento_dentista(dentista_id){
    var clinicas = $("#fragment-3 input:checkbox");
    $.ajax({
      url: 'pagamento',
      data: {inicio: $("#datepicker3").val(),
             fim: $("#datepicker4").val(),
             dentista_id: dentista_id},
      success: function(data){
        $("#lista_pagamento").replaceWith(data);
      }
    });
}

function registra_confirmacao_de_entrada(){
  entradas = $('input:checked');
  id_str = '';
  $.each(entradas, function(index,value){
    aux = ((value.id).split('_'));
    id_str += aux[1] + ',';
  });
  jQuery.ajax({
     url : "/entradas/registra_confirmacao_de_entrada",
     type: 'POST',
     data: {data: id_str},
     success: function(data){
       $('input:submit').click();  
     }
  });
}

function registra_confirmacao_de_movimentacao(id){
  jQuery.ajax({
     url : "/entradas/registra_confirmacao_de_entrada",
     type: 'POST',
     data: {data: id},
     success: function(data){
       $("#td_" + id).html(data);
     }
  });
}

function busca_proteticos_da_clinica(){
  $.ajax({
    url    : "/proteticos/busca_proteticos_da_clinica",
    type   : "GET",
    data   : { "clinica_id" : $('#clinica').val() },
    success: function(result){
      $("#protetico").html("");
      for (var i = 0; i < result.length; i++){ 
        $("#protetico").append(new Option(result[i]  ,result[i]));
      }
    }
  });
}

function pagamento_protetico(){
  var selecionados = $("input:checked");
  id_str = '';
  valor_a_pagar = 0;
  $.each(selecionados, function(index,value){
    aux = ((value.id).split('_'));
    id_str += aux[2] + ',';
    valor_a_pagar += parseFloat($('#valor_'+aux[2]).html());
  });
  var protetico_id = $("#protetico_id").val();
  var url = "http://"+ window.location.host + "/pagamentos/registra_pagamento_a_protetico" +
     "?ids='" + id_str + "'&valores='" + valor_a_pagar + "' &protetico_id=" + protetico_id;
  window.location = url;
}

function busca_saldo(){
	$("#data").replaceWith("<span id='data'></span>");
	$("#saldo_em_dinheiro").val("");
  $("#saldo_em_cheque").val("");
	$.ajax({
    url    : "/busca_saldo",
    type   : "GET",
    data   : { "clinica" : $("#clinica").val() },
    success: function (result){
	    var array = result.split(";");
	    $("#data").replaceWith(array[0]);
	    $("#saldo_em_dinheiro").val(array[1]);
	    $("#saldo_em_cheque").val(array[2]);
      }
  });
}

function limpa_nome(){
    $("#nome").val('');
}

function limpa_codigo(){
    $("#codigo").val('');
}

function verifica_valor_restante(){
  var total_de_cheques = 0.0;
  var todos = $("#selecionados table tbody tr");
  var selecionados = "";
  for (var i = 0; i < todos.length; i++) {
    id_cheque = (todos[i].id).split("_")[1];
    if (id_cheque != 'undefined'){
      selecionados += id_cheque + ",";
      var valor = $("#valor_" + id_cheque).text();
      valor = valor.replace(".","");
      valor = parseFloat(valor.replace(",", "."));
      total_de_cheques += valor;
    }
  }
  $("#cheques_ids").val(selecionados);
  var total_a_pagar = parseFloat($("#pagamento_valor_pago_real").val().replace(".", "").replace(",", "."));;
  console.log('total_a_pagar : '+ total_a_pagar);
  console.log('total_de_cheques : '+ total_de_cheques);
  $("#pagamento_valor_restante_br").val(parseInt((total_a_pagar - total_de_cheques) * 100));
  console.log($("#pagamento_valor_restante_br").val());
  formata_valor($("#pagamento_valor_restante_br"));
  if (total_a_pagar < total_de_cheques){
    sem_sinal = $("#pagamento_valor_restante_br").val();
    $("#pagamento_valor_restante_br").val('-' + sem_sinal);
    $("#pagamento_valor_restante_br").css('color', 'red');
    alert("A soma dos valores dos cheques selecionados é maior que o valor do pagamento.");
  }else {
        $("#pagamento_valor_restante_br").css('color', 'black');
  }
}
function selecionou_cheque(elemento){
  if ($("#tr2_" + elemento)[0]) {
    $("#tr2_" + elemento).remove();
    $("#cheque_"+elemento).attr("checked",false)
  } else {
    $("#selecionados table tbody").last().prepend("<tr id='tr2_" + elemento + "'>" + $("#tr_"+elemento).html() + "</tr>");
  }
  verifica_valor_restante();
}

function producao(){
    var clinicas = $("#fragment-2 input:checkbox");
    var selecionadas = '';
    for (var i = 0; i < clinicas.length; i++) {
      if ($("#" + clinicas[i].id).is(':checked')) {
        selecionadas += $("#"+ clinicas[i].id).val() + ",";
      } 
    }
    $.ajax({
      url: "producao",
      data: {datepicker: $("#datepicker").val(),
             datepicker2: $("#datepicker2").val(),
             clinicas: selecionadas},
      success: function(data){
        $("#lista").replaceWith(data);
      }
    });
}

function cheque(mostra){
    if (mostra==1){
        $("#cheque_classident").show();
        $("#pagamento_conta_bancaria_id").focus();
        $("#pagamento_valor_cheque_br").val($("#pagamento_valor_restante_br").val());
    }else {
        $("#cheque_classident").hide();
        $("#pagamento_numero_do_cheque").val("");
        $("#pagamento_valor_cheque_br").val("");
    }
}




function selecionou_estado(){
    $(':checkbox').attr('checked', false);
}

function busca_pacientes_que_iniciam_com(text_field){
  $("#linha_"+text_field).show();
  $.getJSON('/pacientes/nomes_que_iniciam_com?nome=' + $("#" + text_field).val() + '&div=' + text_field,
  function(data){
    $("#nomes_" + text_field).replaceWith('<div id="nomes_' + text_field + '"  class="lista">' + data + '</div>');
  });
}

function escolheu_nome_da_lista(nome,div,id){
  $("#"+div).val(nome);
  $("#id_"+div).val(id);
 $("#linha_"+ div).hide();
}
function selecionou_face(){
    $('#tratamento_estado_nenhum').attr('checked', true);
}
function todas_as_faces(){
    selecionou_face();
    $(':checkbox').attr('checked', $('#todas').is(':checked'));
    
}
function selecionou_tratamento(){
    var todos = $("td :checked");
    var total = 0.0;
    ids_selecionados = '';
    for (i=0;i<todos.length-1;i++){
      total = total + parseFloat(todos[i].value);
      ids_selecionados += todos[i].id + ',';
    }
    $("#tratamento_ids").val(ids_selecionados);
    $('#orcamento_valor_pt').val(total * 100);
    formata_valor($('#orcamento_valor_pt'));
}

function calcula_valor_orcamento(){
    total = parseFloat($('#orcamento_valor_pt').val().replace('.','').replace(',','.'));
    desconto = parseFloat($('#orcamento_desconto').val().replace('.','').replace(',','.'));
    valor_do_desconto = (total - (total * desconto / 100 ) )* 100;
    $('#orcamento_valor_com_desconto_pt').val(valor_do_desconto);
    formata_valor($('#orcamento_valor_com_desconto_pt'));
    calcula_valor_da_parcela();
}

function calcula_valor_da_parcela(){
	  valor_com_desconto = $('#orcamento_valor_com_desconto_pt').val().replace('.','').replace(',','.');
    valor              = parseFloat(valor_com_desconto);
    numero             = $('#orcamento_numero_de_parcelas').val();
    valor_da_parcela   = parseInt((valor / numero) * 100) / 100;
    $('#orcamento_valor_da_parcela_pt').val(valor_da_parcela * 100);
    formata_valor($('#orcamento_valor_da_parcela_pt'));
  $.ajax({
    url  : '/orcamentos/monta_tabela_de_parcelas',
    type :'GET', 
    data : { numero_de_parcelas:numero, valor_da_parcela:valor, data_primeira_parcela:$('#orcamento_vencimento_primeira_parcela').val()},
    success :function(data){
      $('#parcelas').replaceWith(data);
    }
  });
}

function definir_valor(){
  if ($('#acima_de_um_valor').is(':checked')){
    $('#valor').focus();
  }else{
    $('#valor').val('');
  }
}

function orcamento_dentista(){
  var clinicas = $("#fragment-4 input:checkbox");
  var selecionadas = '';
  for (var i = 0; i < clinicas.length; i++) {
    if ($("#" + clinicas[i].id).is(':checked')) {
      selecionadas += $("#"+ clinicas[i].id).val() + ",";
    } 
  }
  $.ajax({
    url: "orcamentos",
    data: {inicio:  $("#datepicker5").val(),
          fim: $("#datepicker6").val(),
          clinicas: selecionadas},
    success: function(data){
      $("#lista_orcamento").replaceWith(data);  
    }
    });
}

function finalizar_tratamento(tratamento_id){
  $.ajax({url : '/tratamentos/' + tratamento_id + '/finalizar_procedimento',
         success: function(data){
           $("#finalizar_"+tratamento_id + " a" ).replaceWith(hoje);
           $("#extrato_table").replaceWith(data);
         },
         error: function(objRequest, textStatus){
           alert(textStatus);
         }
         });
}

function hoje(){
  hoje = new Date();
  dia  = hoje.getDate();
  mes  = hoje.getMonth();
  ano  = hoje.getFullYear();
  if (dia < 10)
    dia = "0" + dia;
  mes = mes + 1;
  if (mes < 9)
    mes = "0"+ mes;
  if (ano < 2000)
    ano = "19" + ano;
  return dia+"/"+(mes)+"/"+ano;
}

function busca_id(numero){
  $.ajax({
    url  : "/pacientes/busca_id_do_paciente",
    type : 'GET',
    data : {nome: $('#paciente_'+numero).val()},
    success : function(data){
      $('#paciente_id_' + numero).val(data);
    }
    }
  );
}

function valida_senha(){
  var senha_digitada = $('#nova_senha').val();
  var controller     = $('#controller').html();
  var action         = $('#action').html();
  $.ajax({
    url : "/valida_senha",
    type: 'GET', 
    data: {controller_name: controller, action_name: action, senha_digitada: senha_digitada},
    success :function(data){
      if (data==true){
        $("#corpo").toggle('slow');
        $("#corpo_senha").hide();        
      } else {
        alert("senha inválida.");
      }
    }
    
  });
}

function busca_usuarios(){
  $.ajax({
    url  : "/clinicas/usuarios_da_clinica",
    type : 'GET', 
    data : {clinica_id: $("#clinica_monitor_id").val()},
    success :function(data){
      $("#user_monitor_id").html("");
      for (var i = 0; i < data.length; i++){ 
        $("#user_monitor_id").append(new Option(data[i][1]   ,data[i][0]));
      }    
    }
  });
}

function imprime_extrato(paciente_id, clinica_id){
  $.ajax({
    url  : "/pacientes/" + paciente_id + "/extrato_pdf",
    type : "GET",
    success :function(data){
        window.open("http://" + location.host + "/relatorios/extrato_" + clinica_id +".pdf");
      }, 
    error : function(){
      alert("Não foi possível gerar o relatório.");
    }
  });
}
   
function imprime_orcamento(orcamento_id,clinica_id){
  $.ajax({
    url  : "/orcamentos/" + orcamento_id + "/imprime",
    data : {clinica_id: clinica_id},
    type : "GET",
    success :function(data){
        window.open("http://" + location.host + "/impressoes/" +  clinica_id + "/orcamento.pdf");
      }, 
    error : function(){
      alert("Não foi possível gerar o relatório.");
    }
  });
}

function gera_pdf(dados, clinica, orientation){
  $.ajax({
    url  : "/gera_pdf",
    data : {tabela: dados,
            orientation: orientation},
    type : "POST",
    success :function(data){
        window.open("http://" + location.host + "/impressoes/" + clinica + "/relatorio.pdf");
      }, 
    error : function(){
      alert("Não foi possível gerar o relatório.");
    }
  });
}

function verifica_se_tem_paciente_com_este_nome(){
  $.ajax({
    url  : "verifica_nome_do_paciente/0",
    data : {nome: $("#paciente_nome").val()},
    type : "GET",
    success :function(data){
      $("#transfere_clinica").html(data.paciente.complemento);
       // dialog("voltou com paciente encontrado na clinica : " + data.paciente.nome);
       $( "#transfere" ).dialog({
			resizable: false,
			height:140,
			modal: true,
			buttons: {
				"Transfere paciente ": function() {
					transfere_paciente(data.paciente.id);
				},
				"Cancela": function() {
					$( this ).dialog( "close" );
				}
			}
		});

      }
  });
}

function transfere_paciente(id){
  $.ajax({
    url  : "transfere_paciente",
    data : {id: id},
    type : "GET",
    success :function(data){
      location.href="0/abre?nome=" + data;
      // alert("Paciente transferido. Pesquise novamente pelo nome para trazer sua dados.");
    }
  });
}

function troca_para_ortodontista(dentista_id){
    $.ajax({
    url  : "/dentistas/" + dentista_id + "/troca_ortodontista",
    data : {},
    type : "POST",
    success :function(data){
      status = $("#" + dentista_id + " a").html();
      if (status == 'não'){
        $("#" + dentista_id + " a").html('sim');
      }else{
        $("#" + dentista_id + " a").html('não');
      }
    }
  });
}


function devolve_cheque_a_clinica(id){
  jQuery.ajax({
     url : "/cheques/"+ id + "/devolve_a_clinica",
     type: 'GET',
     success: function(data){
       $("#td_" + id).html('devolvido à clínica');
     }
  });
}

function recebe_cheque_devolvido(id){
  jQuery.ajax({
     url : "/cheques/"+ id + "/recebe_da_administracao",
     type: 'GET',
     success: function(data){
       $("#td_" + id + " a").hide();
       $("#td_" + id).html('Recebido.');
     }
  });
}

function confirma_recebimento_de_cheque(id){
  jQuery.ajax({
     url : "/cheques/"+ id + "/confirma_recebimento_na_administracao",
     type: 'GET',
     success: function(data){
       $("#adm_" + id + " a").hide();
       $("#adm_" + id).html('Recebido.');
     }
  });
}

