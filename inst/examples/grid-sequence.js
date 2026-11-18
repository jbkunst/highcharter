function(el, x, sequence) {
  const chart = HighcharterWidget.getChart(el);
  const root = el.closest('.transition-grid-page');
  const reduced = matchMedia('(prefers-reduced-motion: reduce)').matches;
  const snapshots = sequence.steps.map(step => JSON.stringify(step.options));

  let previous;
  const same = (a, b) => JSON.stringify(a) === JSON.stringify(b);

  function show(index, animate) {
    const step = sequence.steps[index];
    const options = JSON.parse(snapshots[index]);
    const animation = animate && !reduced ?
      {duration: step.duration, easing: 'easeInOutSine'} : false;
    const fills = new Map();
    const opacity = new Map();
    const groupOpacity = new Map();
    const markers = new Map();
    chart.series.forEach(series => {
      series.points.forEach(point => {
        if (point.graphic) fills.set(point.id, point.graphic.attr('fill'));
        if (series.type === 'bubble' && point.graphic) {
          markers.set(point.id, Object.fromEntries(
            ['x', 'y', 'width', 'height'].map(key => [key, point.graphic.attr(key)])
          ));
        }
      });
      if (series.area) opacity.set(series.options.id, series.area.attr('fill-opacity'));
      if (series.group) groupOpacity.set(series.options.id, series.group.attr('opacity'));
    });

    // R already supplies the first scene. Reinitializing it during widget
    // startup can interrupt the initial bubble layout or entrance animation.
    if (previous) {
      // Update only changed axes/options. Replacing the complete configuration
      // also reinitializes series and loses the SVG elements we want to move.
      ['xAxis', 'yAxis'].forEach(key => {
        if (options[key] && !same(previous[key], options[key])) {
          chart[key][0].update(options[key], false);
        }
      });
      if (options.colorAxis && !same(previous.colorAxis, options.colorAxis)) {
        chart.colorAxis[0].update(options.colorAxis, false);
      }
      if (!same(previous.tooltip, options.tooltip)) {
        // Series cache their tooltip formats from chart.userOptions. Updating
        // Tooltip alone leaves stale row formats/units in shared tooltips.
        chart.update({tooltip: options.tooltip}, false);
      }
      if (!same(previous.caption, options.caption)) {
        chart.update({caption: options.caption}, false);
      }
      options.series.forEach(target => {
        const series = chart.get(target.id);
        const before = previous.series.find(item => item.id === target.id);
        if (!series || series.type !== target.type) {
          throw new Error('A grid family must retain its series and type: ' + target.id);
        }
        const changes = {};
        Object.keys(target).forEach(key => {
          if (!['data', 'mapData', 'id', 'type'].includes(key) &&
              !same(before[key], target[key])) changes[key] = target[key];
        });
        if (Object.keys(changes).length) series.update(changes, false);
        if (!same(before.data, target.data)) {
          if (sequence.family === 'map') {
            // The same geographic shapes stay in place; only their values
            // and fills change. Resending mapData would recreate those paths.
            const points = new Map(series.points.map(point => [point.id, point]));
            target.data.forEach(data => {
              const point = points.get(data.id);
              if (point) point.update({value: data.value, color: data.color}, false);
            });
          } else {
            series.setData(target.data, false, animation, true);
          }
        }
      });
    }
    if (step.view && chart.mapView) {
      if (step.view.fit) {
        if (chart.mapView.options.fitToGeometry) {
          chart.mapView.update({fitToGeometry: null}, false);
        } else {
          chart.mapView.fitToBounds(undefined, undefined, false, animation);
        }
      } else if (step.view.countries) {
        const selected = new Set(step.view.countries);
        const coordinates = [];
        function collect(value) {
          if (!Array.isArray(value)) return;
          if (typeof value[0] === 'number') {
            coordinates.push(value);
          } else value.forEach(collect);
        }
        chart.series.flatMap(series => series.points)
          .filter(point => selected.has(point.id))
          .forEach(point => collect(point.geometry?.coordinates));
        if (coordinates.length) {
          chart.mapView.update({fitToGeometry: {type: 'MultiPoint', coordinates}}, false);
        }
      }
    }
    // MapView.redraw also marks geographic series dirty when only the camera
    // changes; Chart.redraw alone would leave their SVG transform unchanged.
    if (step.view && chart.mapView) chart.mapView.redraw(animation);
    else chart.redraw(animation);

    // Highcharts sets some fills immediately during drawPoints/drawGraph.
    // Its SVGElement.animate() interpolates those attributes as well.
    if (animation) {
      chart.series.forEach(series => {
        series.points.forEach(point => {
          const marker = markers.get(point.id);
          if (series.type === 'bubble' && point.graphic && marker) {
            // Axis type changes can reset marker geometry during redraw. Start
            // from the visible glyph, then use Highcharts' own SVG animation.
            const target = series.markerAttribs(point);
            point.graphic.attr(marker).animate(target, animation);
          }
          const fill = fills.get(point.id);
          if (point.graphic && fill && point.color && fill !== point.color) {
            point.graphic.attr({fill}).animate({fill: point.color}, animation);
          }
        });
        const before = opacity.get(series.options.id);
        if (series.area && before !== undefined) {
          series.area.attr({'fill-opacity': before})
            .animate({'fill-opacity': series.options.fillOpacity}, animation);
        }
        const groupBefore = groupOpacity.get(series.options.id);
        if (series.group && groupBefore !== undefined) {
          series.group.attr({opacity: groupBefore})
            .animate({opacity: series.options.opacity ?? 1}, animation);
        }
      });
    }
    previous = options;
    el.dataset.family = sequence.family;
    el.dataset.scene = step.id;
    el.dataset.phase = index;
  }

  const onStep = event => show(event.detail.index, event.detail.animate);
  const onReady = () => {
    // Wait for the grid and fonts to settle, then use Highcharts' sizing API.
    // Initial drawing must not depend on a later viewport resize.
    chart.setSize(null, null, false);
    show(Number(root.dataset.phase), false);
  };
  root.addEventListener('grid-step', onStep);
  root.addEventListener('grid-ready', onReady);
  Highcharts.addEvent(chart, 'destroy', () => {
    root.removeEventListener('grid-step', onStep);
    root.removeEventListener('grid-ready', onReady);
  });

  if (!root.dataset.bound) {
    root.dataset.bound = 'true';
    root.dataset.playing = String(root.dataset.autoplay === 'true' && !reduced);
    root.dataset.phase = '0';
    root.dataset.ready = 'false';
    const play = root.querySelector('.grid-play');
    const picker = root.querySelector('.grid-step');
    picker.disabled = true;
    let timer;
    function sync() {
      play.textContent = root.dataset.playing === 'true' ? 'Pause' : 'Play';
      picker.value = root.dataset.phase;
    }
    function step(index, animate) {
      root.dataset.phase = index;
      root.dispatchEvent(new CustomEvent('grid-step', {detail: {index, animate}}));
      sync();
    }
    function schedule(duration = 0) {
      clearTimeout(timer);
      const current = sequence.steps[Number(root.dataset.phase)];
      timer = setTimeout(() => {
        if (!root.isConnected || root.dataset.playing !== 'true') return;
        const index = (Number(root.dataset.phase) + 1) % 4;
        step(index, true);
        schedule(reduced ? 0 : sequence.steps[index].duration);
      }, duration + current.wait);
    }
    function pause() {
      clearTimeout(timer);
      root.dataset.playing = 'false';
      sync();
    }
    root.addEventListener('grid-pause', pause);
    play.addEventListener('click', () => {
      if (root.dataset.playing === 'true') return pause();
      for (const other of document.querySelectorAll('.transition-grid-page[data-playing="true"]')) {
        other.dispatchEvent(new Event('grid-pause'));
      }
      root.dataset.playing = 'true';
      sync();
      if (root.dataset.ready === 'true') schedule();
    });
    root.querySelector('.grid-reset').addEventListener('click', () => {
      pause();
      step(0, true);
    });
    picker.addEventListener('change', () => {
      const index = Number(picker.value);
      pause();
      step(index, true);
    });
    sync();
    // Late font loading changes axis measurements and can interrupt a tween.
    const fonts = [...document.querySelectorAll('link[rel="stylesheet"]')]
      .filter(link => link.href.includes('fonts.googleapis.com'));
    Promise.all(fonts.map(link => link.sheet ? Promise.resolve() : new Promise(resolve => {
      link.addEventListener('load', resolve, {once: true});
      link.addEventListener('error', resolve, {once: true});
      setTimeout(resolve, 5000);
    }))).then(() => document.fonts.ready)
      .then(() => new Promise(resolve => requestAnimationFrame(resolve)))
      .then(() => {
        root.dispatchEvent(new CustomEvent('grid-ready'));
        root.dataset.ready = 'true';
        picker.disabled = false;
        if (root.dataset.playing === 'true') schedule();
      });
  }
  show(Number(root.dataset.phase), false);
  if (root.dataset.ready === 'true') requestAnimationFrame(onReady);
}
