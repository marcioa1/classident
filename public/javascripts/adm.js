function confirma_recebimento_de_cheque(){
    var selecionados = ""
    var chk = $('input:checkbox');
    for (var i = 0; i < chk.length; i++){ 
             var item = chk[i].id; 
             if($("#" + item).is(':checked')){
               selecionados += item + ","
             }
    }
    $.getJSON("registra_recebimento_de_cheques", {cheques: selecionados}, function(data){
//      $("form:last").trigger("submit");
      alert(data);
    });
}

function pagar(valor,id, id_protetico){
    anterior = $('#valor').text();
    valor_total = parseFloat(anterior)
    if ($("#pagar_" + id).is(':checked')==true)
      valor_total = valor_total + valor
    else
      valor_total = valor_total - valor
    $('#valor').text(valor_total)
    var checkeds = $(":checkbox[name|='pagar']:checked")
    var ids = ''   
    for (id = 0; id<checkeds.size(); id++){
      ids = ids + ',' + checkeds[id].value 
    }
    if (ids.length > 1){
        ids = ids.substring(1)
    }
    var link = "<span id='link_pagamento'><a href='/pagamentos/new?valor=" + 
             valor_total + "&trabalho_protetico_id=" + ids + 
             "&protetico_id=" + id_protetico + "'>efetua pagamento</a></span>"
    $('#link_pagamento').replaceWith(link)
}

function pagar_dentista(valor,tratamento_id,dentista_id){
    anterior = $('#valor').text();
    valor_total = parseFloat(anterior)
    if ($("#pagar_dentista_" + tratamento_id).is(':checked')==true)
      valor_total = valor_total + valor
    else
      valor_total = valor_total - valor
    $('#valor').text(valor_total)
    var link = "<span id='link_pagamento'><a href='/pagamentos/new?valor=" + 
             valor_total + "&dentista_id=" + dentista_id + "'>efetua pagamento</a></span>"
    $('#link_pagamento').replaceWith(link)
}