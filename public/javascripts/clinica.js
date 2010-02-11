function limpa_nome(){
    $("#nome").val('');
}

function limpa_codigo(){
    $("#codigo").val('')
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


function escolheu_protetico(){
    $("#trabalho_protetico_tabela_protetico_id").hide();
    $.getJSON("/proteticos/busca_tabela",{'protetico_id': $("#trabalho_protetico_protetico_id").val() },
       function(data){
          $("#trabalho_protetico_tabela_protetico_id").html("");
          saida = "";
          for (var i = 0; i < data.length; i++){
            if (i==0){
              var primeiro_id = data[0][1] 
              $.getJSON("/tabela_proteticos/busca_valor",{'item_id': primeiro_id },
                 function(data2){
                   $("#trabalho_protetico_valor").val(data2);
                 });
            }
            $("#trabalho_protetico_tabela_protetico_id").append(new Option(data[i][0],data[i][1]));
          }
    });
    $("#trabalho_protetico_tabela_protetico_id").show();
//    alert("p: "+primeiro_id);
    
    
}

function escolheu_item_da_tabela(){
    $.getJSON("/tabela_proteticos/busca_valor",{'item_id': $("#trabalho_protetico_tabela_protetico_id").val() },
       function(data){
         $("#trabalho_protetico_valor").val(data);
    });
}

function devolve_trabalho(id){
	$.get("/registra_devolucao_de_trabalho?id=" + id);
	var d = new Date()
	var curr_date = d.getDate();
	var curr_month = d.getMonth();
	curr_month++;
	var curr_year = d.getFullYear();
	$("#data_"+id).replaceWith(curr_date + "/" + curr_month + "/" + curr_year)
}

function selecionou_estado(){
	$(':checkbox').attr('checked', false)
}

function selecionou_face(){
	$('#tratamento_estado_nenhum').attr('checked', true)
}
function todas_as_faces(){
	selecionou_face()
	$(':checkbox').attr('checked', $('#todas').is(':checked'))
	
}