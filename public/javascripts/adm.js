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