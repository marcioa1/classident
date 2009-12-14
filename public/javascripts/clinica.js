function limpa_nome(){
    $("#nome").val('');
}

function limpa_codigo(){
    $("#codigo").val('')
}
function pesquisa_disponiveis(){
   $.getJSON("/cheques/busca_disponiveis?valor=" + $("#pagamento_valor").val(), function(data){
    $("#lista_de_cheques").replaceWith("<span id='lista_de_cheques'>" + data + "</span>");
    });
}

function selecionou_cheque(elemento){
    var total = $("#pagamento_valor").val();
    var valor = $("#valor_" + elemento).text();
    valor = valor.replace(".","");
    valor = parseFloat(valor.replace(",", "."))
    var anterior = 0.0
    anterior = parseFloat($("#pagamento_valor_pago").val());
    if (isNaN(anterior)){
      anterior = 0.0;
    }
    var resultado = 0.0
    if ($("#cheque_"+elemento).is(':checked')) {
        resultado = parseFloat(anterior + valor)
    }else {
        resultado = parseFloat(anterior - valor)
    }
    if (total < resultado){
	  alert("A soma dos valores dos cheques selecionados é maior que o valor do pagamento.");
    }
    $("#pagamento_valor_pago").val(resultado);
    $("#pagamento_valor_restante").val(total-resultado);
    // verifica cheques selecionados
    var todos = $("table input:checkbox");
    var selecionados = ""
    for (var i = 0; i < todos.length; i++) {
      if ($("#" + todos[i].id).is(':checked')) {
        selecionados += (todos[i].id).split("_")[1] + ",";
      } 
    }
    $("#cheques_ids").val(selecionados);
}

function producao(){
	var clinicas = $("#fragment-2 input:checkbox")
	var selecionadas = ''
	for (var i = 0; i < clinicas.length; i++) {
      if ($("#" + clinicas[i].id).is(':checked')) {
        selecionadas += $("#"+ clinicas[i].id).val() + ",";
      } 
    }
	$.getJSON("producao?datepicker='" + $("#datepicker").val() + 
	       "'&datepicker2='" + $("#datepicker2").val() +
	       "'&clinicas=" + selecionadas 
	        , function(data){
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