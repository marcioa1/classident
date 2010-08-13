/*
* Price Format jQuery Plugin
* By Eduardo Cuducos
* cuducos [at] gmail [dot] com
* Version: 1.0
* Release: 2009-01-21
*/

(function($) {

  $.fn.priceFormat = function(options) {  

    var defaults = {  
      prefix: 'US$ ',
      centsSeparator: '.',  
      thousandsSeparator: ','
    };  
    var options = $.extend(defaults, options);
    
    return this.each(function() {
      
      var obj = $(this);

      function price_format () {

        // format definitions
        var prefix = options.prefix;
        var centsSeparator = options.centsSeparator;
        var thousandsSeparator = options.thousandsSeparator;
        var formatted = '';
        var thousandsFormatted = '';
        var str = obj.val();

        // skip everything that isn't a number
        // and skip left 0
        var isNumber = /[0-9]/;
        for (var i=0;i<(str.length);i++) {
          char = str.substr(i,1);
          if (formatted.length==0 && char==0) char = false;
          if (char && char.match(isNumber)) formatted = formatted+char;
        }
        
        // format to fill with zeros when < 100
        while (formatted.length<3) formatted = '0'+formatted;
        var centsVal = formatted.substr(formatted.length-2,2);
        var integerVal = formatted.substr(0,formatted.length-2);
      
        // apply cents pontuation
        formatted = integerVal+centsSeparator+centsVal;
      
        // apply thousands pontuation
        if (thousandsSeparator) {
          var thousandsCount = 0;
          for (var j=integerVal.length;j>0;j--) {
            char = integerVal.substr(j-1,1);
            thousandsCount++;
            if (thousandsCount%3==0) char = thousandsSeparator+char;
            thousandsFormatted = char+thousandsFormatted;
          }
          if (thousandsFormatted.substr(0,1)==thousandsSeparator) thousandsFormatted = thousandsFormatted.substring(1,thousandsFormatted.length);
          formatted = thousandsFormatted+centsSeparator+centsVal;
        }
        
        // apply the prefix
        if (prefix) formatted = prefix+formatted;
        
        // replace the value
        obj.val(formatted);
      
      }

      $(this).bind('keyup',price_format);
      if ($(this).val().length>0) price_format();

    });

  };    
    
})(jQuery);

(function($){$().ajaxSend(function(a,xhr,s){xhr.setRequestHeader("Accept","text/javascript, text/html, application/xml, text/xml, */*")})})(jQuery);(function($){$.fn.reset=function(){return this.each(function(){if(typeof this.reset=="function"||(typeof this.reset=="object"&&!this.reset.nodeType)){this.reset()}})};$.fn.enable=function(){return this.each(function(){this.disabled=false})};$.fn.disable=function(){return this.each(function(){this.disabled=true})}})(jQuery);(function($){$.extend({fieldEvent:function(el,obs){var field=el[0]||el,e="change";if(field.type=="radio"||field.type=="checkbox"){e="click"}else{if(obs&&field.type=="text"||field.type=="textarea"){e="keyup"}}return e}});$.fn.extend({delayedObserver:function(delay,callback){var el=$(this);if(typeof window.delayedObserverStack=="undefined"){window.delayedObserverStack=[]}if(typeof window.delayedObserverCallback=="undefined"){window.delayedObserverCallback=function(stackPos){observed=window.delayedObserverStack[stackPos];if(observed.timer){clearTimeout(observed.timer)}observed.timer=setTimeout(function(){observed.timer=null;observed.callback(observed.obj,observed.obj.formVal())},observed.delay*1000);observed.oldVal=observed.obj.formVal()}}window.delayedObserverStack.push({obj:el,timer:null,delay:delay,oldVal:el.formVal(),callback:callback});var stackPos=window.delayedObserverStack.length-1;if(el[0].tagName=="FORM"){$(":input",el).each(function(){var field=$(this);field.bind($.fieldEvent(field,delay),function(){observed=window.delayedObserverStack[stackPos];if(observed.obj.formVal()==observed.obj.oldVal){return}else{window.delayedObserverCallback(stackPos)}})})}else{el.bind($.fieldEvent(el,delay),function(){observed=window.delayedObserverStack[stackPos];if(observed.obj.formVal()==observed.obj.oldVal){return}else{window.delayedObserverCallback(stackPos)}})}},formVal:function(){var el=this[0];if(el.tagName=="FORM"){return this.serialize()}if(el.type=="checkbox"||self.type=="radio"){return this.filter("input:checked").val()||""}else{return this.val()}}})})(jQuery);(function($){$.fn.extend({visualEffect:function(o){e=o.replace(/\_(.)/g,function(m,l){return l.toUpperCase()});return eval("$(this)."+e+"()")},appear:function(speed,callback){return this.fadeIn(speed,callback)},blindDown:function(speed,callback){return this.show("blind",{direction:"vertical"},speed,callback)},blindUp:function(speed,callback){return this.hide("blind",{direction:"vertical"},speed,callback)},blindRight:function(speed,callback){return this.show("blind",{direction:"horizontal"},speed,callback)},blindLeft:function(speed,callback){this.hide("blind",{direction:"horizontal"},speed,callback);return this},dropOut:function(speed,callback){return this.hide("drop",{direction:"down"},speed,callback)},dropIn:function(speed,callback){return this.show("drop",{direction:"up"},speed,callback)},fade:function(speed,callback){return this.fadeOut(speed,callback)},fadeToggle:function(speed,callback){return this.animate({opacity:"toggle"},speed,callback)},fold:function(speed,callback){return this.hide("fold",{},speed,callback)},foldOut:function(speed,callback){return this.show("fold",{},speed,callback)},grow:function(speed,callback){return this.show("scale",{},speed,callback)},highlight:function(speed,callback){return this.show("highlight",{},speed,callback)},puff:function(speed,callback){return this.hide("puff",{},speed,callback)},pulsate:function(speed,callback){return this.show("pulsate",{},speed,callback)},shake:function(speed,callback){return this.show("shake",{},speed,callback)},shrink:function(speed,callback){return this.hide("scale",{},speed,callback)},squish:function(speed,callback){return this.hide("scale",{origin:["top","left"]},speed,callback)},slideUp:function(speed,callback){return this.hide("slide",{direction:"up"},speed,callback)},slideDown:function(speed,callback){return this.show("slide",{direction:"up"},speed,callback)},switchOff:function(speed,callback){return this.hide("clip",{},speed,callback)},switchOn:function(speed,callback){return this.show("clip",{},speed,callback)}})})(jQuery);

/*
 *
 * Copyright (c) 2006-2009 Sam Collett (http://www.texotela.co.uk)
 * Dual licensed under the MIT (http://www.opensource.org/licenses/mit-license.php)
 * and GPL (http://www.opensource.org/licenses/gpl-license.php) licenses.
 *
 * Version 2.2.4
 * Demo: http://www.texotela.co.uk/code/jquery/select/
 *
 * $LastChangedDate$
 * $Rev$
 *
 */
 
;(function($) {
 
/**
 * Adds (single/multiple) options to a select box (or series of select boxes)
 *
 * @name     addOption
 * @author   Sam Collett (http://www.texotela.co.uk)
 * @type     jQuery
 * @example  $("#myselect").addOption("Value", "Text"); // add single value (will be selected)
 * @example  $("#myselect").addOption("Value 2", "Text 2", false); // add single value (won't be selected)
 * @example  $("#myselect").addOption({"foo":"bar","bar":"baz"}, false); // add multiple values, but don't select
 *
 */
$.fn.addOption = function()
{
	var add = function(el, v, t, sO)
	{
		var option = document.createElement("option");
		option.value = v, option.text = t;
		// get options
		var o = el.options;
		// get number of options
		var oL = o.length;
		if(!el.cache)
		{
			el.cache = {};
			// loop through existing options, adding to cache
			for(var i = 0; i < oL; i++)
			{
				el.cache[o[i].value] = i;
			}
		}
		// add to cache if it isn't already
		if(typeof el.cache[v] == "undefined") el.cache[v] = oL;
		el.options[el.cache[v]] = option;
		if(sO)
		{
			option.selected = true;
		}
	};
	
	var a = arguments;
	if(a.length == 0) return this;
	// select option when added? default is true
	var sO = true;
	// multiple items
	var m = false;
	// other variables
	var items, v, t;
	if(typeof(a[0]) == "object")
	{
		m = true;
		items = a[0];
	}
	if(a.length >= 2)
	{
		if(typeof(a[1]) == "boolean") sO = a[1];
		else if(typeof(a[2]) == "boolean") sO = a[2];
		if(!m)
		{
			v = a[0];
			t = a[1];
		}
	}
	this.each(
		function()
		{
			if(this.nodeName.toLowerCase() != "select") return;
			if(m)
			{
				for(var item in items)
				{
					add(this, item, items[item], sO);
				}
			}
			else
			{
				add(this, v, t, sO);
			}
		}
	);
	return this;
};

/**
 * Add options via ajax
 *
 * @name     ajaxAddOption
 * @author   Sam Collett (http://www.texotela.co.uk)
 * @type     jQuery
 * @param    String url      Page to get options from (must be valid JSON)
 * @param    Object params   (optional) Any parameters to send with the request
 * @param    Boolean select  (optional) Select the added options, default true
 * @param    Function fn     (optional) Call this function with the select object as param after completion
 * @param    Array args      (optional) Array with params to pass to the function afterwards
 * @example  $("#myselect").ajaxAddOption("myoptions.php");
 * @example  $("#myselect").ajaxAddOption("myoptions.php", {"code" : "007"});
 * @example  $("#myselect").ajaxAddOption("myoptions.php", {"code" : "007"}, false, sortoptions, [{"dir": "desc"}]);
 *
 */
$.fn.ajaxAddOption = function(url, params, select, fn, args)
{
	if(typeof(url) != "string") return this;
	if(typeof(params) != "object") params = {};
	if(typeof(select) != "boolean") select = true;
	this.each(
		function()
		{
			var el = this;
			$.getJSON(url,
				params,
				function(r)
				{
					$(el).addOption(r, select);
					if(typeof fn == "function")
					{
						if(typeof args == "object")
						{
							fn.apply(el, args);
						} 
						else
						{
							fn.call(el);
						}
					}
				}
			);
		}
	);
	return this;
};

/**
 * Removes an option (by value or index) from a select box (or series of select boxes)
 *
 * @name     removeOption
 * @author   Sam Collett (http://www.texotela.co.uk)
 * @type     jQuery
 * @param    String|RegExp|Number what  Option to remove
 * @param    Boolean selectedOnly       (optional) Remove only if it has been selected (default false)   
 * @example  $("#myselect").removeOption("Value"); // remove by value
 * @example  $("#myselect").removeOption(/^val/i); // remove options with a value starting with 'val'
 * @example  $("#myselect").removeOption(/./); // remove all options
 * @example  $("#myselect").removeOption(/./, true); // remove all options that have been selected
 * @example  $("#myselect").removeOption(0); // remove by index
 * @example  $("#myselect").removeOption(["myselect_1","myselect_2"]); // values contained in passed array
 *
 */
$.fn.removeOption = function()
{
	var a = arguments;
	if(a.length == 0) return this;
	var ta = typeof(a[0]);
	var v, index;
	// has to be a string or regular expression (object in IE, function in Firefox)
	if(ta == "string" || ta == "object" || ta == "function" )
	{
		v = a[0];
		// if an array, remove items
		if(v.constructor == Array)
		{
			var l = v.length;
			for(var i = 0; i<l; i++)
			{
				this.removeOption(v[i], a[1]); 
			}
			return this;
		}
	}
	else if(ta == "number") index = a[0];
	else return this;
	this.each(
		function()
		{
			if(this.nodeName.toLowerCase() != "select") return;
			// clear cache
			if(this.cache) this.cache = null;
			// does the option need to be removed?
			var remove = false;
			// get options
			var o = this.options;
			if(!!v)
			{
				// get number of options
				var oL = o.length;
				for(var i=oL-1; i>=0; i--)
				{
					if(v.constructor == RegExp)
					{
						if(o[i].value.match(v))
						{
							remove = true;
						}
					}
					else if(o[i].value == v)
					{
						remove = true;
					}
					// if the option is only to be removed if selected
					if(remove && a[1] === true) remove = o[i].selected;
					if(remove)
					{
						o[i] = null;
					}
					remove = false;
				}
			}
			else
			{
				// only remove if selected?
				if(a[1] === true)
				{
					remove = o[index].selected;
				}
				else
				{
					remove = true;
				}
				if(remove)
				{
					this.remove(index);
				}
			}
		}
	);
	return this;
};

/**
 * Sort options (ascending or descending) in a select box (or series of select boxes)
 *
 * @name     sortOptions
 * @author   Sam Collett (http://www.texotela.co.uk)
 * @type     jQuery
 * @param    Boolean ascending   (optional) Sort ascending (true/undefined), or descending (false)
 * @example  // ascending
 * $("#myselect").sortOptions(); // or $("#myselect").sortOptions(true);
 * @example  // descending
 * $("#myselect").sortOptions(false);
 *
 */
$.fn.sortOptions = function(ascending)
{
	// get selected values first
	var sel = $(this).selectedValues();
	var a = typeof(ascending) == "undefined" ? true : !!ascending;
	this.each(
		function()
		{
			if(this.nodeName.toLowerCase() != "select") return;
			// get options
			var o = this.options;
			// get number of options
			var oL = o.length;
			// create an array for sorting
			var sA = [];
			// loop through options, adding to sort array
			for(var i = 0; i<oL; i++)
			{
				sA[i] = {
					v: o[i].value,
					t: o[i].text
				}
			}
			// sort items in array
			sA.sort(
				function(o1, o2)
				{
					// option text is made lowercase for case insensitive sorting
					o1t = o1.t.toLowerCase(), o2t = o2.t.toLowerCase();
					// if options are the same, no sorting is needed
					if(o1t == o2t) return 0;
					if(a)
					{
						return o1t < o2t ? -1 : 1;
					}
					else
					{
						return o1t > o2t ? -1 : 1;
					}
				}
			);
			// change the options to match the sort array
			for(var i = 0; i<oL; i++)
			{
				o[i].text = sA[i].t;
				o[i].value = sA[i].v;
			}
		}
	).selectOptions(sel, true); // select values, clearing existing ones
	return this;
};
/**
 * Selects an option by value
 *
 * @name     selectOptions
 * @author   Mathias Bank (http://www.mathias-bank.de), original function
 * @author   Sam Collett (http://www.texotela.co.uk), addition of regular expression matching
 * @type     jQuery
 * @param    String|RegExp|Array value  Which options should be selected
 * can be a string or regular expression, or an array of strings / regular expressions
 * @param    Boolean clear  Clear existing selected options, default false
 * @example  $("#myselect").selectOptions("val1"); // with the value 'val1'
 * @example  $("#myselect").selectOptions(["val1","val2","val3"]); // with the values 'val1' 'val2' 'val3'
 * @example  $("#myselect").selectOptions(/^val/i); // with the value starting with 'val', case insensitive
 *
 */
$.fn.selectOptions = function(value, clear)
{
	var v = value;
	var vT = typeof(value);
	// handle arrays
	if(vT == "object" && v.constructor == Array)
	{
		var $this = this;
		$.each(v, function()
			{
      				$this.selectOptions(this, clear);
    			}
		);
	};
	var c = clear || false;
	// has to be a string or regular expression (object in IE, function in Firefox)
	if(vT != "string" && vT != "function" && vT != "object") return this;
	this.each(
		function()
		{
			if(this.nodeName.toLowerCase() != "select") return this;
			// get options
			var o = this.options;
			// get number of options
			var oL = o.length;
			for(var i = 0; i<oL; i++)
			{
				if(v.constructor == RegExp)
				{
					if(o[i].value.match(v))
					{
						o[i].selected = true;
					}
					else if(c)
					{
						o[i].selected = false;
					}
				}
				else
				{
					if(o[i].value == v)
					{
						o[i].selected = true;
					}
					else if(c)
					{
						o[i].selected = false;
					}
				}
			}
		}
	);
	return this;
};

/**
 * Copy options to another select
 *
 * @name     copyOptions
 * @author   Sam Collett (http://www.texotela.co.uk)
 * @type     jQuery
 * @param    String to  Element to copy to
 * @param    String which  (optional) Specifies which options should be copied - 'all' or 'selected'. Default is 'selected'
 * @example  $("#myselect").copyOptions("#myselect2"); // copy selected options from 'myselect' to 'myselect2'
 * @example  $("#myselect").copyOptions("#myselect2","selected"); // same as above
 * @example  $("#myselect").copyOptions("#myselect2","all"); // copy all options from 'myselect' to 'myselect2'
 *
 */
$.fn.copyOptions = function(to, which)
{
	var w = which || "selected";
	if($(to).size() == 0) return this;
	this.each(
		function()
		{
			if(this.nodeName.toLowerCase() != "select") return this;
			// get options
			var o = this.options;
			// get number of options
			var oL = o.length;
			for(var i = 0; i<oL; i++)
			{
				if(w == "all" || (w == "selected" && o[i].selected))
				{
					$(to).addOption(o[i].value, o[i].text);
				}
			}
		}
	);
	return this;
};

/**
 * Checks if a select box has an option with the supplied value
 *
 * @name     containsOption
 * @author   Sam Collett (http://www.texotela.co.uk)
 * @type     Boolean|jQuery
 * @param    String|RegExp value  Which value to check for. Can be a string or regular expression
 * @param    Function fn          (optional) Function to apply if an option with the given value is found.
 * Use this if you don't want to break the chaining
 * @example  if($("#myselect").containsOption("val1")) alert("Has an option with the value 'val1'");
 * @example  if($("#myselect").containsOption(/^val/i)) alert("Has an option with the value starting with 'val'");
 * @example  $("#myselect").containsOption("val1", copyoption).doSomethingElseWithSelect(); // calls copyoption (user defined function) for any options found, chain is continued
 *
 */
$.fn.containsOption = function(value, fn)
{
	var found = false;
	var v = value;
	var vT = typeof(v);
	var fT = typeof(fn);
	// has to be a string or regular expression (object in IE, function in Firefox)
	if(vT != "string" && vT != "function" && vT != "object") return fT == "function" ? this: found;
	this.each(
		function()
		{
			if(this.nodeName.toLowerCase() != "select") return this;
			// option already found
			if(found && fT != "function") return false;
			// get options
			var o = this.options;
			// get number of options
			var oL = o.length;
			for(var i = 0; i<oL; i++)
			{
				if(v.constructor == RegExp)
				{
					if (o[i].value.match(v))
					{
						found = true;
						if(fT == "function") fn.call(o[i], i);
					}
				}
				else
				{
					if (o[i].value == v)
					{
						found = true;
						if(fT == "function") fn.call(o[i], i);
					}
				}
			}
		}
	);
	return fT == "function" ? this : found;
};

/**
 * Returns values which have been selected
 *
 * @name     selectedValues
 * @author   Sam Collett (http://www.texotela.co.uk)
 * @type     Array
 * @example  $("#myselect").selectedValues();
 *
 */
$.fn.selectedValues = function()
{
	var v = [];
	this.selectedOptions().each(
		function()
		{
			v[v.length] = this.value;
		}
	);
	return v;
};

/**
 * Returns text which has been selected
 *
 * @name     selectedTexts
 * @author   Sam Collett (http://www.texotela.co.uk)
 * @type     Array
 * @example  $("#myselect").selectedTexts();
 *
 */
$.fn.selectedTexts = function()
{
	var t = [];
	this.selectedOptions().each(
		function()
		{
			t[t.length] = this.text;
		}
	);
	return t;
};

/**
 * Returns options which have been selected
 *
 * @name     selectedOptions
 * @author   Sam Collett (http://www.texotela.co.uk)
 * @type     jQuery
 * @example  $("#myselect").selectedOptions();
 *
 */
$.fn.selectedOptions = function()
{
	return this.find("option:selected");
};

})(jQuery);

jQuery(function(){$('input[type="text"].first').focus();$("#tabs").tabs();$("#datepicker").datepicker();$("#datepicker2").datepicker();$("#datepicker3").datepicker();$("#datepicker4").datepicker();$("#datepicker5").datepicker();$("#datepicker6").datepicker();$(".datepicker").datepicker();});function outra_clinica(){$("#seleciona_clinica").show();}function conta_caracteres(){if($("#nome").val().length>2){$("#pesquisar_button").attr("disabled",false);}else{$("#pesquisar_button").attr("disabled",true);}}function selecionou_item_tabela(a){$.getJSON("/item_tabelas/busca_descricao",{id:$("#tratamento_item_tabela_id").selectedValues()[0]},function(b){resultado=b.split(";");$("#tratamento_descricao").val(resultado[0]);$("#tratamento_valor").val(resultado[1]);});}function coloca_data_de_hoje(c,a,b){$("#tratamento_data_3i").selectOptions(c+"");$("#tratamento_data_2i").selectOptions(a+"");$("#tratamento_data_1i").selectOptions(b+"");}function selecionou_forma(a){if($("#"+a).selectedOptions().text().toLowerCase()=="cheque"){$("#cheque").show();}else{$("#cheque").hide();}}function alterou_data_tratamento(){data=$("#datepicker").datepicker("getDate");if(data==null){$("#tratamento_data_3i").selectOptions("");$("#tratamento_data_2i").selectOptions("");$("#tratamento_data_1i").selectOptions("");}else{dia=data.getDate();mes=data.getMonth()+1;ano=data.getFullYear();$("#tratamento_data_3i").selectOptions(dia+"");$("#tratamento_data_2i").selectOptions(mes+"");$("#tratamento_data_1i").selectOptions(ano+"");}}function alterou_data_cadastro(){data=$("#datepicker").datepicker("getDate");if(data==null){$("#paciente_nascimento_3i").selectOptions("");$("#paciente_nascimento_2i").selectOptions("");$("#paciente_nascimento_1i").selectOptions("");}else{dia=data.getDate();mes=data.getMonth()+1;ano=data.getFullYear();$("#paciente_nascimento_3i").selectOptions(dia+"");$("#paciente_nascimento_2i").selectOptions(mes+"");$("#paciente_nascimento_1i").selectOptions(ano+"");}}function copia_valor(){$("#recebimento_cheque_attributes_valor").val($("#recebimento_valor").val());}function abre_uma_devolucao(){$("#devolvido_uma_vez").toggle("blind",{percent:0},500);}function abre_reapresentacao(){$("#reapresentado").toggle("blind",{percent:0},500);}function abre_segunda_devolucao(){$("#devolvido_duas_vezes").toggle("blind",{percent:0},500);}function enviar_administracao(){var d="";var a=$("input:checkbox");for(var b=0;b<a.length;b++){var c=a[b].id;if($("#"+c).is(":checked")){d+=c+",";}}$.getJSON("recebe_cheques",{cheques:d},function(e){$("form:last").trigger("submit");alert(e);});}function selecionar(){if($("#selecao").text()=="todos"){$("#selecao").text("nenhum");$("#tipo_pagamento_id").each(function(){$("#tipo_pagamento_id option").attr("selected","selected");});}else{$("#selecao").text("todos");$("#tipo_pagamento_id").each(function(){$("#tipo_pagamento_id option").removeAttr("selected");});}}function abre_cheque(a){window.open("/cheques/"+a,"abriu o cheque","height=260,width=480,status=no");}function abre_pagamento(a){window.open("/pagamentos/"+a,"abre o pagamento","height=600,width=600,status=no,resizable=yes,scrollbars=yes");}function pesquisa_disponiveis(){jQuery.ajax({url:"/cheques/busca_disponiveis",type:"GET",data:{valor:$("#pagamento_valor_pago_real").val()},success:function(a){$("#lista_de_cheques").replaceWith("<span id='lista_de_cheques'>"+a+"</span>");}});}function formata_valor(a){a.priceFormat({prefix:"",centsSeparator:",",thousandsSeparator:"."});}function seleciona_todas_as_formas_de_recebimento(){if($("#todas").is(":checked")){$("input[name*='forma']").attr("checked",true);}else{$("input[name*='forma']").attr("checked",false);}}jQuery(function(){$.loading({onAjax:true,text:"Carregando ...",align:"center",mask:true});});function confirma_recebimento_de_cheque(){var d="";var a=$("input:checkbox");for(var b=0;b<a.length;b++){var c=a[b].id;if($("#"+c).is(":checked")){d+=c+",";}}$.getJSON("registra_recebimento_de_cheques",{cheques:d},function(e){alert(e);});}function pagar(c,f,b){anterior=$("#valor").text();valor_total=parseFloat(anterior);if($("#pagar_"+f).is(":checked")==true){valor_total=valor_total+c;}else{valor_total=valor_total-c;}$("#valor").text(valor_total);var a=$(":checkbox[name|='pagar']:checked");var d="";for(f=0;f<a.size();f++){d=d+","+a[f].value;}if(d.length>1){d=d.substring(1);}var e="<span id='link_pagamento'><a href='/pagamentos/new?valor="+valor_total+"&trabalho_protetico_id="+d+"&protetico_id="+b+"'>efetua pagamento</a></span>";$("#link_pagamento").replaceWith(e);}function pagar_dentista(b,a,d){anterior=$("#valor").text();valor_total=parseFloat(anterior);if($("#pagar_dentista_"+a).is(":checked")==true){valor_total=valor_total+b;}else{valor_total=valor_total-b;}$("#valor").text(valor_total);var c="<span id='link_pagamento'><a href='/pagamentos/new?valor="+valor_total+"&dentista_id="+d+"'>efetua pagamento</a></span>";$("#link_pagamento").replaceWith(c);}function pagamento_dentista(b){var a=$("#fragment-3 input:checkbox");url="pagamento?inicio='"+$("#datepicker3").val()+"'&fim='"+$("#datepicker4").val()+"'&dentista_id="+b;$.getJSON(url,function(c){$("#lista_pagamento").replaceWith(c);});}function registra_confirmacao_de_entrada(){entradas=$("input:checked");id_str="";$.each(entradas,function(a,b){aux=((b.id).split("_"));id_str+=aux[1]+",";});jQuery.ajax({url:"/entradas/registra_confirmacao_de_entrada",type:"POST",data:{data:id_str},success:function(a){$("input:submit").click();}});}function busca_proteticos_da_clinica(){$.ajax({url:"/proteticos/busca_proteticos_da_clinica",type:"GET",data:{clinica_id:$("#clinica").val()},success:function(a){$("#protetico").html("");for(var b=0;b<a.length;b++){$("#protetico").append(new Option(a[b],a[b]));}}});}function pagamento_protetico(){var c=$("input:checked");id_str="";valor_a_pagar=0;$.each(c,function(d,e){aux=((e.id).split("_"));id_str+=aux[2]+",";valor_a_pagar+=parseFloat($("#valor_"+aux[2]).html());});var b=$("#protetico_id").val();var a="http://"+window.location.host+"/pagamentos/registra_pagamento_a_protetico?ids='"+id_str+"'&valores='"+valor_a_pagar+"' &protetico_id="+b;alert(a);window.location=a;}function busca_saldo(){$("#data").replaceWith("<span id=data></span>");$("#saldo_em_dinheiro").val("");$("#saldo_em_cheque").val("");$.ajax({url:"/busca_saldo",type:"GET",data:{clinica:$("#clinica").val()},success:function(a){var b=a.split(";");$("#data").replaceWith(b[0]);$("#saldo_em_dinheiro").val(b[1]);$("#saldo_em_cheque").val(b[2]);}});}function limpa_nome(){$("#nome").val("");}function limpa_codigo(){$("#codigo").val("");}function selecionou_cheque(a){var e=0;var b=$("#lista_de_cheques :checked");var g="";for(var d=0;d<b.length;d++){id_cheque=(b[d].id).split("_")[1];g+=id_cheque+",";var c=$("#valor_"+id_cheque).text();c=c.replace(".","");c=parseFloat(c.replace(",","."));e+=c;}$("#cheques_ids").val(g);var f=$("#pagamento_valor_pago").val();if(f<e){alert("A soma dos valores dos cheques selecionados é maior que o valor do pagamento.");}$("#pagamento_valor_restante").val(parseInt((f-e)*100));formata_valor($("#pagamento_valor_restante"));}function producao(){var c=$("#fragment-2 input:checkbox");var a="";for(var b=0;b<c.length;b++){if($("#"+c[b].id).is(":checked")){a+=$("#"+c[b].id).val()+",";}}url="producao?datepicker='"+$("#datepicker").val()+"'&datepicker2='"+$("#datepicker2").val()+"'&clinicas="+a;$.getJSON(url,function(d){$("#lista").replaceWith(d);});}function cheque(a){if(a==1){$("#cheque_classident").show();$("#pagamento_conta_bancaria_id").focus();$("#pagamento_valor_cheque").val($("#pagamento_valor_restante").val());}else{$("#cheque_classident").hide();$("#pagamento_numero_do_cheque").val("");$("#pagamento_valor_cheque").val("");}}function escolheu_protetico(){$("#trabalho_protetico_tabela_protetico_id").hide();$.getJSON("/proteticos/busca_tabela",{protetico_id:$("#trabalho_protetico_protetico_id").val()},function(c){$("#trabalho_protetico_tabela_protetico_id").html("");saida="";for(var b=0;b<c.length;b++){if(b==0){var a=c[0][1];$.getJSON("/tabela_proteticos/busca_valor",{id:a},function(d){$("#trabalho_protetico_valor").val(d);});}$("#trabalho_protetico_tabela_protetico_id").append(new Option(c[b][0]+" ",c[b][1]));}});$("#trabalho_protetico_tabela_protetico_id").show();}function escolheu_item_da_tabela(){$.getJSON("/tabela_proteticos/busca_valor",{id:$("#trabalho_protetico_tabela_protetico_id").val()},function(a){$("#trabalho_protetico_valor").val(a);});}function devolve_trabalho(f){$.get("/registra_devolucao_de_trabalho?id="+f);var e=new Date();var a=e.getDate();var c=e.getMonth();c++;var b=e.getFullYear();$("#data_"+f).replaceWith(a+"/"+c+"/"+b);}function registra_devolucao(f){$.get("/registra_devolucao_de_trabalho?id="+f);var e=new Date();var a=e.getDate();var c=e.getMonth();c++;var b=e.getFullYear();$("#data_devolucao_"+f).replaceWith(a+"/"+c+"/"+b);}function selecionou_estado(){$(":checkbox").attr("checked",false);}function busca_pacientes_que_iniciam_com(a){$("#linha_"+a).show();$.getJSON("/pacientes/nomes_que_iniciam_com?nome="+$("#"+a).val()+"&div="+a,function(b){$("#nomes_"+a).replaceWith('<div id="nomes_'+a+'"  class="lista">'+b+"</div>");});}function escolheu_nome_da_lista(a,c,b){$("#"+c).val(a);$("#id_"+c).val(b);$("#linha_"+c).hide();}function selecionou_face(){$("#tratamento_estado_nenhum").attr("checked",true);}function todas_as_faces(){selecionou_face();$(":checkbox").attr("checked",$("#todas").is(":checked"));}function selecionou_tratamento(){var a=$(":checked");var b=0;for(i=0;i<a.length;i++){b=b+parseFloat(a[i].value);}$("#orcamento_valor").val(b);}function calcula_valor_orcamento(){total=parseFloat($("#orcamento_valor").val());desconto=parseFloat($("#orcamento_desconto").val());$("#orcamento_valor_com_desconto").val(total-(total*desconto/100));calcula_valor_da_parcela();}function calcula_valor_da_parcela(){valor_com_desconto=$("#orcamento_valor_com_desconto").val().replace(",",".");valor=parseFloat(valor_com_desconto);numero=$("#orcamento_numero_de_parcelas").val();$("#orcamento_valor_da_parcela").val(parseInt((valor/numero)*100));formata_valor($("#orcamento_valor_da_parcela"));$.getJSON("monta_tabela_de_parcelas?numero_de_parcelas="+numero+"&valor_da_parcela="+valor+"&data_primeira_parcela="+$("#orcamento_vencimento_primeira_parcela").val(),function(a){$("#parcelas").replaceWith(a);});}function definir_valor(){if($("#acima_de_um_valor").is(":checked")){$("#valor").focus();}else{$("#valor").val("");}}function orcamento_dentista(){var c=$("#fragment-4 input:checkbox");var a="";for(var b=0;b<c.length;b++){if($("#"+c[b].id).is(":checked")){a+=$("#"+c[b].id).val()+",";}}url="orcamentos?inicio='"+$("#datepicker5").val()+"'&fim='"+$("#datepicker6").val()+"'&clinicas="+a;$.getJSON(url,function(d){$("#lista_orcamento").replaceWith(d);});}function finalizar_tratamento(a){$.ajax({url:"/tratamentos/"+a+"/finalizar_procedimento",success:function(){window.location.reload();}});}function busca_id(a){$.ajax({url:"/pacientes/busca_id_do_paciente",type:"GET",data:{nome:$("#paciente_"+a).val()},success:function(b){$("#paciente_id_"+a).val(b);}});}

/* Brazilian initialisation for the jQuery UI date picker plugin. */
/* Written by Leonildo Costa Silva (leocsilva@gmail.com). */
jQuery(function($){
	$.datepicker.regional['pt-BR'] = {
		clearText: 'Limpar', clearStatus: '',
		closeText: 'Fechar', closeStatus: '',
		prevText: '&#x3c;Anterior', prevStatus: '',
		prevBigText: '&#x3c;&#x3c;', prevBigStatus: '',
		nextText: 'Pr&oacute;ximo&#x3e;', nextStatus: '',
		nextBigText: '&#x3e;&#x3e;', nextBigStatus: '',
		currentText: 'Hoje', currentStatus: '',
		monthNames: ['Janeiro','Fevereiro','Mar&ccedil;o','Abril','Maio','Junho',
		'Julho','Agosto','Setembro','Outubro','Novembro','Dezembro'],
		monthNamesShort: ['Jan','Fev','Mar','Abr','Mai','Jun',
		'Jul','Ago','Set','Out','Nov','Dez'],
		monthStatus: '', yearStatus: '',
		weekHeader: 'Sm', weekStatus: '',
		dayNames: ['Domingo','Segunda-feira','Ter&ccedil;a-feira','Quarta-feira','Quinta-feira','Sexta-feira','Sabado'],
		dayNamesShort: ['Dom','Seg','Ter','Qua','Qui','Sex','Sab'],
		dayNamesMin: ['Dom','Seg','Ter','Qua','Qui','Sex','Sab'],
		dayStatus: 'DD', dateStatus: 'D, M d',
		dateFormat: 'dd/mm/yy', firstDay: 0, 
		initStatus: '', isRTL: false};
	$.datepicker.setDefaults($.datepicker.regional['pt-BR']);
});

;(function($){var L=$.loading=function(show,opts){return $('body').loading(show,opts,true);};$.fn.loading=function(show,opts,page){opts=toOpts(show,opts);var base=page?$.extend(true,{},L,L.pageOptions):L;return this.each(function(){var $el=$(this),l=$.extend(true,{},base,$.metadata?$el.metadata():null,opts);if(typeof l.onAjax=="boolean"){L.setAjax.call($el,l);}else{L.toggle.call($el,l);}});};var fixed={position:$.browser.msie?'absolute':'fixed'};$.extend(L,{version:"1.6.4",align:'top-left',pulse:'working error',mask:false,img:null,element:null,text:'Loading...',onAjax:undefined,delay:0,max:0,classname:'loading',imgClass:'loading-img',elementClass:'loading-element',maskClass:'loading-mask',css:{position:'absolute',whiteSpace:'nowrap',zIndex:1001},maskCss:{position:'absolute',opacity:.15,background:'#333',zIndex:101,display:'block',cursor:'wait'},cloneEvents:true,pageOptions:{page:true,align:'top-center',css:fixed,maskCss:fixed},html:'<div></div>',maskHtml:'<div></div>',maskedClass:'loading-masked',maskEvents:'mousedown mouseup keydown keypress',resizeEvents:'resize',working:{time:10000,text:'Still working...',run:function(l){var w=l.working,self=this;w.timeout=setTimeout(function(){self.height('auto').width('auto').text(l.text=w.text);l.place.call(self,l);},w.time);}},error:{time:100000,text:'Task may have failed...',classname:'loading-error',run:function(l){var e=l.error,self=this;e.timeout=setTimeout(function(){self.height('auto').width('auto').text(l.text=e.text).addClass(e.classname);l.place.call(self,l);},e.time);}},fade:{time:800,speed:'slow',run:function(l){var f=l.fade,s=f.speed,self=this;f.interval=setInterval(function(){self.fadeOut(s).fadeIn(s);},f.time);}},ellipsis:{time:300,run:function(l){var e=l.ellipsis,self=this;e.interval=setInterval(function(){var et=self.text(),t=l.text,i=dotIndex(t);self.text((et.length-i)<3?et+'.':t.substring(0,i));},e.time);function dotIndex(t){var x=t.indexOf('.');return x<0?t.length:x;}}},type:{time:100,run:function(l){var t=l.type,self=this;t.interval=setInterval(function(){var e=self.text(),el=e.length,txt=l.text;self.text(el==txt.length?txt.charAt(0):txt.substring(0,el+1));},t.time);}},toggle:function(l){var old=this.data('loading');if(old){if(l.show!==true)old.off.call(this,old,l);}else{if(l.show!==false)l.on.call(this,l);}},setAjax:function(l){if(l.onAjax){var self=this,count=0,A=l.ajax={start:function(){if(!count++)l.on.call(self,l);},stop:function(){if(!--count)l.off.call(self,l,l);}};this.bind('ajaxStart.loading',A.start).bind('ajaxStop.loading',A.stop);}else{this.unbind('ajaxStart.loading ajaxStop.loading');}},on:function(l,force){var p=l.parent=this.data('loading',l);if(l.max)l.maxout=setTimeout(function(){l.off.call(p,l,l);},l.max);if(l.delay&&!force){return l.timeout=setTimeout(function(){delete l.timeout;l.on.call(p,l,true);},l.delay);}
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
function css(el,prop){var val=el.css(prop);return val=='auto'?0:parseFloat(val,10);}})(jQuery);