function registra_devolucao(id){
   $.get("/registra_devolucao_de_trabalho?id=" + id);
   var d = new Date();
   var curr_date = d.getDate();
   var curr_month = d.getMonth();
   curr_month++;
   var curr_year = d.getFullYear();
   $("#data_devolucao_"+id).replaceWith(curr_date + "/" + curr_month + "/" + curr_year);
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


function pagar(valor,id, id_protetico){
    anterior = $('#valor').text();
    valor_total = parseFloat(anterior);
    if ($("#pagar_" + id).is(':checked')==true)
      valor_total = valor_total + valor;
    else
      valor_total = valor_total - valor;
    $('#valor').text(valor_total);
    formata_valor($('#valor'));
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

function libera_pagamento(){
  var ids = '';
  $(".libera_pagamento :checked").each(function() {
    ids+= ($(this).attr('value') + ',');
  });
  $.ajax({
     url : '/trabalho_proteticos/libera_pagamento',
     data: { ids: ids},
     success: function(){
       $(".libera_pagamento :checked").each(function() {
          id = $(this).attr('value');
          $("#tr"+id).remove();
       });
     }
   });
}

function cancelar_liberacao(id){
    $.ajax({
     url : '/trabalho_proteticos/' + id + '/cancelar_liberacao',
     data: { id: id},
     success: function(){
       $("#tr-liberados"+id).remove();
     }
   });
}