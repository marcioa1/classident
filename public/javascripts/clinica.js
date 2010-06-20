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
    var todos = $(":checked");
    var total = 0.0;
    for (i=0;i<todos.length;i++){
        total = total + parseFloat(todos[i].value);
    }
    $('#orcamento_valor').val(total);
}

function calcula_valor_orcamento(){
    total = parseFloat($('#orcamento_valor').val());
    desconto = parseFloat($('#orcamento_desconto').val());
    $('#orcamento_valor_com_desconto').val(total - (total * desconto / 100 ));
    calcula_valor_da_parcela();
}

function calcula_valor_da_parcela(){
	  valor_com_desconto = $('#orcamento_valor_com_desconto').val().replace(',','.');
    valor = parseFloat(valor_com_desconto);
    numero = $('#orcamento_numero_de_parcelas').val();
    $('#orcamento_valor_da_parcela').val(parseInt((valor / numero)*100));
    
    formata_valor($('#orcamento_valor_da_parcela'));
//# FIXME escrever este ajax de outra maneira
  $.getJSON('monta_tabela_de_parcelas?numero_de_parcelas='+numero + '&valor_da_parcela=' + valor +
        '&data_primeira_parcela=' + $('#orcamento_vencimento_primeira_parcela').val(),
    function(data){$('#parcelas').replaceWith(data);});
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