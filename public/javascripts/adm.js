function confirma_recebimento_de_cheque(){
	var selecionados = ""
    var chk = $('input:checkbox');
    for (var i = 0; i < chk.length; i++){ 
             var item = chk[i].id; 
             if($("#" + item).is(':checked')){
               selecionados += item + ","
             }
    }
alert (selecionados);
    $.getJSON("registra_recebimento_de_cheques", {cheques: selecionados}, function(data){
//      $("form:last").trigger("submit");
      alert(data);
    });
}

function pagar(valor,id){
	anterior = $('#valor').text();
//	anterior = anterior.replace(".","")
//	anterior = anterior.replace(",", ".")
	valor_total = parseFloat(anterior)
	if ($("#pagar_" + id).is(':checked')==true)
	  valor_total = valor_total + valor
	else
	  valor_total = valor_total - valor
	$('#valor').text(valor_total)
	$('#link_pagamento').replaceWith("<span id='link_pagamento'><a href='/pagamentos/new?valor=" + valor_total + "'>efetua pagamento</a></span>")
	
}