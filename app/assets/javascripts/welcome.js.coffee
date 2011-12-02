# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

class Maps
  constructor: ->
    @scriptedMove = false
    
    mapConfig = {
      pan: true,
      map_type: true,
      zoom: 'small'
    }
    loc = {
      latlng: new mxn.LatLonPoint(64.859,-147.849),
      zoom: 4
    }
    
    @google = @createMap 'google', 'googlev3', mapConfig, loc, @moveGoogle
    @google.setMapType mxn.Mapstraction.HYBRID
    @google.setOption('enableScrollWheelZoom', true);
    
    @bdl = @createMap 'bdl', 'googlev3', mapConfig, loc, @moveBdl
    @bdl.addTileLayer('http://swmha.gina.alaska.edu/tilesrv/bdl/tile/{X}/{Y}/{Z}.png', 1.0, 'GINA BDL', 1, 21, true)
    @bdl.maps[@bdl.api].setMapTypeId('tile0')
    @bdl.setOption('enableScrollWheelZoom', true);
    
    @bing = @createMap 'bing', 'microsoft', mapConfig, loc, @moveBing
    @bing.setMapType mxn.Mapstraction.HYBRID

    return true
    
  createMap: (id, type, mapConfig, loc, moveHandler) ->
    map = new mxn.Mapstraction id, type
    map.addControls mapConfig
    map.setCenterAndZoom loc.latlng, loc.zoom      
      
    if moveHandler
      map.endPan.addHandler(moveHandler.bind(@))
      map.changeZoom.addHandler(moveHandler.bind(@))

    return map
      
  moveMaps: (center, zoom, except) ->
    @bdl.setCenterAndZoom(center, zoom) unless except == 'bdl'
    @google.setCenterAndZoom(center, zoom) unless except == 'google'
    @bing.setCenterAndZoom(center, zoom) unless except == 'bing'
  
  moveBing: ->
    if @scriptedMove
      return 

    center = @bing.getCenter()
    zoom = @bing.getZoom()

    @scriptedMove = true
    this.moveMaps(center, zoom, 'bing')
    @scriptedMove = false
    return true
    
  moveBdl: ->
    if @scriptedMove
      return 

    center = @bdl.getCenter()
    zoom = @bdl.getZoom()
    
    @scriptedMove = true
    this.moveMaps(center, zoom, 'bdl')
    @scriptedMove = false
    return true
    
  moveGoogle: ->
    if @scriptedMove
      return 

    center = @google.getCenter()
    zoom = @google.getZoom()

    @scriptedMove = true
    this.moveMaps(center, zoom, 'google')
    @scriptedMove = false
    return true

$(document).ready ->
  map = new Maps()
  
  
  
