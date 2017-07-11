<$var $ya_script='<script type="text/javascript" src="//api-maps.yandex.ru/2.1/?lang=ru-RU&load=Map,Placemark,GeoObjectCollection,map.addon.balloon,geoObject.addon.balloon,package.controls,templateLayoutFactory,overlay.html.Placemark" ></script>'$>
<$$ya_script|jsToBottom$>

<div id="<$$idMap$>" style="<$$styleMapBlock$>" class="<$$classMapBlock$>"></div>

<$if $filtersFormItems?$>
	<div class="<$$classFiltersBlock$>" style="<$$styleFiltersBlock$>">
		<form id="<$$idFiltersForm$>" class="ymFiltersForm" action="<$$id|url:['scheme'=>'full']$>" method="POST">
			<$$filtersFormItems$>
			<div class="loader"></div>
		</form>
	</div>
<$/if$>

<div style="clear:both"></div>


<style>
.search-map-result-view {
display: inline-block;
white-space: nowrap;
position: relative;
top: -13.5px;
left: -13.5px;
height: 27px;
}
.search-map-result-view._active {
top: -42px;
}

.search-map-result-view__overlay {
position: absolute;
width: 100%;
height: 100%;
z-index: 3;
cursor: pointer;
}

.search-map-result-view__icon {
background: url("//yastatic.net/maps-beta/_/QGuTq1D4vadJPJijE7xfGoI0UBY.svg");
width: 27px;
height: 27px;
}
.search-map-result-view__icon {
display: inline-block;
position: relative;
vertical-align: middle;
z-index: 2;
}
.search-map-result-view._active .search-map-result-view__icon {
background: url("//yastatic.net/maps-beta/_/ZDo_aSO8szfWh3gPYVWHwgyDa_E.svg");
width: 34px;
height: 42px;
}
.search-map-result-view__title {
height: 27px;
line-height: 27px;
}
.search-map-result-view__title {
background: rgba(255,255,255,.89);
display: inline-block;
vertical-align: top;
z-index: 1;
padding: 0 5px 0 19px;
margin-left: -14px;
border-radius: 5px;
border:1px solid #ddd;
max-width: none;
text-overflow: ellipsis;
overflow: hidden;
font-size:13px;
}
.search-map-result-view._active .search-map-result-view__title:not(:empty) {
display: inline-block;
margin-left: -21px;
}
</style>

<$$yamapScript|jsToBottom$>
