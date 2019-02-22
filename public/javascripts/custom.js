$.fn.serializeObject = function()
{
    var o = {};
    var a = this.serializeArray();
    $.each(a, function() {
        if (o[this.name]) {
            if (!o[this.name].push) {
                o[this.name] = [o[this.name]];
            }
            o[this.name].push(this.value || '');
        } else {
            o[this.name] = this.value || '';
        }
    });
    return o;
};

 //cuando se carga toda la pagina
 $(document).ready(function(){
	createTabs();
	loadTheme();
	$('#ex4c').jqm(({
    onHide: function(h) { 
      h.o.remove(); // remove overlay
      h.w.fadeOut(888); // hide window
      
    }
    }));
    
 });
 
 //carga el tema desde el array
function loadTheme(){
	if(app["userData"]["cColor"]){
		//color del titulo de los widgets
 		$("#tabs-main .widget").css({'background-color': app["userData"]["cColor"]});
 		//color de las pesta“as
 		$(".ui-state-default").css({'background-color': app["userData"]["cColor"]});
 		//borde de las pesta“as, oscurecemos un poco el color definido
 		var color=$(".ui-state-default").css("background-color");
 		color=color.split("(")[1];
 		color=color.split(")")[0];
 		var r=color.split(",")[0];
 		var g=color.split(",")[1];
 		var b=color.split(",")[2];
 		r=parseInt(r)-7;
 		if(r<0)r=0;
 		g=parseInt(g)-7;
 		if(g<0)g=0;
 		b=parseInt(b)-7;
 		if(b<0)b=0;
 		$(".ui-state-default").css({'border-color': 'rgb('+r+','+g+','+b+')'});
 	}else{
 		$("#tabs-main .widget").css({'background-color': '#5583a8'});
 	}
 	if(app["userData"]["topbg"]){
		$("#page-heading").css("background-image","url("+app["userData"]["topbg"]+")");
	}
	if(app["userData"]["cFont"]){
 		$("#tabs-main .widget .widget-header").css({"font-family" : app["userData"]["cFont"]});
 	}
}


//crea los tabs, las pesta“as y a“ade los eventos correspondientes
function createTabs(){
	//creamos el ∑rea donde ir∑n las pesta“as
	$("#tabs").empty();
	$("#tabs-main").empty();
	$("#tabs").addClass('ui-tabs ui-widget ui-widget-content ui-corner-all');
	$("#tabs").append('<ul class="ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all"></ul>');
	//para cada tab definido en el array
	for( vtab in app["userData"]["tabs"] ){
		//guardamos el id de la DB del tab
		tid=app["userData"]["tabs"][vtab]["id"];
		//creamos las pesta“as (en la barra superior) y les asignamos eventos para poder cambiar de tab
		$("#tabs ul").append('<li id="li_'+tid+'" class="ui-state-default ui-corner-top"><a href="#" onClick="openTab(\''+tid+'\')">'+app["userData"]["tabs"][vtab]["title"]+'</a><span class="ui-icon ui-icon-close"><a href="/tabs/'+tid+'" onclick="var f = document.createElement(\'form\'); f.style.display = \'none\'; this.parentNode.appendChild(f); f.method = \'POST\'; f.action = this.href;var m = document.createElement(\'input\'); m.setAttribute(\'type\', \'hidden\'); m.setAttribute(\'name\', \'_method\'); m.setAttribute(\'value\', \'delete\'); f.appendChild(m);f.submit();return false;">Destroy</a></span><span class="ui-icon ui-icon-wrench"><a href="#" onClick="modalEdit(\'e\',\''+vtab+'\')">Edit</a></span></li>');
		//<a href="/tabs/'+tid+'/edit" onClick="$(\'#ex4c\').jqmShow()">
		//creamos los tabs vacÃos
		$("#tabs-main").append('<div id="tabs'+tid+'" class="ui-tabs-panel ui-widget-content ui-corner-bottom ui-tabs-hide" ><div class="containers"> </div></div>'); 
		for(var i=0;i<app["userData"]["tabs"][vtab]["cols"];i++){
			//creamos las columnas necesarias dentro del tab
			$("#tabs"+tid+" .containers").append( '<div id="column_'+ i + '_' + tid +'" class="widget-place layout_'+app["userData"]["tabs"][vtab]["layout"]+'" > </div>');
		}
	}
	//el primer tab es seleccionado
	$("#tabs ul").children("li:first").addClass('ui-tabs-selected ui-state-active');
	$("#tabs-main").children(".ui-tabs-panel:first").removeClass('ui-tabs-hide');

	$("#tabs ul").append('<li class="ui-state-default ui-corner-top"><a href="#" onClick="modalEdit(\'a\',\'0\')">+</a></li>');

	$("#tabs ul li").each(function(){
		$(this).hover( function(){
			$(this).addClass('ui-state-hover');
		},function(){
			$(this).removeClass('ui-state-hover');
		})
	});	
	//guardamos el id de la primera pesta“a como tab seleccionado
	tabVal=$("#tabs ul").children("li:first").attr("id").substring(9);
	loadWidgets();
}



//maneja los clicks en los distintos tabs, solo muestra el contenido del seleccionado
function openTab(tid){
	$("#tabs-main .ui-tabs-panel").addClass('ui-tabs-hide');
	$("#tabs"+tid).removeClass('ui-tabs-hide');
	$("#tabs .ui-tabs-selected").removeClass('ui-tabs-selected');
	$("#tabs .ui-state-active").removeClass('ui-state-active');
	$("#li_"+tid).addClass('ui-tabs-selected ui-state-active');
	tabVal=tid;
}

//carga los widgets desde el array en elementos DOM correspondientes
function loadWidgets(){
	var reSort= new Array();
	
	for ( widget in app["userData"]["containers"]){
		//if(	app["userData"]["containers"][widget]["tab"] == app["userData"]["tabs"][tabVal]["id"]){
			//crea el container
			if(app["userData"]["containers"][widget]["row"] != null ){
				//someLoaded=false;
				foundPos=false;
				curDomWid=$('#tabs' + app["userData"]["containers"][widget]["tab"] + ' #column_' +app["userData"]["containers"][widget]["col"] + '_'+ app["userData"]["containers"][widget]["tab"]).children(":first");
				
				while(curDomWid.length > 0){//existen widgets en la columna
					
					current=curDomWid.attr("id");
					current=current.substring(10);
					if(app["userData"]["containers"][current]["row"] > app["userData"]["containers"][widget]["row"]){//si encontramos la posicion
						foundPos=true;
						curDomWid.before('<div id="container_'+widget+'" class="widget movable collapsable editable removable closeconfirm"></div>');
						break;
					}
					curDomWid=curDomWid.next(".widget");
				}

				if(!foundPos){
					//cargamos al final del conenedor
				$('#tabs' + app["userData"]["containers"][widget]["tab"] + ' #column_' + app["userData"]["containers"][widget]["col"] + '_'+app["userData"]["containers"][widget]["tab"]).append('<div id="container_'+widget+'" class="widget movable collapsable editable removable closeconfirm"></div>');
				}	
			}else{
				//agregamos al final, pero se reordenan los ordenes al final para la columna
				app["userData"]["containers"][widget]["row"]=30000;
				$('#tabs' + app["userData"]["containers"][widget]["tab"] + ' #column_' + app["userData"]["containers"][widget]["col"] + '_'+app["userData"]["containers"][widget]["tab"]).append('<div id="container_'+widget+'" class="widget movable collapsable editable removable closeconfirm"></div>');
				reSort.push(widget);
			}
			
			//titulo con icono
			$('#container_'+widget).append('<div class="widget-header"><div class="text"><img src="'+app["userData"]["containers"][widget]["widgetPreferences"]["icon"]+'" />'+ app["userData"]["containers"][widget]["title"] +'</div></div>');
			//creamos la caja edit vacÌa
			$('#container_'+widget).append('<div class="widget-editbox"> </div>');
			//contenido, el BW carga el widget ac·
			$('#container_'+widget).append('<div class="widget-content" id="wcontent_'+widget+'"> </div>');
			
			var BW = new UWA.BlogWidget( {
				container: document.getElementById('wcontent_'+widget),
				moduleUrl: app["userData"]["containers"][widget]["widgetURL"] } );
			BW.setConfiguration(
				{ 'borderWidth':'1', 'color':'#aaaaaa', 'displayTitle':false, 'displayFooter':false } );

    		var prefs = {};
		    $.each(app['userData']['containers'][widget]['preferenceValues'], function() {
		        if (prefs[this.name]) {
		            if (!prefs[this.name].push) {
		                prefs[this.name] = [prefs[this.name]];
		            }
		            prefs[this.name].push(this.value || '');
		        } else {
		            prefs[this.name] = this.value || '';
		        }
		    });
	
			BW.setPreferencesValues(prefs);
			feed = app["userData"]["containers"][widget]["widgetPreferences"]["preferences"];
			editObj = $('#container_'+widget+' .widget-editbox');
			
			//aÒadimos lo necesario a la caja de edit
			setPrefs(feed,editObj,BW, prefs);
	}

	for(widget in reSort) resortContainer(widget);
	$.fn.EasyWidgets({
		//textos en espaÒol
		i18n : {
		      editText : 'Editar',
		      closeText : 'Cerrar',
		      extendText : 'Extender',
		      collapseText : 'Colapsar',
		      cancelEditText : 'Cancelar',
		      editTitle : 'Editar este widget',
		      closeTitle : 'Cerrar este widget',
		      confirmMsg : 'Remover este widget?',
		      cancelEditTitle : 'Cancelar edicion',
		      extendTitle : 'Extender este widget',
		      collapseTitle : 'Colapsar este widget'
		    },
		//permitir efectos al manipular los contenedores de widgets
		effects : {
		  effectDuration : 100,
		  widgetShow : 'slide',
		  widgetHide : 'slide',
		  widgetClose : 'slide',
		  widgetExtend : 'slide',
		  widgetCollapse : 'slide',
		  widgetOpenEdit : 'slide',
		  widgetCloseEdit : 'slide',
		  widgetCancelEdit : 'slide'
		},
		callbacks : {
			//al arrastrar un widget, actualizar el array de posiciones
			onDragStop: function(e,id){
				wid=id["item"]["context"]["id"];
				wid=wid.substring(10)
				updateArray(wid);
			},
			//al cerrar un widget, actualizar la DB, sac·ndolo del tab
			onClose: function(e, id){
				wid=id[0]["id"];
				wid=wid.substring(10);
				$.ajax({
				  url: "/containers/" + app["userData"]["containers"][wid]["id"] + ".js",
				  type: "POST",
				  data: "_method=delete",
				});
			 }
		}
	});
}
 function wakeTabs(){
 	var $tab_title_input = $('#tab_title'), $tab_content_input = $('#tab_content');
	var tab_counter = 2;

	// tabs init with a custom tab template and an "add" callback filling in the content
	var $tabs = $('#tabs').tabs({
		tabTemplate: '<li><a href="#{href}">#{label}</a> <span class="ui-icon ui-icon-close">Remove Tab</span></li>',
		add: function(event, ui) {
			var tab_content = $tab_content_input.val() || 'Tab '+tab_counter+' content.';
			$(ui.panel).append('<p>'+tab_content+'</p>');
		}
	});

	// modal dialog init: custom buttons and a "close" callback reseting the form inside
	/*var $dialog = $('#dialog').dialog({
		autoOpen: false,
		modal: true,
		buttons: {
			'Add': function() {
				addTab();
				$(this).dialog('close');
			},
			'Cancel': function() {
				$(this).dialog('close');
			}
		},
		open: function() {
			$tab_title_input.focus();
		},
		close: function() {
			$form[0].reset();
		}
	});*/

	// addTab form: calls addTab function on submit and closes the dialog
	/*var $form = $('form',$dialog).submit(function() {
		addTab();
		$dialog.dialog('close');
		return false;
	});

	// actual addTab function: adds new tab using the title input from the form above
	function addTab() {
		var tab_title = $tab_title_input.val() || 'Tab '+tab_counter;
		$tabs.tabs('add', '#tabs-'+tab_counter, tab_title);
		tab_counter++;
	}

	// addTab button: just opens the dialog
	$('#add_tab')
		.button()
		.click(function() {
			$dialog.dialog('open');
		});*/

	// close icon: removing the tab on click
	// note: closable tabs gonna be an option in the future - see http://dev.jqueryui.com/ticket/3924
	$('#tabs span.ui-icon-close').live('click', function() {
		var index = $('li',$tabs).index($(this).parent());
		$tabs.tabs('remove', index);
	});
 }
 
 //actualiza un array que mantiene los Ûrdenes de los widgets
 function updateArray(wid){
 	//columna nueva
	column=$("#container_"+wid).parent().attr("id");
	newcolumn= app["userData"]["containers"][wid]["col"]=column.substring(7,8);
	//id de los contenedores adyacentes
	wnext=$("#container_"+wid).next(".widget").attr("id");
	wprev=$("#container_"+wid).prev(".widget").attr("id");
	if(wprev)a=app["userData"]["containers"][wprev.substring(10)]["row"];
	else a=0;
	if(wnext)b=app["userData"]["containers"][wnext.substring(10)]["row"];
	else b=a+1000;
	//posicion nueva del widget
	newRow=parseInt((a+b)/2);
	if(newRow == a){
		resortContainer(wid);
	}else{
		app["userData"]["containers"][wid]["row"]=newRow;
	}
	
	//enviar AJAX
	$.ajax({
		//wid es un indice del array, obtenemos el valor de la BD correspondeinte
	  url: "/containers/" + app["userData"]["containers"][wid]["id"] + ".js",
	  type: "POST",
	  data: "_method=put&container[order]=" + newRow + "&container[column]=" + newcolumn,
	});
 }
 
function modalEdit (but,tab) {
	$("#submit").unbind()
	var output = $('#ex4c div.output');
	output.html("");
	if(but == 'e')
	{
		tid=app["userData"]["tabs"][tab]["id"];
		name=app["userData"]["tabs"][tab]["title"];
		cols=app["userData"]["tabs"][tab]["cols"];
		$('#jqm_pestanha').html('Editar pesta&ntilde;a');
		$("#tabname").val(name);
		$("#tabcols").val(cols);
		$('#submit').click(function() {
			$.ajax({
				url: "/tabs/" + app["userData"]["tabs"][tab]["id"] + ".js",
				type: "POST",
				dataType: "json",
			  data: "_method=put&tab[title]=" + $("#tabname").val() + "&tab[layout]=" + $("#tabcols").val() + "-0",
				success: function (data) {
					if (data['success'] == true)
					{
						output.html("Datos guardados correctamente!");
						app["userData"]["tabs"][tab]["title"] = $("#tabname").val();
						app["userData"]["tabs"][tab]["cols"] = $("#tabcols").val();
						app["userData"]["tabs"][tab]["layout"] = $("#tabcols").val()+"-0";
						$('#ex4c').jqmHide();
						createTabs();
						loadTheme();
					}
					else
					{
							output.html("Error al guardar los datos, intente de vuelta!");
					}
				}
			});
			return false;
    });
	}
	if(but == 'a')
	{
		//asumo que el tab id aca es 0, hay que agregar luego uno nuevo no se que id ponerle
		$('#jqm_pestanha').html('Agregar pesta&ntilde;a');
		$("#tabname").val('');
		$("#tabcols").val('');
		$('#submit').click(function() {
			$.ajax({
				url: "/tabs/",
				type: "POST",
				dataType: "json",
			  data: "commit=Save&tab[title]=" + $("#tabname").val() + "&tab[layout]=" + $("#tabcols").val() + "-0",
				success: function (data) {
					if (data['success'] == true)
					{
						output.html("Datos guardados correctamente!");
						newtab = new Array();
						newtab['id'] = data['tab']['id'];
						newtab['title'] = data['tab']['title'];
						newtab['layout'] = data['tab']['layout'];
						newtab['cols'] = parseInt(data['tab']['layout']);
						app["userData"]["tabs"].push(newtab);
						$('#ex4c').jqmHide();
						createTabs();	
						loadTheme();					
					}
					else
					{
							output.html("Error al guardar los datos, intente de vuelta!");
					}
				}
			});
			return false;
	    	//enviar ajax de agregar
	        output.html("Datos guardados! ");
	        createTabs();
	        return false;
    	});
	}
	$('#ex4c').jqmShow();
  
    
};
 
//completa el cuadro de edit
 function setPrefs(feed,editOb,BW, prefs){
	//a“adir al div de edit
	editArea="<form>";
	//para cada preferencia del widget
 	$.each( feed, function(i,item){
		// segun los tipos de preferencias
		switch (item.type) {
			case "range"://rango de valores
				editArea = editArea + item.label+'<br /><input name="'+item.name+'" id="wid-edit-input'+i+'" value="'+(prefs[item.name] == undefined ? item.defaultValue : prefs[item.name]) +'"></input><br />';
				break;
			case "text"://rango de valores
				if (item.defaultValue == undefined)
					item.defaultValue = '';

				editArea = editArea + item.label+'<br /><input name="'+item.name+'" id="wid-edit-input'+i+'" value="'+ (prefs[item.name] == undefined ? item.defaultValue : prefs[item.name]) + '"></input><br />';
				break;
			case "list"://lista de valores
				opList='<br /><select name="'+item.name+'" id="wid-edit-input'+i+'">';
				$.each(item.options, function(j,op){
					opList= opList + '<option value="'+op.value+'"' + (prefs[item.name] != undefined && prefs[item.name] == op.value ? 'selected="selected"' : '') + '>'+op.label+'</option>';
				});
				opList=opList+"</select><br />"
				editArea = editArea + item.label+ opList;
				break;
			case "boolean"://checkbox
				var checked= '';
				if (prefs[item.name] != undefined && 
					(prefs[item.name] == 'true' || prefs[item.name] == 'on' || prefs[item.name] == 1))
					checked = 'checked="checked"';
				else if(item.defaultValue == "true") checked="checked";
				editArea= editArea +'<input type="checkbox" name="'+item.name+'" '+checked+' >'+ item.label +'<br />';
				break;
			case "hidden"://oculto
				//no hacemos nada
				break;
		}
		});
	//link para aceptar los cambios
	//editArea = editArea + '<a href="#" class="myWidget-sender">Send</a>';
	editArea = editArea + '<button class="myWidget-sender">Enviar</button></form>';
	editObj.append(editArea);
	//agregamos una funcion javascript a este link
	editObj.children().children('.myWidget-sender').click( function(){
		var thisObj=$(this).parent();
		var prefs='{';
		var cid = thisObj.parent().parent().parent().attr('id').substring(9);
		thisObj.children("input[type!='checkbox']").each( function(){
			//si es un input
			prefs = prefs + '"' + $(this).attr("name") + '":"' + $(this).val()+'", ';
		});
		thisObj.children("input[type='checkbox']:checked").each( function(){
			//si es un checkbox seleccionado
			prefs = prefs + '"' + $(this).attr("name") +  '":"true", ';
		});
		thisObj.children("input[type='checkbox']:not(:checked)").each( function(){
			//si es un checkbox no seleccionado
			prefs = prefs + '"' + $(this).attr("name") +  '":"false", ';
		});
		thisObj.children("select").each( function(){
			//si es un select
			if($(this).val())
				prefs = prefs + '"' + $(this).attr("name") +  '":"' + $(this).val()+'", ';
		});
		prefs=prefs.substring(0,prefs.length - 2);
		prefs = prefs + '}';

		var tehform = $.parseJSON(prefs);
    var o = {};
		$.each(tehform, function(key, value) { 
			o["widgetparams[" + key + "]"] = value || '';
		});

		$.ajax({
			url: "/containers/" + cid + "/save_preferences.js",
			type: "POST",
			dataType: "json",
			data: $.param(o),
			success: function (data) {
				if (data['success'] == true)
				{
					BW.setPreferencesValues($.parseJSON(prefs));
				}
			}
		});
		return false;
	});
 }
 
 function resortContainer(wid){
	c=0;
	$("#container_"+wid).parent().children(".widget").each( function(){
		++c;
		container=$(this).attr("id").substring(10);
		app["userData"]["containers"][container]["row"]=c*1000;
	});
 }
 
    function getTab(txt){
		$("#tab-list .name").parent().removeClass("selected");
		$("#tab-list .name:contains("+txt+")").parent().addClass("selected");
		listLess();
   }
   /*function showTab(id){
		$("#tab-list .selected").removeClass("selected");
		$("#ts_"+id).addClass("selected");
		tabVal=id;
		listLess();
		loadWidgets();
   }
   function listMore(){
		$("#tab-selection").css("display","block");
		$("#tab-list .more").addClass("less");
		$("#tab-list .more").removeClass("more");
		$("#tab-list .less").unbind();
		$("#tab-list .less").bind( 'click', function(){listLess( )});
	}
	function listLess(){
		$("#tab-selection").css("display","none");
		$("#tab-list .less").addClass("more");
		$("#tab-list .less").removeClass("less");
		$("#tab-list .more").unbind();
		$("#tab-list .more").bind('click', function(){listMore()});
	}*/
	
	function uiTabsJs(){
		var tabId = 0,
	listId = 0;

function getNextTabId() {
	return ++tabId;
}

function getNextListId() {
	return ++listId;
}

$.widget("ui.tabs", {
	options: {
		add: null,
		ajaxOptions: null,
		cache: false,
		cookie: null, // e.g. { expires: 7, path: '/', domain: 'jquery.com', secure: true }
		collapsible: false,
		disable: null,
		disabled: [],
		enable: null,
		event: 'click',
		fx: null, // e.g. { height: 'toggle', opacity: 'toggle', duration: 200 }
		idPrefix: 'ui-tabs-',
		load: null,
		panelTemplate: '<div></div>',
		remove: null,
		select: null,
		show: null,
		spinner: '<em>Loading&#8230;</em>',
		tabTemplate: '<li><a href="#{href}"><span>#{label}</span></a></li>'
	},
	_create: function() {
		this._tabify(true);
	},

	_setOption: function(key, value) {
		if (key == 'selected') {
			if (this.options.collapsible && value == this.options.selected) {
				return;
			}
			this.select(value);
		}
		else {
			this.options[key] = value;
			this._tabify();
		}
	},

	_tabId: function(a) {
		return a.title && a.title.replace(/\s/g, '_').replace(/[^A-Za-z0-9\-_:\.]/g, '') ||
			this.options.idPrefix + getNextTabId();
	},

	_sanitizeSelector: function(hash) {
		return hash.replace(/:/g, '\\:'); // we need this because an id may contain a ":"
	},

	_cookie: function() {
		var cookie = this.cookie || (this.cookie = this.options.cookie.name || 'ui-tabs-' + getNextListId());
		return $.cookie.apply(null, [cookie].concat($.makeArray(arguments)));
	},

	_ui: function(tab, panel) {
		return {
			tab: tab,
			panel: panel,
			index: this.anchors.index(tab)
		};
	},

	_cleanup: function() {
		// restore all former loading tabs labels
		this.lis.filter('.ui-state-processing').removeClass('ui-state-processing')
				.find('span:data(label.tabs)')
				.each(function() {
					var el = $(this);
					el.html(el.data('label.tabs')).removeData('label.tabs');
				});
	},

	_tabify: function(init) {

		this.list = this.element.find('ol,ul').eq(0);
		this.lis = $('li:has(a[href])', this.list);
		this.anchors = this.lis.map(function() { return $('a', this)[0]; });
		this.panels = $([]);

		var self = this, o = this.options;

		var fragmentId = /^#.+/; // Safari 2 reports '#' for an empty hash
		this.anchors.each(function(i, a) {
			var href = $(a).attr('href');

			// For dynamically created HTML that contains a hash as href IE < 8 expands
			// such href to the full page url with hash and then misinterprets tab as ajax.
			// Same consideration applies for an added tab with a fragment identifier
			// since a[href=#fragment-identifier] does unexpectedly not match.
			// Thus normalize href attribute...
			var hrefBase = href.split('#')[0], baseEl;
			if (hrefBase && (hrefBase === location.toString().split('#')[0] ||
					(baseEl = $('base')[0]) && hrefBase === baseEl.href)) {
				href = a.hash;
				a.href = href;
			}

			// inline tab
			if (fragmentId.test(href)) {
				self.panels = self.panels.add(self._sanitizeSelector(href));
			}

			// remote tab
			else if (href != '#') { // prevent loading the page itself if href is just "#"
				$.data(a, 'href.tabs', href); // required for restore on destroy

				// TODO until #3808 is fixed strip fragment identifier from url
				// (IE fails to load from such url)
				$.data(a, 'load.tabs', href.replace(/#.*$/, '')); // mutable data

				var id = self._tabId(a);
				a.href = '#' + id;
				var $panel = $('#' + id);
				if (!$panel.length) {
					$panel = $(o.panelTemplate).attr('id', id).addClass('ui-tabs-panel ui-widget-content ui-corner-bottom')
						.insertAfter(self.panels[i - 1] || self.list);
					$panel.data('destroy.tabs', true);
				}
				self.panels = self.panels.add($panel);
			}

			// invalid tab href
			else {
				o.disabled.push(i);
			}
		});

		// initialization from scratch
		if (init) {

			// attach necessary classes for styling
			this.element.addClass('ui-tabs ui-widget ui-widget-content ui-corner-all');
			this.list.addClass('ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all');
			this.lis.addClass('ui-state-default ui-corner-top');
			this.panels.addClass('ui-tabs-panel ui-widget-content ui-corner-bottom');

			// Selected tab
			// use "selected" option or try to retrieve:
			// 1. from fragment identifier in url
			// 2. from cookie
			// 3. from selected class attribute on <li>
			if (o.selected === undefined) {
				if (location.hash) {
					this.anchors.each(function(i, a) {
						if (a.hash == location.hash) {
							o.selected = i;
							return false; // break
						}
					});
				}
				if (typeof o.selected != 'number' && o.cookie) {
					o.selected = parseInt(self._cookie(), 10);
				}
				if (typeof o.selected != 'number' && this.lis.filter('.ui-tabs-selected').length) {
					o.selected = this.lis.index(this.lis.filter('.ui-tabs-selected'));
				}
				o.selected = o.selected || (this.lis.length ? 0 : -1);
			}
			else if (o.selected === null) { // usage of null is deprecated, TODO remove in next release
				o.selected = -1;
			}

			// sanity check - default to first tab...
			o.selected = ((o.selected >= 0 && this.anchors[o.selected]) || o.selected < 0) ? o.selected : 0;

			// Take disabling tabs via class attribute from HTML
			// into account and update option properly.
			// A selected tab cannot become disabled.
			o.disabled = $.unique(o.disabled.concat(
				$.map(this.lis.filter('.ui-state-disabled'),
					function(n, i) { return self.lis.index(n); } )
			)).sort();

			if ($.inArray(o.selected, o.disabled) != -1) {
				o.disabled.splice($.inArray(o.selected, o.disabled), 1);
			}

			// highlight selected tab
			this.panels.addClass('ui-tabs-hide');
			this.lis.removeClass('ui-tabs-selected ui-state-active');
			if (o.selected >= 0 && this.anchors.length) { // check for length avoids error when initializing empty list
				this.panels.eq(o.selected).removeClass('ui-tabs-hide');
				this.lis.eq(o.selected).addClass('ui-tabs-selected ui-state-active');

				// seems to be expected behavior that the show callback is fired
				self.element.queue("tabs", function() {
					self._trigger('show', null, self._ui(self.anchors[o.selected], self.panels[o.selected]));
				});
				
				this.load(o.selected);
			}

			// clean up to avoid memory leaks in certain versions of IE 6
			$(window).bind('unload', function() {
				self.lis.add(self.anchors).unbind('.tabs');
				self.lis = self.anchors = self.panels = null;
			});

		}
		// update selected after add/remove
		else {
			o.selected = this.lis.index(this.lis.filter('.ui-tabs-selected'));
		}

		// update collapsible
		this.element[o.collapsible ? 'addClass' : 'removeClass']('ui-tabs-collapsible');

		// set or update cookie after init and add/remove respectively
		if (o.cookie) {
			this._cookie(o.selected, o.cookie);
		}

		// disable tabs
		for (var i = 0, li; (li = this.lis[i]); i++) {
			$(li)[$.inArray(i, o.disabled) != -1 &&
				!$(li).hasClass('ui-tabs-selected') ? 'addClass' : 'removeClass']('ui-state-disabled');
		}

		// reset cache if switching from cached to not cached
		if (o.cache === false) {
			this.anchors.removeData('cache.tabs');
		}

		// remove all handlers before, tabify may run on existing tabs after add or option change
		this.lis.add(this.anchors).unbind('.tabs');

		if (o.event != 'mouseover') {
			var addState = function(state, el) {
				if (el.is(':not(.ui-state-disabled)')) {
					el.addClass('ui-state-' + state);
				}
			};
			var removeState = function(state, el) {
				el.removeClass('ui-state-' + state);
			};
			this.lis.bind('mouseover.tabs', function() {
				addState('hover', $(this));
			});
			this.lis.bind('mouseout.tabs', function() {
				removeState('hover', $(this));
			});
			this.anchors.bind('focus.tabs', function() {
				addState('focus', $(this).closest('li'));
			});
			this.anchors.bind('blur.tabs', function() {
				removeState('focus', $(this).closest('li'));
			});
		}

		// set up animations
		var hideFx, showFx;
		if (o.fx) {
			if ($.isArray(o.fx)) {
				hideFx = o.fx[0];
				showFx = o.fx[1];
			}
			else {
				hideFx = showFx = o.fx;
			}
		}

		// Reset certain styles left over from animation
		// and prevent IE's ClearType bug...
		function resetStyle($el, fx) {
			$el.css({ display: '' });
			if (!$.support.opacity && fx.opacity) {
				$el[0].style.removeAttribute('filter');
			}
		}

		// Show a tab...
		var showTab = showFx ?
			function(clicked, $show) {
				$(clicked).closest('li').addClass('ui-tabs-selected ui-state-active');
				$show.hide().removeClass('ui-tabs-hide') // avoid flicker that way
					.animate(showFx, showFx.duration || 'normal', function() {
						resetStyle($show, showFx);
						self._trigger('show', null, self._ui(clicked, $show[0]));
					});
			} :
			function(clicked, $show) {
				$(clicked).closest('li').addClass('ui-tabs-selected ui-state-active');
				$show.removeClass('ui-tabs-hide');
				self._trigger('show', null, self._ui(clicked, $show[0]));
			};

		// Hide a tab, $show is optional...
		var hideTab = hideFx ?
			function(clicked, $hide) {
				$hide.animate(hideFx, hideFx.duration || 'normal', function() {
					self.lis.removeClass('ui-tabs-selected ui-state-active');
					$hide.addClass('ui-tabs-hide');
					resetStyle($hide, hideFx);
					self.element.dequeue("tabs");
				});
			} :
			function(clicked, $hide, $show) {
				self.lis.removeClass('ui-tabs-selected ui-state-active');
				$hide.addClass('ui-tabs-hide');
				self.element.dequeue("tabs");
			};

		// attach tab event handler, unbind to avoid duplicates from former tabifying...
		this.anchors.bind(o.event + '.tabs', function() {
			var el = this, $li = $(this).closest('li'), $hide = self.panels.filter(':not(.ui-tabs-hide)'),
					$show = $(self._sanitizeSelector(this.hash));

			// If tab is already selected and not collapsible or tab disabled or
			// or is already loading or click callback returns false stop here.
			// Check if click handler returns false last so that it is not executed
			// for a disabled or loading tab!
			if (($li.hasClass('ui-tabs-selected') && !o.collapsible) ||
				$li.hasClass('ui-state-disabled') ||
				$li.hasClass('ui-state-processing') ||
				self._trigger('select', null, self._ui(this, $show[0])) === false) {
				this.blur();
				return false;
			}

			o.selected = self.anchors.index(this);

			self.abort();

			// if tab may be closed
			if (o.collapsible) {
				if ($li.hasClass('ui-tabs-selected')) {
					o.selected = -1;

					if (o.cookie) {
						self._cookie(o.selected, o.cookie);
					}

					self.element.queue("tabs", function() {
						hideTab(el, $hide);
					}).dequeue("tabs");
					
					this.blur();
					return false;
				}
				else if (!$hide.length) {
					if (o.cookie) {
						self._cookie(o.selected, o.cookie);
					}
					
					self.element.queue("tabs", function() {
						showTab(el, $show);
					});

					self.load(self.anchors.index(this)); // TODO make passing in node possible, see also http://dev.jqueryui.com/ticket/3171
					
					this.blur();
					return false;
				}
			}

			if (o.cookie) {
				self._cookie(o.selected, o.cookie);
			}

			// show new tab
			if ($show.length) {
				if ($hide.length) {
					self.element.queue("tabs", function() {
						hideTab(el, $hide);
					});
				}
				self.element.queue("tabs", function() {
					showTab(el, $show);
				});
				
				self.load(self.anchors.index(this));
			}
			else {
				throw 'jQuery UI Tabs: Mismatching fragment identifier.';
			}

			// Prevent IE from keeping other link focussed when using the back button
			// and remove dotted border from clicked link. This is controlled via CSS
			// in modern browsers; blur() removes focus from address bar in Firefox
			// which can become a usability and annoying problem with tabs('rotate').
			if ($.browser.msie) {
				this.blur();
			}

		});

		// disable click in any case
		this.anchors.bind('click.tabs', function(){return false;});

	},

	destroy: function() {
		var o = this.options;

		this.abort();
		
		this.element.unbind('.tabs')
			.removeClass('ui-tabs ui-widget ui-widget-content ui-corner-all ui-tabs-collapsible')
			.removeData('tabs');

		this.list.removeClass('ui-tabs-nav ui-helper-reset ui-helper-clearfix ui-widget-header ui-corner-all');

		this.anchors.each(function() {
			var href = $.data(this, 'href.tabs');
			if (href) {
				this.href = href;
			}
			var $this = $(this).unbind('.tabs');
			$.each(['href', 'load', 'cache'], function(i, prefix) {
				$this.removeData(prefix + '.tabs');
			});
		});

		this.lis.unbind('.tabs').add(this.panels).each(function() {
			if ($.data(this, 'destroy.tabs')) {
				$(this).remove();
			}
			else {
				$(this).removeClass([
					'ui-state-default',
					'ui-corner-top',
					'ui-tabs-selected',
					'ui-state-active',
					'ui-state-hover',
					'ui-state-focus',
					'ui-state-disabled',
					'ui-tabs-panel',
					'ui-widget-content',
					'ui-corner-bottom',
					'ui-tabs-hide'
				].join(' '));
			}
		});

		if (o.cookie) {
			this._cookie(null, o.cookie);
		}

		return this;
	},

	add: function(url, label, index) {
		if (index === undefined) {
			index = this.anchors.length; // append by default
		}

		var self = this, o = this.options,
			$li = $(o.tabTemplate.replace(/#\{href\}/g, url).replace(/#\{label\}/g, label)),
			id = !url.indexOf('#') ? url.replace('#', '') : this._tabId($('a', $li)[0]);

		$li.addClass('ui-state-default ui-corner-top').data('destroy.tabs', true);

		// try to find an existing element before creating a new one
		var $panel = $('#' + id);
		if (!$panel.length) {
			$panel = $(o.panelTemplate).attr('id', id).data('destroy.tabs', true);
		}
		$panel.addClass('ui-tabs-panel ui-widget-content ui-corner-bottom ui-tabs-hide');

		if (index >= this.lis.length) {
			$li.appendTo(this.list);
			$panel.appendTo(this.list[0].parentNode);
		}
		else {
			$li.insertBefore(this.lis[index]);
			$panel.insertBefore(this.panels[index]);
		}

		o.disabled = $.map(o.disabled,
			function(n, i) { return n >= index ? ++n : n; });

		this._tabify();

		if (this.anchors.length == 1) { // after tabify
			o.selected = 0;
			$li.addClass('ui-tabs-selected ui-state-active');
			$panel.removeClass('ui-tabs-hide');
			this.element.queue("tabs", function() {
				self._trigger('show', null, self._ui(self.anchors[0], self.panels[0]));
			});
				
			this.load(0);
		}

		// callback
		this._trigger('add', null, this._ui(this.anchors[index], this.panels[index]));
		return this;
	},

	remove: function(index) {
		var o = this.options, $li = this.lis.eq(index).remove(),
			$panel = this.panels.eq(index).remove();

		// If selected tab was removed focus tab to the right or
		// in case the last tab was removed the tab to the left.
		if ($li.hasClass('ui-tabs-selected') && this.anchors.length > 1) {
			this.select(index + (index + 1 < this.anchors.length ? 1 : -1));
		}

		o.disabled = $.map($.grep(o.disabled, function(n, i) { return n != index; }),
			function(n, i) { return n >= index ? --n : n; });

		this._tabify();

		// callback
		this._trigger('remove', null, this._ui($li.find('a')[0], $panel[0]));
		return this;
	},

	enable: function(index) {
		var o = this.options;
		if ($.inArray(index, o.disabled) == -1) {
			return;
		}

		this.lis.eq(index).removeClass('ui-state-disabled');
		o.disabled = $.grep(o.disabled, function(n, i) { return n != index; });

		// callback
		this._trigger('enable', null, this._ui(this.anchors[index], this.panels[index]));
		return this;
	},

	disable: function(index) {
		var self = this, o = this.options;
		if (index != o.selected) { // cannot disable already selected tab
			this.lis.eq(index).addClass('ui-state-disabled');

			o.disabled.push(index);
			o.disabled.sort();

			// callback
			this._trigger('disable', null, this._ui(this.anchors[index], this.panels[index]));
		}

		return this;
	},

	select: function(index) {
		if (typeof index == 'string') {
			index = this.anchors.index(this.anchors.filter('[href$=' + index + ']'));
		}
		else if (index === null) { // usage of null is deprecated, TODO remove in next release
			index = -1;
		}
		if (index == -1 && this.options.collapsible) {
			index = this.options.selected;
		}

		this.anchors.eq(index).trigger(this.options.event + '.tabs');
		return this;
	},

	load: function(index) {
		var self = this, o = this.options, a = this.anchors.eq(index)[0], url = $.data(a, 'load.tabs');

		this.abort();

		// not remote or from cache
		if (!url || this.element.queue("tabs").length !== 0 && $.data(a, 'cache.tabs')) {
			this.element.dequeue("tabs");
			return;
		}

		// load remote from here on
		this.lis.eq(index).addClass('ui-state-processing');

		if (o.spinner) {
			var span = $('span', a);
			span.data('label.tabs', span.html()).html(o.spinner);
		}

		this.xhr = $.ajax($.extend({}, o.ajaxOptions, {
			url: url,
			success: function(r, s) {
				$(self._sanitizeSelector(a.hash)).html(r);

				// take care of tab labels
				self._cleanup();

				if (o.cache) {
					$.data(a, 'cache.tabs', true); // if loaded once do not load them again
				}

				// callbacks
				self._trigger('load', null, self._ui(self.anchors[index], self.panels[index]));
				try {
					o.ajaxOptions.success(r, s);
				}
				catch (e) {}
			},
			error: function(xhr, s, e) {
				// take care of tab labels
				self._cleanup();

				// callbacks
				self._trigger('load', null, self._ui(self.anchors[index], self.panels[index]));
				try {
					// Passing index avoid a race condition when this method is
					// called after the user has selected another tab.
					// Pass the anchor that initiated this request allows
					// loadError to manipulate the tab content panel via $(a.hash)
					o.ajaxOptions.error(xhr, s, index, a);
				}
				catch (e) {}
			}
		}));

		// last, so that load event is fired before show...
		self.element.dequeue("tabs");

		return this;
	},

	abort: function() {
		// stop possibly running animations
		this.element.queue([]);
		this.panels.stop(false, true);

		// "tabs" queue must not contain more than two elements,
		// which are the callbacks for the latest clicked tab...
		this.element.queue("tabs", this.element.queue("tabs").splice(-2, 2));

		// terminate pending requests from other tabs
		if (this.xhr) {
			this.xhr.abort();
			delete this.xhr;
		}

		// take care of tab labels
		this._cleanup();
		return this;
	},

	url: function(index, url) {
		this.anchors.eq(index).removeData('cache.tabs').data('load.tabs', url);
		return this;
	},

	length: function() {
		return this.anchors.length;
	}

});

$.extend($.ui.tabs, {
	version: '1.8.2'
});

/*
 * Tabs Extensions
 */

/*
 * Rotate
 */
$.extend($.ui.tabs.prototype, {
	rotation: null,
	rotate: function(ms, continuing) {

		var self = this, o = this.options;
		
		var rotate = self._rotate || (self._rotate = function(e) {
			clearTimeout(self.rotation);
			self.rotation = setTimeout(function() {
				var t = o.selected;
				self.select( ++t < self.anchors.length ? t : 0 );
			}, ms);
			
			if (e) {
				e.stopPropagation();
			}
		});
		
		var stop = self._unrotate || (self._unrotate = !continuing ?
			function(e) {
				if (e.clientX) { // in case of a true click
					self.rotate(null);
				}
			} :
			function(e) {
				t = o.selected;
				rotate();
			});

		// start rotation
		if (ms) {
			this.element.bind('tabsshow', rotate);
			this.anchors.bind(o.event + '.tabs', stop);
			rotate();
		}
		// stop rotation
		else {
			clearTimeout(self.rotation);
			this.element.unbind('tabsshow', rotate);
			this.anchors.unbind(o.event + '.tabs', stop);
			delete this._rotate;
			delete this._unrotate;
		}

		return this;
	}
});
	}