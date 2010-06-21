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
  valor_str = '';
  $.each(selecionados, function(index,value){
    aux = ((value.id).split('_'));
    id_str += aux[2] + ',';
    valor_str += $('#valor_'+aux[2]).html() + ';';
  });
  var protetico_id = $("#protetico_id").val();
  var url = "/pagamentos/registra_pagamento_a_protetico";
  url    += "?ids=" + id_str + '&valores=' + valor_str + "&protetico_id=" + protetico_id;
  alert(url);
  //window.location(url);
}

function busca_saldo(){
	$("#data").replaceWith("<span id=data></span>");
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

