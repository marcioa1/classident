jQuery(function($){$.datepicker.regional['pt-BR']={clearText:'Limpar',clearStatus:'',closeText:'Fechar',closeStatus:'',prevText:'&#x3c;Anterior',prevStatus:'',prevBigText:'&#x3c;&#x3c;',prevBigStatus:'',nextText:'Pr&oacute;ximo&#x3e;',nextStatus:'',nextBigText:'&#x3e;&#x3e;',nextBigStatus:'',currentText:'Hoje',currentStatus:'',monthNames:['Janeiro','Fevereiro','Mar&ccedil;o','Abril','Maio','Junho','Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'],monthNamesShort:['Jan','Fev','Mar','Abr','Mai','Jun','Jul','Ago','Set','Out','Nov','Dez'],monthStatus:'',yearStatus:'',weekHeader:'Sm',weekStatus:'',dayNames:['Domingo','Segunda-feira','Ter&ccedil;a-feira','Quarta-feira','Quinta-feira','Sexta-feira','Sabado'],dayNamesShort:['Dom','Seg','Ter','Qua','Qui','Sex','Sab'],dayNamesMin:['Dom','Seg','Ter','Qua','Qui','Sex','Sab'],dayStatus:'DD',dateStatus:'D, M d',dateFormat:'dd/mm/yy',firstDay:0,initStatus:'',isRTL:false};$.datepicker.setDefaults($.datepicker.regional['pt-BR']);});;(function($){$.fn.addOption=function()
{var add=function(el,v,t,sO)
{var option=document.createElement("option");option.value=v,option.text=t;var o=el.options;var oL=o.length;if(!el.cache)
{el.cache={};for(var i=0;i<oL;i++)
{el.cache[o[i].value]=i;}}
if(typeof el.cache[v]=="undefined")el.cache[v]=oL;el.options[el.cache[v]]=option;if(sO)
{option.selected=true;}};var a=arguments;if(a.length==0)return this;var sO=true;var m=false;var items,v,t;if(typeof(a[0])=="object")
{m=true;items=a[0];}
if(a.length>=2)
{if(typeof(a[1])=="boolean")sO=a[1];else if(typeof(a[2])=="boolean")sO=a[2];if(!m)
{v=a[0];t=a[1];}}
this.each(function()
{if(this.nodeName.toLowerCase()!="select")return;if(m)
{for(var item in items)
{add(this,item,items[item],sO);}}
else
{add(this,v,t,sO);}});return this;};$.fn.ajaxAddOption=function(url,params,select,fn,args)
{if(typeof(url)!="string")return this;if(typeof(params)!="object")params={};if(typeof(select)!="boolean")select=true;this.each(function()
{var el=this;$.getJSON(url,params,function(r)
{$(el).addOption(r,select);if(typeof fn=="function")
{if(typeof args=="object")
{fn.apply(el,args);}
else
{fn.call(el);}}});});return this;};$.fn.removeOption=function()
{var a=arguments;if(a.length==0)return this;var ta=typeof(a[0]);var v,index;if(ta=="string"||ta=="object"||ta=="function")
{v=a[0];if(v.constructor==Array)
{var l=v.length;for(var i=0;i<l;i++)
{this.removeOption(v[i],a[1]);}
return this;}}
else if(ta=="number")index=a[0];else return this;this.each(function()
{if(this.nodeName.toLowerCase()!="select")return;if(this.cache)this.cache=null;var remove=false;var o=this.options;if(!!v)
{var oL=o.length;for(var i=oL-1;i>=0;i--)
{if(v.constructor==RegExp)
{if(o[i].value.match(v))
{remove=true;}}
else if(o[i].value==v)
{remove=true;}
if(remove&&a[1]===true)remove=o[i].selected;if(remove)
{o[i]=null;}
remove=false;}}
else
{if(a[1]===true)
{remove=o[index].selected;}
else
{remove=true;}
if(remove)
{this.remove(index);}}});return this;};$.fn.sortOptions=function(ascending)
{var sel=$(this).selectedValues();var a=typeof(ascending)=="undefined"?true:!!ascending;this.each(function()
{if(this.nodeName.toLowerCase()!="select")return;var o=this.options;var oL=o.length;var sA=[];for(var i=0;i<oL;i++)
{sA[i]={v:o[i].value,t:o[i].text}}
sA.sort(function(o1,o2)
{o1t=o1.t.toLowerCase(),o2t=o2.t.toLowerCase();if(o1t==o2t)return 0;if(a)
{return o1t<o2t?-1:1;}
else
{return o1t>o2t?-1:1;}});for(var i=0;i<oL;i++)
{o[i].text=sA[i].t;o[i].value=sA[i].v;}}).selectOptions(sel,true);return this;};$.fn.selectOptions=function(value,clear)
{var v=value;var vT=typeof(value);if(vT=="object"&&v.constructor==Array)
{var $this=this;$.each(v,function()
{$this.selectOptions(this,clear);});};var c=clear||false;if(vT!="string"&&vT!="function"&&vT!="object")return this;this.each(function()
{if(this.nodeName.toLowerCase()!="select")return this;var o=this.options;var oL=o.length;for(var i=0;i<oL;i++)
{if(v.constructor==RegExp)
{if(o[i].value.match(v))
{o[i].selected=true;}
else if(c)
{o[i].selected=false;}}
else
{if(o[i].value==v)
{o[i].selected=true;}
else if(c)
{o[i].selected=false;}}}});return this;};$.fn.copyOptions=function(to,which)
{var w=which||"selected";if($(to).size()==0)return this;this.each(function()
{if(this.nodeName.toLowerCase()!="select")return this;var o=this.options;var oL=o.length;for(var i=0;i<oL;i++)
{if(w=="all"||(w=="selected"&&o[i].selected))
{$(to).addOption(o[i].value,o[i].text);}}});return this;};$.fn.containsOption=function(value,fn)
{var found=false;var v=value;var vT=typeof(v);var fT=typeof(fn);if(vT!="string"&&vT!="function"&&vT!="object")return fT=="function"?this:found;this.each(function()
{if(this.nodeName.toLowerCase()!="select")return this;if(found&&fT!="function")return false;var o=this.options;var oL=o.length;for(var i=0;i<oL;i++)
{if(v.constructor==RegExp)
{if(o[i].value.match(v))
{found=true;if(fT=="function")fn.call(o[i],i);}}
else
{if(o[i].value==v)
{found=true;if(fT=="function")fn.call(o[i],i);}}}});return fT=="function"?this:found;};$.fn.selectedValues=function()
{var v=[];this.selectedOptions().each(function()
{v[v.length]=this.value;});return v;};$.fn.selectedTexts=function()
{var t=[];this.selectedOptions().each(function()
{t[t.length]=this.text;});return t;};$.fn.selectedOptions=function()
{return this.find("option:selected");};})(jQuery);(function($){$().ajaxSend(function(a,xhr,s){xhr.setRequestHeader("Accept","text/javascript, text/html, application/xml, text/xml, */*")})})(jQuery);(function($){$.fn.reset=function(){return this.each(function(){if(typeof this.reset=="function"||(typeof this.reset=="object"&&!this.reset.nodeType)){this.reset()}})};$.fn.enable=function(){return this.each(function(){this.disabled=false})};$.fn.disable=function(){return this.each(function(){this.disabled=true})}})(jQuery);(function($){$.extend({fieldEvent:function(el,obs){var field=el[0]||el,e="change";if(field.type=="radio"||field.type=="checkbox"){e="click"}else{if(obs&&field.type=="text"||field.type=="textarea"){e="keyup"}}return e}});$.fn.extend({delayedObserver:function(delay,callback){var el=$(this);if(typeof window.delayedObserverStack=="undefined"){window.delayedObserverStack=[]}if(typeof window.delayedObserverCallback=="undefined"){window.delayedObserverCallback=function(stackPos){observed=window.delayedObserverStack[stackPos];if(observed.timer){clearTimeout(observed.timer)}observed.timer=setTimeout(function(){observed.timer=null;observed.callback(observed.obj,observed.obj.formVal())},observed.delay*1000);observed.oldVal=observed.obj.formVal()}}window.delayedObserverStack.push({obj:el,timer:null,delay:delay,oldVal:el.formVal(),callback:callback});var stackPos=window.delayedObserverStack.length-1;if(el[0].tagName=="FORM"){$(":input",el).each(function(){var field=$(this);field.bind($.fieldEvent(field,delay),function(){observed=window.delayedObserverStack[stackPos];if(observed.obj.formVal()==observed.obj.oldVal){return}else{window.delayedObserverCallback(stackPos)}})})}else{el.bind($.fieldEvent(el,delay),function(){observed=window.delayedObserverStack[stackPos];if(observed.obj.formVal()==observed.obj.oldVal){return}else{window.delayedObserverCallback(stackPos)}})}},formVal:function(){var el=this[0];if(el.tagName=="FORM"){return this.serialize()}if(el.type=="checkbox"||self.type=="radio"){return this.filter("input:checked").val()||""}else{return this.val()}}})})(jQuery);(function($){$.fn.extend({visualEffect:function(o){e=o.replace(/\_(.)/g,function(m,l){return l.toUpperCase()});return eval("$(this)."+e+"()")},appear:function(speed,callback){return this.fadeIn(speed,callback)},blindDown:function(speed,callback){return this.show("blind",{direction:"vertical"},speed,callback)},blindUp:function(speed,callback){return this.hide("blind",{direction:"vertical"},speed,callback)},blindRight:function(speed,callback){return this.show("blind",{direction:"horizontal"},speed,callback)},blindLeft:function(speed,callback){this.hide("blind",{direction:"horizontal"},speed,callback);return this},dropOut:function(speed,callback){return this.hide("drop",{direction:"down"},speed,callback)},dropIn:function(speed,callback){return this.show("drop",{direction:"up"},speed,callback)},fade:function(speed,callback){return this.fadeOut(speed,callback)},fadeToggle:function(speed,callback){return this.animate({opacity:"toggle"},speed,callback)},fold:function(speed,callback){return this.hide("fold",{},speed,callback)},foldOut:function(speed,callback){return this.show("fold",{},speed,callback)},grow:function(speed,callback){return this.show("scale",{},speed,callback)},highlight:function(speed,callback){return this.show("highlight",{},speed,callback)},puff:function(speed,callback){return this.hide("puff",{},speed,callback)},pulsate:function(speed,callback){return this.show("pulsate",{},speed,callback)},shake:function(speed,callback){return this.show("shake",{},speed,callback)},shrink:function(speed,callback){return this.hide("scale",{},speed,callback)},squish:function(speed,callback){return this.hide("scale",{origin:["top","left"]},speed,callback)},slideUp:function(speed,callback){return this.hide("slide",{direction:"up"},speed,callback)},slideDown:function(speed,callback){return this.show("slide",{direction:"up"},speed,callback)},switchOff:function(speed,callback){return this.hide("clip",{},speed,callback)},switchOn:function(speed,callback){return this.show("clip",{},speed,callback)}})})(jQuery);(function($){$.fn.priceFormat=function(options){var defaults={prefix:'US$ ',centsSeparator:'.',thousandsSeparator:','};var options=$.extend(defaults,options);return this.each(function(){var obj=$(this);function price_format(){var prefix=options.prefix;var centsSeparator=options.centsSeparator;var thousandsSeparator=options.thousandsSeparator;var formatted='';var thousandsFormatted='';var str=obj.val();var isNumber=/[0-9]/;for(var i=0;i<(str.length);i++){char=str.substr(i,1);if(formatted.length==0&&char==0)char=false;if(char&&char.match(isNumber))formatted=formatted+char;}
while(formatted.length<3)formatted='0'+formatted;var centsVal=formatted.substr(formatted.length-2,2);var integerVal=formatted.substr(0,formatted.length-2);formatted=integerVal+centsSeparator+centsVal;if(thousandsSeparator){var thousandsCount=0;for(var j=integerVal.length;j>0;j--){char=integerVal.substr(j-1,1);thousandsCount++;if(thousandsCount%3==0)char=thousandsSeparator+char;thousandsFormatted=char+thousandsFormatted;}
if(thousandsFormatted.substr(0,1)==thousandsSeparator)thousandsFormatted=thousandsFormatted.substring(1,thousandsFormatted.length);formatted=thousandsFormatted+centsSeparator+centsVal;}
if(prefix)formatted=prefix+formatted;obj.val(formatted);}
$(this).bind('keyup',price_format);if($(this).val().length>0)price_format();});};})(jQuery);;(function($){var L=$.loading=function(show,opts){return $('body').loading(show,opts,true);};$.fn.loading=function(show,opts,page){opts=toOpts(show,opts);var base=page?$.extend(true,{},L,L.pageOptions):L;return this.each(function(){var $el=$(this),l=$.extend(true,{},base,$.metadata?$el.metadata():null,opts);if(typeof l.onAjax=="boolean"){L.setAjax.call($el,l);}else{L.toggle.call($el,l);}});};var fixed={position:$.browser.msie?'absolute':'fixed'};$.extend(L,{version:"1.6.4",align:'top-left',pulse:'working error',mask:false,img:null,element:null,text:'Loading...',onAjax:undefined,delay:0,max:0,classname:'loading',imgClass:'loading-img',elementClass:'loading-element',maskClass:'loading-mask',css:{position:'absolute',whiteSpace:'nowrap',zIndex:1001},maskCss:{position:'absolute',opacity:.15,background:'#333',zIndex:101,display:'block',cursor:'wait'},cloneEvents:true,pageOptions:{page:true,align:'top-center',css:fixed,maskCss:fixed},html:'<div></div>',maskHtml:'<div></div>',maskedClass:'loading-masked',maskEvents:'mousedown mouseup keydown keypress',resizeEvents:'resize',working:{time:10000,text:'Still working...',run:function(l){var w=l.working,self=this;w.timeout=setTimeout(function(){self.height('auto').width('auto').text(l.text=w.text);l.place.call(self,l);},w.time);}},error:{time:100000,text:'Task may have failed...',classname:'loading-error',run:function(l){var e=l.error,self=this;e.timeout=setTimeout(function(){self.height('auto').width('auto').text(l.text=e.text).addClass(e.classname);l.place.call(self,l);},e.time);}},fade:{time:800,speed:'slow',run:function(l){var f=l.fade,s=f.speed,self=this;f.interval=setInterval(function(){self.fadeOut(s).fadeIn(s);},f.time);}},ellipsis:{time:300,run:function(l){var e=l.ellipsis,self=this;e.interval=setInterval(function(){var et=self.text(),t=l.text,i=dotIndex(t);self.text((et.length-i)<3?et+'.':t.substring(0,i));},e.time);function dotIndex(t){var x=t.indexOf('.');return x<0?t.length:x;}}},type:{time:100,run:function(l){var t=l.type,self=this;t.interval=setInterval(function(){var e=self.text(),el=e.length,txt=l.text;self.text(el==txt.length?txt.charAt(0):txt.substring(0,el+1));},t.time);}},toggle:function(l){var old=this.data('loading');if(old){if(l.show!==true)old.off.call(this,old,l);}else{if(l.show!==false)l.on.call(this,l);}},setAjax:function(l){if(l.onAjax){var self=this,count=0,A=l.ajax={start:function(){if(!count++)l.on.call(self,l);},stop:function(){if(!--count)l.off.call(self,l,l);}};this.bind('ajaxStart.loading',A.start).bind('ajaxStop.loading',A.stop);}else{this.unbind('ajaxStart.loading ajaxStop.loading');}},on:function(l,force){var p=l.parent=this.data('loading',l);if(l.max)l.maxout=setTimeout(function(){l.off.call(p,l,l);},l.max);if(l.delay&&!force){return l.timeout=setTimeout(function(){delete l.timeout;l.on.call(p,l,true);},l.delay);}
if(l.mask)l.mask=l.createMask.call(p,l);l.display=l.create.call(p,l);if(l.img){l.initImg.call(p,l);}else if(l.element){l.initElement.call(p,l);}else{l.init.call(p,l);}
p.trigger('loadingStart',[l]);},initImg:function(l){var self=this;l.imgElement=$('<img src="'+l.img+'"/>').bind('load',function(){l.init.call(self,l);});l.display.addClass(l.imgClass).append(l.imgElement);},initElement:function(l){l.element=$(l.element).clone(l.cloneEvents).show();l.display.addClass(l.elementClass).append(l.element);l.init.call(this,l);},init:function(l){l.place.call(l.display,l);if(l.pulse)l.initPulse.call(this,l);},initPulse:function(l){$.each(l.pulse.split(' '),function(){l[this].run.call(l.display,l);});},create:function(l){var el=$(l.html).addClass(l.classname).css(l.css).appendTo(this);if(l.text&&!l.img&&!l.element)el.text(l.originalText=l.text);$(window).bind(l.resizeEvents,l.resizer=function(){l.resize(l);});return el;},resize:function(l){l.parent.box=null;if(l.mask)l.mask.hide();l.place.call(l.display.hide(),l);if(l.mask)l.mask.show().css(l.parent.box);},createMask:function(l){var box=l.measure.call(this.addClass(l.maskedClass),l);l.handler=function(e){return l.maskHandler(e,l);};$(document).bind(l.maskEvents,l.handler);return $(l.maskHtml).addClass(l.maskClass).css(box).css(l.maskCss).appendTo(this);},maskHandler:function(e,l){var $els=$(e.target).parents().andSelf();if($els.filter('.'+l.classname).length!=0)return true;return!l.page&&$els.filter('.'+l.maskedClass).length==0;},place:function(l){var box=l.align,v='top',h='left';if(typeof box=="object"){box=$.extend(l.calc.call(this,v,h,l),box);}else{if(box!='top-left'){var s=box.split('-');if(s.length==1){v=h=s[0];}else{v=s[0];h=s[1];}}
if(!this.hasClass(v))this.addClass(v);if(!this.hasClass(h))this.addClass(h);box=l.calc.call(this,v,h,l);}
this.show().css(l.box=box);},calc:function(v,h,l){var box=$.extend({},l.measure.call(l.parent,l)),H=$.boxModel?this.height():this.innerHeight(),W=$.boxModel?this.width():this.innerWidth();if(v!='top'){var d=box.height-H;if(v=='center'){d/=2;}else if(v!='bottom'){d=0;}else if($.boxModel){d-=css(this,'paddingTop')+css(this,'paddingBottom');}
box.top+=d;}
if(h!='left'){var d=box.width-W;if(h=='center'){d/=2;}else if(h!='right'){d=0;}else if($.boxModel){d-=css(this,'paddingLeft')+css(this,'paddingRight');}
box.left+=d;}
box.height=H;box.width=W;return box;},measure:function(l){return this.box||(this.box=l.page?l.pageBox(l):l.elementBox(this,l));},elementBox:function(e,l){if(e.css('position')=='absolute'){var box={top:0,left:0};}else{var box=e.position();box.top+=css(e,'marginTop');box.left+=css(e,'marginLeft');}
box.height=e.outerHeight();box.width=e.outerWidth();return box;},pageBox:function(l){var full=$.boxModel&&l.css.position!='fixed';return{top:0,left:0,height:get(full,'Height'),width:get(full,'Width')};function get(full,side){var doc=document;if(full){var s=side.toLowerCase(),d=$(doc)[s](),w=$(window)[s]();return d-css($(doc.body),'marginTop')>w?d:w;}
var c='client'+side;return Math.max(doc.documentElement[c],doc.body[c]);}},off:function(old,l){this.data('loading',null);if(old.maxout)clearTimeout(old.maxout);if(old.timeout)return clearTimeout(old.timeout);if(old.pulse)old.stopPulse.call(this,old,l);if(old.originalText)old.text=old.originalText;if(old.mask)old.stopMask.call(this,old,l);$(window).unbind(old.resizeEvents,old.resizer);if(old.display)old.display.remove();if(old.parent)old.parent.trigger('loadingEnd',[old]);},stopPulse:function(old,l){$.each(old.pulse.split(' '),function(){var p=old[this];if(p.end)p.end.call(l.display,old,l);if(p.interval)clearInterval(p.interval);if(p.timeout)clearTimeout(p.timeout);});},stopMask:function(old,l){this.removeClass(l.maskedClass);$(document).unbind(old.maskEvents,old.handler);old.mask.remove();}});function toOpts(s,l){if(l===undefined){l=(typeof s=="boolean")?{show:s}:s;}else{l.show=s;}
if(l&&(l.img||l.element)&&!l.pulse)l.pulse=false;if(l&&l.onAjax!==undefined&&l.show===undefined)l.show=false;return l;}
function css(el,prop){var val=el.css(prop);return val=='auto'?0:parseFloat(val,10);}})(jQuery);jQuery(function(){$('input[type="text"].first').focus();$("#tabs").tabs();$("#datepicker").datepicker();$("#datepicker2").datepicker();$("#datepicker3").datepicker();$("#datepicker4").datepicker();$("#datepicker5").datepicker();$("#datepicker6").datepicker();$(".datepicker").datepicker();});function outra_clinica(){$("#seleciona_clinica").show();};function conta_caracteres(){if($("#nome").val().length>2){$("#pesquisar_button").attr('disabled',false);}else{$("#pesquisar_button").attr('disabled',true);}}
function selecionou_item_tabela(item_id){$.getJSON('/item_tabelas/busca_descricao',{'id':item_id},function(data){resultado=data.split(";");$("#tratamento_descricao").val(resultado[0]);$("#iniciais").val(resultado[0]);$("#tratamento_valor_pt").val(resultado[1]);$("#tratamento_dentista_id").focus();});}
function selecionou_forma(element){if($("#"+element).selectedOptions().text().toLowerCase()=="cheque"){$("#cheque").show();}else{$("#cheque").hide();}}
function alterou_data_tratamento(){data=$("#datepicker").datepicker('getDate');if(data==null){$("#tratamento_data_3i").selectOptions("");$("#tratamento_data_2i").selectOptions("");$("#tratamento_data_1i").selectOptions("");}else{dia=data.getDate();mes=data.getMonth()+1;ano=data.getFullYear();$("#tratamento_data_3i").selectOptions(dia+"");$("#tratamento_data_2i").selectOptions(mes+"");$("#tratamento_data_1i").selectOptions(ano+"");}}
function alterou_data_cadastro(){data=$("#datepicker").datepicker('getDate');if(data==null){$("#paciente_nascimento_3i").selectOptions("");$("#paciente_nascimento_2i").selectOptions("");$("#paciente_nascimento_1i").selectOptions("");}else{dia=data.getDate();mes=data.getMonth()+1;ano=data.getFullYear();$("#paciente_nascimento_3i").selectOptions(dia+"");$("#paciente_nascimento_2i").selectOptions(mes+"");$("#paciente_nascimento_1i").selectOptions(ano+"");}}
function copia_valor(){$("#valor_do_cheque").val($("#recebimento_valor_real").val());}
function abre_uma_devolucao(){$("#devolvido_uma_vez").toggle('blind',{percent:0},500);}
function abre_reapresentacao(){$("#reapresentado").toggle('blind',{percent:0},500);}
function abre_segunda_devolucao(){$("#devolvido_duas_vezes").toggle('blind',{percent:0},500);}
function enviar_administracao(){var selecionados="";var chk=$('input:checkbox');for(var i=0;i<chk.length;i++){var item=chk[i].id;if($("#"+item).is(':checked')){selecionados+=item+",";}}
$.getJSON("recebe_cheques",{cheques:selecionados},function(data){$("form:last").trigger("submit");});}
function selecionar(){if($("#selecao").text()=="todos"){$("#selecao").text("nenhum");$("#tipo_pagamento_id").each(function(){$("#tipo_pagamento_id option").attr("selected","selected");});}else{$("#selecao").text("todos");$("#tipo_pagamento_id").each(function(){$("#tipo_pagamento_id option").removeAttr("selected");});}}
function abre_cheque(id){window.open("/cheques/"+id,"abriu o cheque","height=260,width=480,status=no");}
function abre_pagamento(id){window.open("/pagamentos/"+id,"abre o pagamento","height=600,width=600,status=no,resizable=yes,scrollbars=yes");}
function pesquisa_disponiveis(){jQuery.ajax({url:"/cheques/busca_disponiveis",type:'GET',data:{valor:$("#pagamento_valor_pago_real").val()},success:function(data){$("#lista_de_cheques").replaceWith("<span id='lista_de_cheques'>"+data+"</span>");}});}
function formata_valor(elemento){elemento.priceFormat({prefix:"",centsSeparator:",",thousandsSeparator:"."});}
function seleciona_todas_as_formas_de_recebimento(){if($('#todas').is(':checked')){$("input[name*='forma']").attr('checked',true);}else{$("input[name*='forma']").attr('checked',false);}}
jQuery(function(){$.loading({onAjax:true,text:'Carregando ...',align:'center',mask:true});});function confirma_recebimento_de_cheque(){var selecionados="";var chk=$('input:checkbox');for(var i=0;i<chk.length;i++){var item=chk[i].id;if($("#"+item).is(':checked')){selecionados+=item+",";}}
$.ajax({url:"registra_recebimento_de_cheques",data:{cheques:selecionados},success:function(data){alert("cheques recebidos com sucesso.");$("form:last").trigger("submit");},error:function(data){alert("Cheques não foram registrados corretamente.");}});}
function pagar(valor,id,id_protetico){anterior=$('#valor').text();valor_total=parseFloat(anterior);if($("#pagar_"+id).is(':checked')==true)
valor_total=valor_total+valor;else
valor_total=valor_total-valor;$('#valor').text(valor_total);var checkeds=$(":checkbox[name|='pagar']:checked");var ids='';for(id=0;id<checkeds.size();id++){ids=ids+','+checkeds[id].value;}
if(ids.length>1){ids=ids.substring(1);}
var link="<span id='link_pagamento'><a href='/pagamentos/new?valor="+
valor_total+"&trabalho_protetico_id="+ids+"&protetico_id="+id_protetico+"'>efetua pagamento</a></span>";$('#link_pagamento').replaceWith(link);}
function pagar_dentista(valor,tratamento_id,dentista_id){anterior=$('#valor').text();valor_total=parseFloat(anterior);if($("#pagar_dentista_"+tratamento_id).is(':checked')==true)
valor_total=valor_total+valor;else
valor_total=valor_total-valor;$('#valor').text(valor_total);var link="<span id='link_pagamento'><a href='/pagamentos/new?valor="+
valor_total+"&dentista_id="+dentista_id+"'>efetua pagamento</a></span>";$('#link_pagamento').replaceWith(link);}
function pagamento_dentista(dentista_id){var clinicas=$("#fragment-3 input:checkbox");$.ajax({url:'pagamento',data:{inicio:$("#datepicker3").val(),fim:$("#datepicker4").val(),dentista_id:dentista_id},success:function(data){$("#lista_pagamento").replaceWith(data);}});}
function registra_confirmacao_de_entrada(){entradas=$('input:checked');id_str='';$.each(entradas,function(index,value){aux=((value.id).split('_'));id_str+=aux[1]+',';});jQuery.ajax({url:"/entradas/registra_confirmacao_de_entrada",type:'POST',data:{data:id_str},success:function(data){$('input:submit').click();}});}
function busca_proteticos_da_clinica(){$.ajax({url:"/proteticos/busca_proteticos_da_clinica",type:"GET",data:{"clinica_id":$('#clinica').val()},success:function(result){$("#protetico").html("");for(var i=0;i<result.length;i++){$("#protetico").append(new Option(result[i],result[i]));}}});}
function pagamento_protetico(){var selecionados=$("input:checked");id_str='';valor_a_pagar=0;$.each(selecionados,function(index,value){aux=((value.id).split('_'));id_str+=aux[2]+',';valor_a_pagar+=parseFloat($('#valor_'+aux[2]).html());});var protetico_id=$("#protetico_id").val();var url="http://"+window.location.host+"/pagamentos/registra_pagamento_a_protetico"+"?ids='"+id_str+"'&valores='"+valor_a_pagar+"' &protetico_id="+protetico_id;window.location=url;}
function busca_saldo(){$("#data").replaceWith("<span id='data'></span>");$("#saldo_em_dinheiro").val("");$("#saldo_em_cheque").val("");$.ajax({url:"/busca_saldo",type:"GET",data:{"clinica":$("#clinica").val()},success:function(result){var array=result.split(";");$("#data").replaceWith(array[0]);$("#saldo_em_dinheiro").val(array[1]);$("#saldo_em_cheque").val(array[2]);}});}
function limpa_nome(){$("#nome").val('');}
function limpa_codigo(){$("#codigo").val('');}
function selecionou_cheque(elemento){var total_de_cheques=0.0;var todos=$("#lista_de_cheques :checked");var selecionados="";for(var i=0;i<todos.length;i++){id_cheque=(todos[i].id).split("_")[1];selecionados+=id_cheque+",";var valor=$("#valor_"+id_cheque).text();valor=valor.replace(".","");valor=parseFloat(valor.replace(",","."));total_de_cheques+=valor;}
$("#cheques_ids").val(selecionados);var total_a_pagar=$("#pagamento_valor_pago_real").val();console.log(total_a_pagar);if(total_a_pagar<total_de_cheques){alert("A soma dos valores dos cheques selecionados é maior que o valor do pagamento.");}
$("#pagamento_valor_restante").val(parseInt((total_a_pagar-total_de_cheques)*100));formata_valor($("#pagamento_valor_restante"));}
function producao(){var clinicas=$("#fragment-2 input:checkbox");var selecionadas='';for(var i=0;i<clinicas.length;i++){if($("#"+clinicas[i].id).is(':checked')){selecionadas+=$("#"+clinicas[i].id).val()+",";}}
$.ajax({url:"producao",data:{datepicker:$("#datepicker").val(),datepicker2:$("#datepicker2").val(),clinicas:selecionadas},success:function(data){$("#lista").replaceWith(data);}});}
function cheque(mostra){if(mostra==1){$("#cheque_classident").show();$("#pagamento_conta_bancaria_id").focus();$("#pagamento_valor_cheque").val($("#pagamento_valor_restante").val());}else{$("#cheque_classident").hide();$("#pagamento_numero_do_cheque").val("");$("#pagamento_valor_cheque").val("");}}
function selecionou_estado(){$(':checkbox').attr('checked',false);}
function busca_pacientes_que_iniciam_com(text_field){$("#linha_"+text_field).show();$.getJSON('/pacientes/nomes_que_iniciam_com?nome='+$("#"+text_field).val()+'&div='+text_field,function(data){$("#nomes_"+text_field).replaceWith('<div id="nomes_'+text_field+'"  class="lista">'+data+'</div>');});}
function escolheu_nome_da_lista(nome,div,id){$("#"+div).val(nome);$("#id_"+div).val(id);$("#linha_"+div).hide();}
function selecionou_face(){$('#tratamento_estado_nenhum').attr('checked',true);}
function todas_as_faces(){selecionou_face();$(':checkbox').attr('checked',$('#todas').is(':checked'));}
function selecionou_tratamento(){var todos=$("td :checked");var total=0.0;ids_selecionados='';for(i=0;i<todos.length-1;i++){total=total+parseFloat(todos[i].value);ids_selecionados+=todos[i].id+',';}
$("#tratamento_ids").val(ids_selecionados);$('#orcamento_valor_pt').val(total*100);formata_valor($('#orcamento_valor_pt'));}
function calcula_valor_orcamento(){total=parseFloat($('#orcamento_valor_pt').val());desconto=parseFloat($('#orcamento_desconto').val());valor_do_desconto=(total-(total*desconto/100))*100;$('#orcamento_valor_com_desconto_pt').val(valor_do_desconto);formata_valor($('#orcamento_valor_com_desconto_pt'));calcula_valor_da_parcela();}
function calcula_valor_da_parcela(){valor_com_desconto=$('#orcamento_valor_com_desconto_pt').val().replace(',','.');valor=parseFloat(valor_com_desconto);numero=$('#orcamento_numero_de_parcelas').val();valor_da_parcela=parseInt((valor/numero)*100)/100;$('#orcamento_valor_da_parcela_pt').val(valor_da_parcela*100);formata_valor($('#orcamento_valor_da_parcela_pt'));$.ajax({url:'/orcamentos/monta_tabela_de_parcelas',type:'GET',data:{numero_de_parcelas:numero,valor_da_parcela:valor,data_primeira_parcela:$('#orcamento_vencimento_primeira_parcela').val()},success:function(data){$('#parcelas').replaceWith(data);}});}
function definir_valor(){if($('#acima_de_um_valor').is(':checked')){$('#valor').focus();}else{$('#valor').val('');}}
function orcamento_dentista(){var clinicas=$("#fragment-4 input:checkbox");var selecionadas='';for(var i=0;i<clinicas.length;i++){if($("#"+clinicas[i].id).is(':checked')){selecionadas+=$("#"+clinicas[i].id).val()+",";}}
$.ajax({url:"orcamentos",data:{inicio:$("#datepicker5").val(),fim:$("#datepicker6").val(),clinicas:selecionadas},success:function(data){$("#lista_orcamento").replaceWith(data);}});}
function finalizar_tratamento(tratamento_id){$.ajax({url:'/tratamentos/'+tratamento_id+'/finalizar_procedimento',success:function(data){$("#finalizar_"+tratamento_id+" a").replaceWith(hoje);$("#extrato_table").replaceWith(data);},error:function(objRequest,textStatus){alert(textStatus);}});}
function hoje(){hoje=new Date();dia=hoje.getDate();mes=hoje.getMonth();ano=hoje.getFullYear();if(dia<10)
dia="0"+dia;mes=mes+1;if(mes<9)
mes="0"+mes;if(ano<2000)
ano="19"+ano;return dia+"/"+(mes)+"/"+ano;}
function busca_id(numero){$.ajax({url:"/pacientes/busca_id_do_paciente",type:'GET',data:{nome:$('#paciente_'+numero).val()},success:function(data){$('#paciente_id_'+numero).val(data);}});}
function valida_senha(){var senha_digitada=$('#nova_senha').val();var controller=$('#controller').html();var action=$('#action').html();$.ajax({url:"/valida_senha",type:'GET',data:{controller_name:controller,action_name:action,senha_digitada:senha_digitada},success:function(data){if(data==true){$("#corpo").toggle('slow');$("#corpo_senha").hide();}else{alert("senha inválida.");}}});}
function busca_usuarios(){$.ajax({url:"/clinicas/usuarios_da_clinica",type:'GET',data:{clinica_id:$("#clinica_monitor_id").val()},success:function(data){$("#user_monitor_id").html("");for(var i=0;i<data.length;i++){$("#user_monitor_id").append(new Option(data[i][1],data[i][0]));}}});}
function imprime_extrato(paciente_id,clinica_id){$.ajax({url:"/pacientes/"+paciente_id+"/extrato_pdf",type:"GET",success:function(data){window.open("http://"+location.host+"/relatorios/extrato_"+clinica_id+".pdf");},error:function(){alert("Não foi possível gerar o relatório.");}});}
function imprime_orcamento(orcamento_id,clinica_id){$.ajax({url:"/orcamentos/"+orcamento_id+"/imprime",data:{clinica_id:clinica_id},type:"GET",success:function(data){window.open("http://"+location.host+"/relatorios/orcamento_"+clinica_id+".pdf");},error:function(){alert("Não foi possível gerar o relatório.");}});}
function gera_pdf(dados){$.ajax({url:"/gera_pdf",data:{tabela:dados},type:"POST",success:function(data){window.open("http://"+location.host+"/relatorios/relatorio.pdf");},error:function(){alert("Não foi possível gerar o relatório.");}});}
(function($){$.extend({tablesorter:new function(){var parsers=[],widgets=[];this.defaults={cssHeader:"header",cssAsc:"headerSortUp",cssDesc:"headerSortDown",sortInitialOrder:"asc",sortMultiSortKey:"shiftKey",sortForce:null,sortAppend:null,textExtraction:"simple",parsers:{},widgets:[],widgetZebra:{css:["even","odd"]},headers:{},widthFixed:false,cancelSelection:true,sortList:[],headerList:[],dateFormat:"us",decimal:'.',debug:false};function benchmark(s,d){log(s+","+(new Date().getTime()-d.getTime())+"ms");}this.benchmark=benchmark;function log(s){if(typeof console!="undefined"&&typeof console.debug!="undefined"){console.log(s);}else{alert(s);}}function buildParserCache(table,$headers){if(table.config.debug){var parsersDebug="";}var rows=table.tBodies[0].rows;if(table.tBodies[0].rows[0]){var list=[],cells=rows[0].cells,l=cells.length;for(var i=0;i<l;i++){var p=false;if($.metadata&&($($headers[i]).metadata()&&$($headers[i]).metadata().sorter)){p=getParserById($($headers[i]).metadata().sorter);}else if((table.config.headers[i]&&table.config.headers[i].sorter)){p=getParserById(table.config.headers[i].sorter);}if(!p){p=detectParserForColumn(table,cells[i]);}if(table.config.debug){parsersDebug+="column:"+i+" parser:"+p.id+"\n";}list.push(p);}}if(table.config.debug){log(parsersDebug);}return list;};function detectParserForColumn(table,node){var l=parsers.length;for(var i=1;i<l;i++){if(parsers[i].is($.trim(getElementText(table.config,node)),table,node)){return parsers[i];}}return parsers[0];}function getParserById(name){var l=parsers.length;for(var i=0;i<l;i++){if(parsers[i].id.toLowerCase()==name.toLowerCase()){return parsers[i];}}return false;}function buildCache(table){if(table.config.debug){var cacheTime=new Date();}var totalRows=(table.tBodies[0]&&table.tBodies[0].rows.length)||0,totalCells=(table.tBodies[0].rows[0]&&table.tBodies[0].rows[0].cells.length)||0,parsers=table.config.parsers,cache={row:[],normalized:[]};for(var i=0;i<totalRows;++i){var c=table.tBodies[0].rows[i],cols=[];cache.row.push($(c));for(var j=0;j<totalCells;++j){cols.push(parsers[j].format(getElementText(table.config,c.cells[j]),table,c.cells[j]));}cols.push(i);cache.normalized.push(cols);cols=null;};if(table.config.debug){benchmark("Building cache for "+totalRows+" rows:",cacheTime);}return cache;};function getElementText(config,node){if(!node)return"";var t="";if(config.textExtraction=="simple"){if(node.childNodes[0]&&node.childNodes[0].hasChildNodes()){t=node.childNodes[0].innerHTML;}else{t=node.innerHTML;}}else{if(typeof(config.textExtraction)=="function"){t=config.textExtraction(node);}else{t=$(node).text();}}return t;}function appendToTable(table,cache){if(table.config.debug){var appendTime=new Date()}var c=cache,r=c.row,n=c.normalized,totalRows=n.length,checkCell=(n[0].length-1),tableBody=$(table.tBodies[0]),rows=[];for(var i=0;i<totalRows;i++){rows.push(r[n[i][checkCell]]);if(!table.config.appender){var o=r[n[i][checkCell]];var l=o.length;for(var j=0;j<l;j++){tableBody[0].appendChild(o[j]);}}}if(table.config.appender){table.config.appender(table,rows);}rows=null;if(table.config.debug){benchmark("Rebuilt table:",appendTime);}applyWidget(table);setTimeout(function(){$(table).trigger("sortEnd");},0);};function buildHeaders(table){if(table.config.debug){var time=new Date();}var meta=($.metadata)?true:false,tableHeadersRows=[];for(var i=0;i<table.tHead.rows.length;i++){tableHeadersRows[i]=0;};$tableHeaders=$("thead th",table);$tableHeaders.each(function(index){this.count=0;this.column=index;this.order=formatSortingOrder(table.config.sortInitialOrder);if(checkHeaderMetadata(this)||checkHeaderOptions(table,index))this.sortDisabled=true;if(!this.sortDisabled){$(this).addClass(table.config.cssHeader);}table.config.headerList[index]=this;});if(table.config.debug){benchmark("Built headers:",time);log($tableHeaders);}return $tableHeaders;};function checkCellColSpan(table,rows,row){var arr=[],r=table.tHead.rows,c=r[row].cells;for(var i=0;i<c.length;i++){var cell=c[i];if(cell.colSpan>1){arr=arr.concat(checkCellColSpan(table,headerArr,row++));}else{if(table.tHead.length==1||(cell.rowSpan>1||!r[row+1])){arr.push(cell);}}}return arr;};function checkHeaderMetadata(cell){if(($.metadata)&&($(cell).metadata().sorter===false)){return true;};return false;}function checkHeaderOptions(table,i){if((table.config.headers[i])&&(table.config.headers[i].sorter===false)){return true;};return false;}function applyWidget(table){var c=table.config.widgets;var l=c.length;for(var i=0;i<l;i++){getWidgetById(c[i]).format(table);}}function getWidgetById(name){var l=widgets.length;for(var i=0;i<l;i++){if(widgets[i].id.toLowerCase()==name.toLowerCase()){return widgets[i];}}};function formatSortingOrder(v){if(typeof(v)!="Number"){i=(v.toLowerCase()=="desc")?1:0;}else{i=(v==(0||1))?v:0;}return i;}function isValueInArray(v,a){var l=a.length;for(var i=0;i<l;i++){if(a[i][0]==v){return true;}}return false;}function setHeadersCss(table,$headers,list,css){$headers.removeClass(css[0]).removeClass(css[1]);var h=[];$headers.each(function(offset){if(!this.sortDisabled){h[this.column]=$(this);}});var l=list.length;for(var i=0;i<l;i++){h[list[i][0]].addClass(css[list[i][1]]);}}function fixColumnWidth(table,$headers){var c=table.config;if(c.widthFixed){var colgroup=$('<colgroup>');$("tr:first td",table.tBodies[0]).each(function(){colgroup.append($('<col>').css('width',$(this).width()));});$(table).prepend(colgroup);};}function updateHeaderSortCount(table,sortList){var c=table.config,l=sortList.length;for(var i=0;i<l;i++){var s=sortList[i],o=c.headerList[s[0]];o.count=s[1];o.count++;}}function multisort(table,sortList,cache){if(table.config.debug){var sortTime=new Date();}var dynamicExp="var sortWrapper = function(a,b) {",l=sortList.length;for(var i=0;i<l;i++){var c=sortList[i][0];var order=sortList[i][1];var s=(getCachedSortType(table.config.parsers,c)=="text")?((order==0)?"sortText":"sortTextDesc"):((order==0)?"sortNumeric":"sortNumericDesc");var e="e"+i;dynamicExp+="var "+e+" = "+s+"(a["+c+"],b["+c+"]); ";dynamicExp+="if("+e+") { return "+e+"; } ";dynamicExp+="else { ";}var orgOrderCol=cache.normalized[0].length-1;dynamicExp+="return a["+orgOrderCol+"]-b["+orgOrderCol+"];";for(var i=0;i<l;i++){dynamicExp+="}; ";}dynamicExp+="return 0; ";dynamicExp+="}; ";eval(dynamicExp);cache.normalized.sort(sortWrapper);if(table.config.debug){benchmark("Sorting on "+sortList.toString()+" and dir "+order+" time:",sortTime);}return cache;};function sortText(a,b){return((a<b)?-1:((a>b)?1:0));};function sortTextDesc(a,b){return((b<a)?-1:((b>a)?1:0));};function sortNumeric(a,b){return a-b;};function sortNumericDesc(a,b){return b-a;};function getCachedSortType(parsers,i){return parsers[i].type;};this.construct=function(settings){return this.each(function(){if(!this.tHead||!this.tBodies)return;var $this,$document,$headers,cache,config,shiftDown=0,sortOrder;this.config={};config=$.extend(this.config,$.tablesorter.defaults,settings);$this=$(this);$headers=buildHeaders(this);this.config.parsers=buildParserCache(this,$headers);cache=buildCache(this);var sortCSS=[config.cssDesc,config.cssAsc];fixColumnWidth(this);$headers.click(function(e){$this.trigger("sortStart");var totalRows=($this[0].tBodies[0]&&$this[0].tBodies[0].rows.length)||0;if(!this.sortDisabled&&totalRows>0){var $cell=$(this);var i=this.column;this.order=this.count++%2;if(!e[config.sortMultiSortKey]){config.sortList=[];if(config.sortForce!=null){var a=config.sortForce;for(var j=0;j<a.length;j++){if(a[j][0]!=i){config.sortList.push(a[j]);}}}config.sortList.push([i,this.order]);}else{if(isValueInArray(i,config.sortList)){for(var j=0;j<config.sortList.length;j++){var s=config.sortList[j],o=config.headerList[s[0]];if(s[0]==i){o.count=s[1];o.count++;s[1]=o.count%2;}}}else{config.sortList.push([i,this.order]);}};setTimeout(function(){setHeadersCss($this[0],$headers,config.sortList,sortCSS);appendToTable($this[0],multisort($this[0],config.sortList,cache));},1);return false;}}).mousedown(function(){if(config.cancelSelection){this.onselectstart=function(){return false};return false;}});$this.bind("update",function(){this.config.parsers=buildParserCache(this,$headers);cache=buildCache(this);}).bind("sorton",function(e,list){$(this).trigger("sortStart");config.sortList=list;var sortList=config.sortList;updateHeaderSortCount(this,sortList);setHeadersCss(this,$headers,sortList,sortCSS);appendToTable(this,multisort(this,sortList,cache));}).bind("appendCache",function(){appendToTable(this,cache);}).bind("applyWidgetId",function(e,id){getWidgetById(id).format(this);}).bind("applyWidgets",function(){applyWidget(this);});if($.metadata&&($(this).metadata()&&$(this).metadata().sortlist)){config.sortList=$(this).metadata().sortlist;}if(config.sortList.length>0){$this.trigger("sorton",[config.sortList]);}applyWidget(this);});};this.addParser=function(parser){var l=parsers.length,a=true;for(var i=0;i<l;i++){if(parsers[i].id.toLowerCase()==parser.id.toLowerCase()){a=false;}}if(a){parsers.push(parser);};};this.addWidget=function(widget){widgets.push(widget);};this.formatFloat=function(s){var i=parseFloat(s);return(isNaN(i))?0:i;};this.formatInt=function(s){var i=parseInt(s);return(isNaN(i))?0:i;};this.isDigit=function(s,config){var DECIMAL='\\'+config.decimal;var exp='/(^[+]?0('+DECIMAL+'0+)?$)|(^([-+]?[1-9][0-9]*)$)|(^([-+]?((0?|[1-9][0-9]*)'+DECIMAL+'(0*[1-9][0-9]*)))$)|(^[-+]?[1-9]+[0-9]*'+DECIMAL+'0+$)/';return RegExp(exp).test($.trim(s));};this.clearTableBody=function(table){if($.browser.msie){function empty(){while(this.firstChild)this.removeChild(this.firstChild);}empty.apply(table.tBodies[0]);}else{table.tBodies[0].innerHTML="";}};}});$.fn.extend({tablesorter:$.tablesorter.construct});var ts=$.tablesorter;ts.addParser({id:"text",is:function(s){return true;},format:function(s){return $.trim(s.toLowerCase());},type:"text"});ts.addParser({id:"digit",is:function(s,table){var c=table.config;return $.tablesorter.isDigit(s,c);},format:function(s){return $.tablesorter.formatFloat(s);},type:"numeric"});ts.addParser({id:"currency",is:function(s){return/^[£$€?.]/.test(s);},format:function(s){return $.tablesorter.formatFloat(s.replace(new RegExp(/[^0-9.]/g),""));},type:"numeric"});ts.addParser({id:"ipAddress",is:function(s){return/^\d{2,3}[\.]\d{2,3}[\.]\d{2,3}[\.]\d{2,3}$/.test(s);},format:function(s){var a=s.split("."),r="",l=a.length;for(var i=0;i<l;i++){var item=a[i];if(item.length==2){r+="0"+item;}else{r+=item;}}return $.tablesorter.formatFloat(r);},type:"numeric"});ts.addParser({id:"url",is:function(s){return/^(https?|ftp|file):\/\/$/.test(s);},format:function(s){return jQuery.trim(s.replace(new RegExp(/(https?|ftp|file):\/\//),''));},type:"text"});ts.addParser({id:"isoDate",is:function(s){return/^\d{4}[\/-]\d{1,2}[\/-]\d{1,2}$/.test(s);},format:function(s){return $.tablesorter.formatFloat((s!="")?new Date(s.replace(new RegExp(/-/g),"/")).getTime():"0");},type:"numeric"});ts.addParser({id:"percent",is:function(s){return/\%$/.test($.trim(s));},format:function(s){return $.tablesorter.formatFloat(s.replace(new RegExp(/%/g),""));},type:"numeric"});ts.addParser({id:"usLongDate",is:function(s){return s.match(new RegExp(/^[A-Za-z]{3,10}\.? [0-9]{1,2}, ([0-9]{4}|'?[0-9]{2}) (([0-2]?[0-9]:[0-5][0-9])|([0-1]?[0-9]:[0-5][0-9]\s(AM|PM)))$/));},format:function(s){return $.tablesorter.formatFloat(new Date(s).getTime());},type:"numeric"});ts.addParser({id:"shortDate",is:function(s){return/\d{1,2}[\/\-]\d{1,2}[\/\-]\d{2,4}/.test(s);},format:function(s,table){var c=table.config;s=s.replace(/\-/g,"/");if(c.dateFormat=="us"){s=s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/,"$3/$1/$2");}else if(c.dateFormat=="uk"){s=s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{4})/,"$3/$2/$1");}else if(c.dateFormat=="dd/mm/yy"||c.dateFormat=="dd-mm-yy"){s=s.replace(/(\d{1,2})[\/\-](\d{1,2})[\/\-](\d{2})/,"$1/$2/$3");}return $.tablesorter.formatFloat(new Date(s).getTime());},type:"numeric"});ts.addParser({id:"time",is:function(s){return/^(([0-2]?[0-9]:[0-5][0-9])|([0-1]?[0-9]:[0-5][0-9]\s(am|pm)))$/.test(s);},format:function(s){return $.tablesorter.formatFloat(new Date("2000/01/01 "+s).getTime());},type:"numeric"});ts.addParser({id:"metadata",is:function(s){return false;},format:function(s,table,cell){var c=table.config,p=(!c.parserMetadataName)?'sortValue':c.parserMetadataName;return $(cell).metadata()[p];},type:"numeric"});ts.addWidget({id:"zebra",format:function(table){if(table.config.debug){var time=new Date();}$("tr:visible",table.tBodies[0]).filter(':even').removeClass(table.config.widgetZebra.css[1]).addClass(table.config.widgetZebra.css[0]).end().filter(':odd').removeClass(table.config.widgetZebra.css[0]).addClass(table.config.widgetZebra.css[1]);if(table.config.debug){$.tablesorter.benchmark("Applying Zebra widget",time);}}});})(jQuery);var jaaulde=window.jaaulde||{};jaaulde.utils=jaaulde.utils||{};jaaulde.utils.cookies=(function()
{var resolveOptions,assembleOptionsString,parseCookies,constructor,defaultOptions={expiresAt:null,path:'/',domain:null,secure:false};resolveOptions=function(options)
{var returnValue,expireDate;if(typeof options!=='object'||options===null)
{returnValue=defaultOptions;}
else
{returnValue={expiresAt:defaultOptions.expiresAt,path:defaultOptions.path,domain:defaultOptions.domain,secure:defaultOptions.secure};if(typeof options.expiresAt==='object'&&options.expiresAt instanceof Date)
{returnValue.expiresAt=options.expiresAt;}
else if(typeof options.hoursToLive==='number'&&options.hoursToLive!==0)
{expireDate=new Date();expireDate.setTime(expireDate.getTime()+(options.hoursToLive*60*60*1000));returnValue.expiresAt=expireDate;}
if(typeof options.path==='string'&&options.path!=='')
{returnValue.path=options.path;}
if(typeof options.domain==='string'&&options.domain!=='')
{returnValue.domain=options.domain;}
if(options.secure===true)
{returnValue.secure=options.secure;}}
return returnValue;};assembleOptionsString=function(options)
{options=resolveOptions(options);return((typeof options.expiresAt==='object'&&options.expiresAt instanceof Date?'; expires='+options.expiresAt.toGMTString():'')+'; path='+options.path+
(typeof options.domain==='string'?'; domain='+options.domain:'')+
(options.secure===true?'; secure':''));};parseCookies=function()
{var cookies={},i,pair,name,value,separated=document.cookie.split(';'),unparsedValue;for(i=0;i<separated.length;i=i+1)
{pair=separated[i].split('=');name=pair[0].replace(/^\s*/,'').replace(/\s*$/,'');try
{value=decodeURIComponent(pair[1]);}
catch(e1)
{value=pair[1];}
if(typeof JSON==='object'&&JSON!==null&&typeof JSON.parse==='function')
{try
{unparsedValue=value;value=JSON.parse(value);}
catch(e2)
{value=unparsedValue;}}
cookies[name]=value;}
return cookies;};constructor=function(){};constructor.prototype.get=function(cookieName)
{var returnValue,item,cookies=parseCookies();if(typeof cookieName==='string')
{returnValue=(typeof cookies[cookieName]!=='undefined')?cookies[cookieName]:null;}
else if(typeof cookieName==='object'&&cookieName!==null)
{returnValue={};for(item in cookieName)
{if(typeof cookies[cookieName[item]]!=='undefined')
{returnValue[cookieName[item]]=cookies[cookieName[item]];}
else
{returnValue[cookieName[item]]=null;}}}
else
{returnValue=cookies;}
return returnValue;};constructor.prototype.filter=function(cookieNameRegExp)
{var cookieName,returnValue={},cookies=parseCookies();if(typeof cookieNameRegExp==='string')
{cookieNameRegExp=new RegExp(cookieNameRegExp);}
for(cookieName in cookies)
{if(cookieName.match(cookieNameRegExp))
{returnValue[cookieName]=cookies[cookieName];}}
return returnValue;};constructor.prototype.set=function(cookieName,value,options)
{if(typeof options!=='object'||options===null)
{options={};}
if(typeof value==='undefined'||value===null)
{value='';options.hoursToLive=-8760;}
else if(typeof value!=='string')
{if(typeof JSON==='object'&&JSON!==null&&typeof JSON.stringify==='function')
{value=JSON.stringify(value);}
else
{throw new Error('cookies.set() received non-string value and could not serialize.');}}
var optionsString=assembleOptionsString(options);document.cookie=cookieName+'='+encodeURIComponent(value)+optionsString;};constructor.prototype.del=function(cookieName,options)
{var allCookies={},name;if(typeof options!=='object'||options===null)
{options={};}
if(typeof cookieName==='boolean'&&cookieName===true)
{allCookies=this.get();}
else if(typeof cookieName==='string')
{allCookies[cookieName]=true;}
for(name in allCookies)
{if(typeof name==='string'&&name!=='')
{this.set(name,null,options);}}};constructor.prototype.test=function()
{var returnValue=false,testName='cT',testValue='data';this.set(testName,testValue);if(this.get(testName)===testValue)
{this.del(testName);returnValue=true;}
return returnValue;};constructor.prototype.setOptions=function(options)
{if(typeof options!=='object')
{options=null;}
defaultOptions=resolveOptions(options);};return new constructor();})();(function()
{if(window.jQuery)
{(function($)
{$.cookies=jaaulde.utils.cookies;var extensions={cookify:function(options)
{return this.each(function()
{var i,nameAttrs=['name','id'],name,$this=$(this),value;for(i in nameAttrs)
{if(!isNaN(i))
{name=$this.attr(nameAttrs[i]);if(typeof name==='string'&&name!=='')
{if($this.is(':checkbox, :radio'))
{if($this.attr('checked'))
{value=$this.val();}}
else if($this.is(':input'))
{value=$this.val();}
else
{value=$this.html();}
if(typeof value!=='string'||value==='')
{value=null;}
$.cookies.set(name,value,options);break;}}}});},cookieFill:function()
{return this.each(function()
{var n,getN,nameAttrs=['name','id'],name,$this=$(this),value;getN=function()
{n=nameAttrs.pop();return!!n;};while(getN())
{name=$this.attr(n);if(typeof name==='string'&&name!=='')
{value=$.cookies.get(name);if(value!==null)
{if($this.is(':checkbox, :radio'))
{if($this.val()===value)
{$this.attr('checked','checked');}
else
{$this.removeAttr('checked');}}
else if($this.is(':input'))
{$this.val(value);}
else
{$this.html(value);}}
break;}}});},cookieBind:function(options)
{return this.each(function()
{var $this=$(this);$this.cookieFill().change(function()
{$this.cookify(options);});});}};$.each(extensions,function(i)
{$.fn[i]=this;});})(window.jQuery);}})();