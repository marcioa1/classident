function limpa_nome(){
	$("#nome").val('');
}

function limpa_codigo(){
	$("#codigo").val('')
}
function pesquisa_disponiveis(){
//  alert("pesquisando cheques disponiveis");
   $.get("/cheques/busca_disponiveis" );
}