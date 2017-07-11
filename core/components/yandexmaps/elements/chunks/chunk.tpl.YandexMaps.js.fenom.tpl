<script type="text/javascript">
var ymFormId = '#<$$idFiltersForm$>';
var ymFormAction = $(ymFormId).attr('action');
var ymFormActionParams = "ymJSON=1";

ymaps.ready()
	.done(function (ymaps) {
	    var jsonObjectsMode = <$$jsonObjectsMode$>;
	    if(jsonObjectsMode)
	    {
	    	ymFormAction="assets/components/yandexmaps/connector.php";
	    	ymFormActionParams = "action=getmap&id=<$$idMap$>&resource=<$''|resource:'id'$>";
	    }
	    
		var mapCenter<$$idMap$> = <$$centerCoords$>,
			myMap<$$idMap$> = new ymaps.Map('<$$idMap$>', {
				center: mapCenter<$$idMap$>,
				zoom: <$$zoom$>,
				controls: ['zoomControl']
			});
		
		myMap<$$idMap$>.controls.add(new ymaps.control.TypeSelector({ options: { position: { left: 10, top: 10 }}}));
		
		var openBaloonsOnStart = <$$openBaloonsOnStart$>;
		var Layouts = <$$Layouts$>;
		for(var layout in Layouts)
		{
		    if(!Layouts.hasOwnProperty(layout))continue;
		    ymaps.layout.storage.add(layout, ymaps.templateLayoutFactory.createClass(Layouts[layout]));
		}
        
		$.getJSON( ymFormAction , ymFormActionParams ).done( function (json) {
			window.geoObjects = ymaps.geoQuery(json);
		    if(jsonObjectsMode)
		    {
		        window.clusters = geoObjects.search("geometry.type == 'Point'").clusterize(<$$Clusterize$>);
                myMap<$$idMap$>.geoObjects.add(clusters);
		        /*window.geoObjects.addToMap(myMap<$$idMap$>);*/
		    }
			else
			{
			    window.clusters = geoObjects.search("geometry.type == 'Point'").clusterize({ preset: 'islands#invertedVioletClusterIcons'});
    			myMap<$$idMap$>.geoObjects.add(clusters);
    			
    			
    			geoObjects.then(function () {
    
    				myMap<$$idMap$>.geoObjects.options.set({
    					pointOverlay: ymaps.overlay.html.Placemark,
    					preset: 'twirl#stretchyIcon',
    					pane: 'overlaps',
    					iconLayout: ymaps.templateLayoutFactory.createClass('<div id="marker_$[properties.modx_id]" class="$[properties.imageClass] _active"><div class="$[properties.imageClass]__overlay"></div><div class="$[properties.imageClass]__icon"></div><div class="$[properties.imageClass]__title">[if properties.iconContent]<i>$[properties.iconContent]</i>[else]$[properties.hintContent][endif]</div></div>')
    				});
    			});
			}
			if(openBaloonsOnStart)geoObjects.get(0).balloon.open();
			myMap<$$idMap$>.behaviors.disable('scrollZoom');
			<$if $checkZoomRange==0||$checkZoomRange=='false'||$checkZoomRange==''$>
			<$else$>
				geoObjects.applyBoundsToMap(myMap<$$idMap$>, {
					checkZoomRange: true
				});
			<$/if$>
		}).fail(function (){ console.log(this,jsonObjectsMode);});
		
		
		/* >> Обработка события клика на маркере*/
		myMap<$$idMap$>.geoObjects.events.add('click', function (e)
		{
			var object = e.get('target');
			var goToRes = <$$goToRes$>;
			var goToResBlank = <$$goToResBlank$>;
			var goToJS = <$if $goToJS==0||$goToJS=='false'||$goToJS==''$>''<$else$>1<$/if$>;
			
			if( goToRes !== 'undefined' && goToRes !== 'null' && goToRes !== '' && goToRes !== 0 )
			{
				if( typeof object.properties.get(0).modx_id !== 'undefined'
					&& object.properties.get(0).modx_id !== 'null' )
				{
					var modx_id = object.properties.get(0).modx_id;
					/*console.log( modx_id );*/
					
					if( goToJS !== 'undefined' && goToJS !== 'null' && goToJS !== '' && goToJS !== 0 )
					{
						<$if $goToJS==0||$goToJS=='false'||$goToJS==''$> <$else$><$$goToJS$><$/if$>;
					}
					else if( goToResBlank !== 'undefined' && goToResBlank !== 'null' && goToResBlank !== '' && goToResBlank !== 0 )
					{
						window.open( '<$'site_url'|option$>index.php?id=' + modx_id );
					}
					else
					{
						window.location.href = '<$'site_url'|option$>index.php?id=' + modx_id;
					}
					
					e.preventDefault(); /* остановим открытие балуна*/
				}
			}
		});
		
		<$if $filtersFormItems?$>
			$(".<$$classFiltersItem$>").click(function() {
				var thisItem = this;
				var filtersItemId = $(this).attr('id'); /* id кликнутого элемента*/
				
				$(ymFormId).find('.loader').show(); /* покажем лоадер*/
				
				/* >> Если нужно скрыть элементы*/
				if( $(thisItem).hasClass('ymFiltersItemHide') )
				{
					$(ymFormId).find('#checkbox_' + filtersItemId).val('0'); /* ставим input[type=hidden] - val*/
					$(thisItem).removeClass('ymFiltersItemHide').addClass('ymFiltersItemShow'); /* ставим нужный класс*/
					
					/* >> Собираем строку из формы для передачи аяксом*/
					var ymFormData = $(ymFormId).serializeArray(), ymFormDataString = '';
					
					$.each(ymFormData, function(i_1, val_1) {
						$.each(val_1, function(i_2, val_2) {
							if(i_2 == 'name') {
								ymFormDataString += val_2 + '=';
							} else if(i_2 == 'value') {
								ymFormDataString += val_2 + '&';
							}
						});
					});
					/* << Собираем строку из формы для передачи аяксом*/
					
					$.getJSON( ymFormAction , ymFormDataString )
						.done( function (json)
						{
							window.geoObjects2 = ymaps.geoQuery(json);
							window.clusters2 = geoObjects2.search("geometry.type == 'Point'").clusterize();
							myMap<$$idMap$>.geoObjects.add(clusters2);
							
							geoObjects2.applyBoundsToMap(myMap<$$idMap$>, {
								checkZoomRange: true
							});
							
							geoObjects.remove(geoObjects2).removeFromMap(myMap<$$idMap$>); /* удаляем текущие объекты с карты*/
							myMap<$$idMap$>.geoObjects.remove(clusters);
							geoObjects = geoObjects2; /* колдуем*/
							clusters = clusters2; /* колдуем*/
							geoObjects2=''; /* колдуем*/
							clusters2=''; /* колдуем*/
							
							$(ymFormId).find('.loader').hide(); /* спрячем лоадер*/
							$(thisItem).parent().find('.ymFiltersWrapper').slideUp(); /* прячем подпункты, если есть..*/
						});
				} /* << Если нужно скрыть элементы*/
				else
				{ /* >> Если нужно показать элементы*/
					$(ymFormId).find('#checkbox_' + filtersItemId).val('1'); /* ставим input[type=hidden] - val*/
					$(thisItem).removeClass('ymFiltersItemShow').addClass('ymFiltersItemHide'); /* ставим нужный класс*/
					
					/* >> Собираем строку из формы для передачи аяксом*/
					var ymFormData = $(ymFormId).serializeArray(), ymFormDataString = '';
					
					$.each(ymFormData, function(i_1, val_1) {
						$.each(val_1, function(i_2, val_2) {
							if(i_2 == 'name') {
								ymFormDataString += val_2 + '=';
							} else if(i_2 == 'value') {
								ymFormDataString += val_2 + '&';
							}
						});
					});
					/* << Собираем строку из формы для передачи аяксом*/
					
					$.getJSON( ymFormAction , ymFormDataString )
						.done( function (json)
						{
							window.geoObjects2 = ymaps.geoQuery(json);
							window.clusters2 = geoObjects2.search("geometry.type == 'Point'").clusterize();
							myMap<$$idMap$>.geoObjects.add(clusters2);
							
							geoObjects2.applyBoundsToMap(myMap<$$idMap$>, {
								checkZoomRange: true
							});
							
							geoObjects.remove(geoObjects2).removeFromMap(myMap<$$idMap$>); /* удаляем текущие объекты с карты*/
							myMap<$$idMap$>.geoObjects.remove(clusters);
							geoObjects = geoObjects2; /* колдуем*/
							clusters = clusters2; /* колдуем*/
							geoObjects2=''; /* колдуем*/
							clusters2=''; /* колдуем*/
							
							$(ymFormId).find('.loader').hide(); /* спрячем лоадер*/
							$(thisItem).parent().find('.ymFiltersWrapper').slideDown(); /* покажем подпункты, если есть..*/
						});
				}
				/* << Если нужно показать элементы*/
			});
		<$/if$>
	});
</script>
