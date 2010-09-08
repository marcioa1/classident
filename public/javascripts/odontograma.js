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
  x = qual_coluna(dente)
  y = qual_linha(dente);
  var p1 = new jsPoint(x, y);
  var p2 = new jsPoint(x+30, y);
  var p3 = new jsPoint(x+20, y + 10);
  var p4 = new jsPoint(x+10, y + 10);
  gr.drawPolygon(pen,[p1,p2,p3,p4]);
}
function face_left(gr,pen,col,dente){
  x = qual_coluna(dente)
  y = qual_linha(dente);
  var p1 = new jsPoint(x, y);
  var p2 = new jsPoint(x+10, y + 10);
  var p3 = new jsPoint(x+10, y + 20);
  var p4 = new jsPoint(x, y + 30);
  gr.drawPolygon(pen,[p1,p2,p3,p4]);
}
function face_bottom(gr,pen,col,dente){
  x = qual_coluna(dente)
  y = qual_linha(dente);
  var p1 = new jsPoint(x, y + 30);
  var p2 = new jsPoint(x+10, y + 20);
  var p3 = new jsPoint(x+20, y + 20);
  var p4 = new jsPoint(x+30, y + 30);
  gr.drawPolygon(pen,[p1,p2,p3,p4]);
}
function face_right(gr,pen,col,dente){
  x = qual_coluna(dente)
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
    return 40 + (dente * 40)
  }else {
    return 40 + ((dente - 18) * 40)
  }
}