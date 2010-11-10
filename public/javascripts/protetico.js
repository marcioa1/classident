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

function registra_devolucao(id){
   $.get("/registra_devolucao_de_trabalho?id=" + id);
   var d = new Date();
   var curr_date = d.getDate();
   var curr_month = d.getMonth();
   curr_month++;
   var curr_year = d.getFullYear();
   $("#data_devolucao_"+id).replaceWith(curr_date + "/" + curr_month + "/" + curr_year);
}
