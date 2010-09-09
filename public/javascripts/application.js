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
    $(".datepicker").datepicker();
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

function selecionou_item_tabela(clinica_id){
    $.getJSON('/item_tabelas/busca_descricao',{
          'id': $("#tratamento_item_tabela_id").selectedValues()[0]
      },
      function(data){
       resultado = data.split(";");
       $("#tratamento_descricao").val(resultado[0]);         
       $("#tratamento_valor").val(resultado[1]);         
      }
    );
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
    var selecionados = "";
    var chk = $('input:checkbox');
    for (var i = 0; i < chk.length; i++){ 
             var item = chk[i].id; 
             if($("#" + item).is(':checked')){
               selecionados += item + ",";
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
    window.open("/cheques/"+ id,"abriu o cheque" ,"height=260,width=480,status=no");
}

function abre_pagamento(id){
    window.open("/pagamentos/"+ id,"abre o pagamento" ,"height=600,width=600,status=no,resizable=yes,scrollbars=yes");
}

function pesquisa_disponiveis(){
  jQuery.ajax({
     url : "/cheques/busca_disponiveis",
     type: 'GET',
     data: {valor: $("#pagamento_valor_pago_real").val()},
     success: function(data){
       $("#lista_de_cheques").replaceWith("<span id='lista_de_cheques'>" + data + "</span>");
     }
  });
   // $.getJSON("/cheques/busca_disponiveis?valor=" + $("#pagamento_valor_pago_real").val(), function(data){
   //   $("#lista_de_cheques").replaceWith("<span id='lista_de_cheques'>" + data + "</span>");
   //   });
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
    $.getJSON("registra_recebimento_de_cheques", {cheques: selecionados}, function(data){
//      $("form:last").trigger("submit");
      alert(data);
    });
}

function pagar(valor,id, id_protetico){
    anterior = $('#valor').text();
    valor_total = parseFloat(anterior);
    if ($("#pagar_" + id).is(':checked')==true)
      valor_total = valor_total + valor;
    else
      valor_total = valor_total - valor;
    $('#valor').text(valor_total);
    var checkeds = $(":checkbox[name|='pagar']:checked");
    var ids = ''   ;
    for (id = 0; id<checkeds.size(); id++){
      ids = ids + ',' + checkeds[id].value ;
    }
    if (ids.length > 1){
        ids = ids.substring(1);
    }
    var link = "<span id='link_pagamento'><a href='/pagamentos/new?valor=" + 
             valor_total + "&trabalho_protetico_id=" + ids + 
             "&protetico_id=" + id_protetico + "'>efetua pagamento</a></span>";
    $('#link_pagamento').replaceWith(link);
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
    url = "pagamento?inicio='" + $("#datepicker3").val() + 
           "'&fim='" + $("#datepicker4").val() +
           "'&dentista_id=" + dentista_id;
    $.getJSON( url, function(data){
        $("#lista_pagamento").replaceWith(data);
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
  alert(url);
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

function selecionou_cheque(elemento){
  var total_de_cheques = 0.0;
  var todos = $("#lista_de_cheques :checked");
  var selecionados = "";
  for (var i = 0; i < todos.length; i++) {
    id_cheque = (todos[i].id).split("_")[1];
    selecionados += id_cheque + ",";
    var valor = $("#valor_" + id_cheque).text();
    valor = valor.replace(".","");
    valor = parseFloat(valor.replace(",", "."));
    total_de_cheques += valor;
  }
  $("#cheques_ids").val(selecionados);
  var total_a_pagar = $("#pagamento_valor_pago").val();
  if (total_a_pagar < total_de_cheques){
    alert("A soma dos valores dos cheques selecionados é maior que o valor do pagamento.");
  }
  $("#pagamento_valor_restante").val(parseInt((total_a_pagar - total_de_cheques) * 100));
  formata_valor($("#pagamento_valor_restante"));
}

function producao(){
    var clinicas = $("#fragment-2 input:checkbox");
    var selecionadas = '';
    for (var i = 0; i < clinicas.length; i++) {
      if ($("#" + clinicas[i].id).is(':checked')) {
        selecionadas += $("#"+ clinicas[i].id).val() + ",";
      } 
    }
    url = "producao?datepicker='" + $("#datepicker").val() + 
           "'&datepicker2='" + $("#datepicker2").val() +
           "'&clinicas=" + selecionadas;
    $.getJSON( url, function(data){
        $("#lista").replaceWith(data);
    });
}

function cheque(mostra){
    if (mostra==1){
        $("#cheque_classident").show();
        $("#pagamento_conta_bancaria_id").focus();
        $("#pagamento_valor_cheque").val($("#pagamento_valor_restante").val());
    }else {
        $("#cheque_classident").hide();
        $("#pagamento_numero_do_cheque").val("");
        $("#pagamento_valor_cheque").val("");
    }
}


function escolheu_protetico(){
    $("#trabalho_protetico_tabela_protetico_id").hide();
    $.getJSON("/proteticos/busca_tabela",{'protetico_id': $("#trabalho_protetico_protetico_id").val() },
      function(data){
        $("#trabalho_protetico_tabela_protetico_id").html("");
        saida = "";
        for (var i = 0; i < data.length; i++){
          if (i==0){
            var primeiro_id = data[0][1];
            $.getJSON("/tabela_proteticos/busca_valor",{'id': primeiro_id },
               function(data2){
                 $("#trabalho_protetico_valor").val(data2);
               });
          }
          $("#trabalho_protetico_tabela_protetico_id").append(new Option(data[i][0] + ' ' ,data[i][1]));
       }
    });
    $("#trabalho_protetico_tabela_protetico_id").show();
}

function escolheu_item_da_tabela(){
    $.getJSON("/tabela_proteticos/busca_valor",{'id': $("#trabalho_protetico_tabela_protetico_id").val() },
       function(data){
         $("#trabalho_protetico_valor").val(data);
    });
}

function devolve_trabalho(id){
    $.get("/registra_devolucao_de_trabalho?id=" + id);
    var d = new Date();
    var curr_date = d.getDate();
    var curr_month = d.getMonth();
    curr_month++;
    var curr_year = d.getFullYear();
    $("#data_"+id).replaceWith(curr_date + "/" + curr_month + "/" + curr_year);
}

function registra_devolucao(id){
   $.get("/registra_devolucao_de_trabalho?id=" + id);
   var d = new Date();
   var curr_date = d.getDate();
   var curr_month = d.getMonth();
   curr_month++;
   var curr_year = d.getFullYear();
   $("#data_devolucao_"+id).replaceWith(curr_date + "/" + curr_month + "/" + curr_year);
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
  //alert(div)
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
    total = parseFloat($('#orcamento_valor_pt').val());
    desconto = parseFloat($('#orcamento_desconto_pt').val());
    $('#orcamento_valor_com_desconto').val(total - (total * desconto / 100 ));
    calcula_valor_da_parcela();
}

function calcula_valor_da_parcela(){
	  valor_com_desconto = $('#orcamento_valor_com_desconto_pt').val().replace(',','.');
    valor = parseFloat(valor_com_desconto);
    numero = $('#orcamento_numero_de_parcelas').val();
    valor_da_parcela = parseInt((valor / numero) * 100) / 100;
    alert(valor_da_parcela);
    $('#orcamento_valor_da_parcela_pt').val(valor_da_parcela);
    formata_valor($('#orcamento_valor_da_parcela_pt'));
//# FIXME escrever este ajax de outra maneira
  $.ajax({
    url  : '/orcamentos/monta_tabela_de_parcelas',
    type :'GET', 
    data : { numero_de_parcelas:numero, valor_da_parcela:valor, data_primeira_parcela:$('#orcamento_vencimento_primeira_parcela').val()},
    success :function(data){
      $('#parcelas').replaceWith(data);
    }
  });
  // $.getJSON('monta_tabela_de_parcelas?numero_de_parcelas='+numero + '&valor_da_parcela=' + valor +
  //        '&data_primeira_parcela=' + $('#orcamento_vencimento_primeira_parcela').val(),
  //    function(data){
  //      $('#parcelas').replaceWith(data);
  //    });
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
  url = "orcamentos?inicio='" + $("#datepicker5").val() + 
         "'&fim='" + $("#datepicker6").val() +
         "'&clinicas=" + selecionadas;
  $.getJSON( url, function(data){
      $("#lista_orcamento").replaceWith(data);
  }); 
}

function finalizar_tratamento(tratamento_id){
  $.ajax({url : '/tratamentos/' + tratamento_id + '/finalizar_procedimento',
         success: function(){
           window.location.reload();
         }});
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