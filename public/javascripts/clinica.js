function limpa_nome(){
	$("#nome").val('');
}

function limpa_codigo(){
	$("#codigo").val('')
}
function pesquisa_disponiveis(){
 // alert("pesquisando cheques disponiveis");
   $.getJSON("/cheques/busca_disponiveis", function(data){
//	  alert(data);
	$("#lista_de_cheques").replaceWith("<span id='lista_de_cheques'>" + data + "</span>");
    });
}

function selecionou_cheque(){
//	alert("seleciuonou : "+ valor);
	alert(this.tag_name);
//	var total = $("#pagamento_valor").val();/
//	$("#pagamento_valor_pago").val(total-valor); 
//	alert(total - valor);
}