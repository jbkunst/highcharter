function (el, x, geography) {
  const chart = Highcharts.charts.find(chart => chart && chart.renderTo === el);
  const layer = document.createElement("div");
  layer.setAttribute("aria-hidden", "true");
  Object.assign(layer.style, { position: "absolute", overflow: "hidden", pointerEvents: "none" });
  el.insertBefore(layer, chart.container);

  // Both renderers use Web Mercator. One pixel of longitude gives the GL zoom
  // at the current Highcharts scale, including after a resize or a drag.
  function camera() {
    const { plotLeft, plotTop, plotWidth: w, plotHeight: h } = chart;
    Object.assign(layer.style, {
      left: plotLeft + "px", top: plotTop + "px", width: w + "px", height: h + "px"
    });
    const center = chart.mapView.pixelsToLonLat({ x: w / 2, y: h / 2 });
    const right = chart.mapView.pixelsToLonLat({ x: w / 2 + 1, y: h / 2 });
    return { center: [center.lon, center.lat], zoom: Math.log2(360 / (512 * (right.lon - center.lon))) };
  }

  let map;
  try {
    map = new maplibregl.Map({
      ...camera(), container: layer, interactive: false, attributionControl: false,
      style: {
        version: 8,
        sources: { surroundings: { type: "geojson", data: geography } },
        layers: [
          { id: "land", type: "background", paint: { "background-color": "#f6f5f1" } },
          { id: "areas", type: "fill", source: "surroundings",
            filter: ["==", ["geometry-type"], "Polygon"],
            paint: { "fill-color": ["match", ["get", "kind"], "water", "#c5dade",
              "wood", "#d0dfd0", "park", "#e0e8da", "#eae9e5"] } },
          { id: "routes", type: "line", source: "surroundings",
            filter: ["==", ["geometry-type"], "LineString"],
            paint: {
              "line-color": ["match", ["get", "kind"], "waterway", "#bdd2d7",
                "railway", "#c8c8c2", "#ffffff"],
              "line-width": ["match", ["get", "kind"], "major road", 2.8, 1.3]
            } }
        ]
      }
    });
  } catch (error) {
    // The Highcharts geometry and tooltips remain usable without WebGL.
    layer.remove();
    return;
  }
  function sync() {
    const view = camera();
    map.resize();
    map.jumpTo(view);
  }
  const offRender = Highcharts.addEvent(chart, "render", sync);
  const offView = Highcharts.addEvent(chart.mapView, "afterSetView", sync);
  Highcharts.addEvent(chart, "destroy", () => {
    offRender();
    offView();
    map.remove();
    layer.remove();
  });
}
