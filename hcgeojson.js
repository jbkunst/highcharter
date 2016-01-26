function geojson(geojson, hType, series) {
  var mapData = [],
  path = [],
  polygonToPath = function (polygon) {
    var i,
    len = polygon.length;
    path.push('M');
    for (i = 0; i < len; i++) {
      if (i === 1) {
        path.push('L');
      }
      path.push(polygon[i][0], -polygon[i][1]);
    }
  };
  
  hType = hType || 'map';
  
  _.each(geojson.features, function (feature) {
    
    var geometry = feature.geometry,
    type = geometry.type,
    coordinates = geometry.coordinates,
    properties = feature.properties,
    point;
    
    path = [];
    
    if (hType === 'map' || hType === 'mapbubble') {
      if (type === 'Polygon') {
        _.each(coordinates, polygonToPath);
        path.push('Z');
        
      } else if (type === 'MultiPolygon') {
        _.each(coordinates, function (items) {
          _.each(items, polygonToPath);
        });
        path.push('Z');
      }
      
      if (path.length) {
        point = { path: path };
      }
      
    } else if (hType === 'mapline') {
      if (type === 'LineString') {
        polygonToPath(coordinates);
      } else if (type === 'MultiLineString') {
        _.each(coordinates, polygonToPath);
      }
      
      if (path.length) {
        point = { path: path };
      }
      
    } else if (hType === 'mappoint') {
      if (type === 'Point') {
        point = {
          x: coordinates[0],
          y: -coordinates[1]
        };
      }
    }
    if (point) {
      mapData.push(extend(point, {
        name: properties.name || properties.NAME,
        properties: properties
      }));
    }
    
  });
  
  // Create a credits text that includes map source, to be picked up in Chart.showCredits
  if (series && geojson.copyrightShort) {
    series.chart.mapCredits = format(series.chart.options.credits.mapText, { geojson: geojson });
    series.chart.mapCreditsFull = format(series.chart.options.credits.mapTextFull, { geojson: geojson });
  }
  
  return mapData;
}
