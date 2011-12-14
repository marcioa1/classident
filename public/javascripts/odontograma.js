function desenha_odontograma(){
  $("#canvas").show();
  var gr = new jsGraphics(document.getElementById("canvas"));
  for (i = 1; i < 19; i = i + 1){
    desenha_dente(i,gr);
  }
  for (i = 19; i < 37; i = i + 1){
    desenha_dente(i,gr);
  }
  gr.drawLine(new jsPen(new jsColor("red"),1),new jsPoint(435,80),new jsPoint(435,210));
}

function desenha_dente(dente, gr){
     //Create jsColor object
    var col = new jsColor("red");
    // 
    //Create jsPen object
    var pen = new jsPen(col,1);
    // 
    face_top(gr,pen,col, dente);
    face_left(gr,pen,col,dente);
    face_bottom(gr,pen,col,dente);
    face_right(gr,pen,col,dente);

}

function face_top(gr,pen,col,dente){
  x = qual_coluna(dente);
  y = qual_linha(dente);
  var p1 = new jsPoint(x, y);
  var p2 = new jsPoint(x+30, y);
  var p3 = new jsPoint(x+20, y + 10);
  var p4 = new jsPoint(x+10, y + 10);
  gr.drawPolygon(pen,[p1,p2,p3,p4]);
}
function face_left(gr,pen,col,dente){
  x = qual_coluna(dente);
  y = qual_linha(dente);
  var p1 = new jsPoint(x, y);
  var p2 = new jsPoint(x+10, y + 10);
  var p3 = new jsPoint(x+10, y + 20);
  var p4 = new jsPoint(x, y + 30);
  gr.drawPolygon(pen,[p1,p2,p3,p4]);
}
function face_bottom(gr,pen,col,dente){
  x = qual_coluna(dente);
  y = qual_linha(dente);
  var p1 = new jsPoint(x, y + 30);
  var p2 = new jsPoint(x+10, y + 20);
  var p3 = new jsPoint(x+20, y + 20);
  var p4 = new jsPoint(x+30, y + 30);
  gr.drawPolygon(pen,[p1,p2,p3,p4]);
}
function face_right(gr,pen,col,dente){
  x = qual_coluna(dente);
  y = qual_linha(dente);
  var p1 = new jsPoint(x+30, y + 30);
  var p2 = new jsPoint(x+30, y);
  var p3 = new jsPoint(x+20, y + 10);
  var p4 = new jsPoint(x+20, y + 20);
  gr.drawPolygon(pen,[p1,p2,p3,p4]);
}

function qual_linha(dente){
  if (dente < 19){
    return 102;
  }else {
    return 152;
  }
}

function qual_coluna(dente){
  if (dente <= 18){
    return 40 + (dente * 40);
  }else {
    return 40 + ((dente - 18) * 40);
  }
}

function desenha_numero_dos_dentes(){
  saida = "<table border='0' class='transparente'>";
  saida = saida + "<tr>"
  for (ind = 1; ind < 4; ind = ind + 1){
    saida = saida + "<td>&nbsp;</td>"
  }
  for (ind = 55; ind > 50; ind = ind -1){
    saida = saida + "<td><a href='#' onClick='escolheu_dente(" + ind + ");' class='botao_dente'>" + ind + "</a>";
  }
  saida = saida + "<td> &nbsp; </td>";
  for (ind = 61; ind < 66; ind = ind + 1){
    saida = saida + "<td><a href='#' onClick='escolheu_dente(" + ind + ");' class='botao_dente'>" + ind + "</a>";
  }
  for (ind = 1; ind < 4; ind = ind + 1){
    saida = saida + "<td>&nbsp;</td>"
  }
  saida = saida  +"</tr>"
  for (ind=18; ind > 10; ind = ind - 1){
    saida = saida + "<td><a href='#' onClick='escolheu_dente(" + ind + ");' class='botao_dente'>" + ind + "</a>";
  }
  saida = saida + "<td> &nbsp; </td>";
  for (ind=21; ind < 29; ind = ind + 1){
    saida = saida + "<td><a href='#' onClick='escolheu_dente(" + ind + ");' class='botao_dente'>" + ind + "</a>";
  }
  saida = saida + "</tr><tr>";
  for (ind=38; ind > 30; ind = ind - 1){
    saida = saida + "<td><a href='#' onClick='escolheu_dente(" + ind + ");' class='botao_dente'>" + ind + "</a>";
  }
  saida = saida + "<td> &nbsp; </td>";
  for (ind=41; ind < 49; ind = ind + 1){
    saida = saida + "<td><a href='#' onClick='escolheu_dente(" + ind + ");' class='botao_dente'>" + ind + "</a>";
  }
  saida = saida + "</tr>"
  saida = saida + "<tr>"
  for (ind = 1; ind < 4; ind = ind + 1){
    saida = saida + "<td>&nbsp;</td>"
  }
  for (ind = 85; ind > 80; ind = ind -1){
    saida = saida + "<td><a href='#' onClick='escolheu_dente(" + ind + ");' class='botao_dente'>" + ind + "</a>";
  }
  saida = saida + "<td> &nbsp; </td>";
  for (ind = 71; ind < 76; ind = ind + 1){
    saida = saida + "<td><a href='#' onClick='escolheu_dente(" + ind + ");' class='botao_dente'>" + ind + "</a>";
  }
  for (ind = 1; ind < 4; ind = ind + 1){
    saida = saida + "<td>&nbsp;</td>"
  }

  "</table>";
  $("#numero_dos_dentes").html(saida);
}

function escolheu_dente(dente){
  anterior = $("#tratamento_dente").val();
  if (anterior == ''){
    $("#tratamento_dente").val(dente + ",");
  }else {
    $("#tratamento_dente").val(anterior + dente + ',');
  }
}