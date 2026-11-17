function(el, x, sequence) {
  const chart = HighcharterWidget.getChart(el);
  const root = el.closest('.transition-grid-page');
  const caption = el.closest('.transition-panel').querySelector('.panel-caption');
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

    if (!previous) {
      options.plotOptions.series.animation = false;
      chart.update(options, false, true, false);
    } else {
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
      if (!same(previous.tooltip, options.tooltip)) chart.tooltip.update(options.tooltip);
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
            // The Aleutian islands cross the date line. Their positive
            // longitudes would otherwise expand America's bounds worldwide.
            if (value[0] <= 0) coordinates.push(value);
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
    caption.textContent = step.caption;
    el.dataset.family = sequence.family;
    el.dataset.scene = step.id;
    el.dataset.phase = index;
  }

  const onStep = event => show(event.detail.index, event.detail.animate);
  root.addEventListener('grid-step', onStep);
  Highcharts.addEvent(chart, 'destroy', () => root.removeEventListener('grid-step', onStep));

  if (!root.dataset.bound) {
    root.dataset.bound = 'true';
    root.dataset.playing = String(!reduced);
    root.dataset.phase = '0';
    root.dataset.ready = 'false';
    const play = root.querySelector('.grid-play');
    const picker = root.querySelector('.grid-step');
    picker.disabled = true;
    let timer;
    function sync() {
      play.textContent = root.dataset.playing === 'true' ? 'Pause' : 'Play';
      picker.value = root.dataset.phase;
      const current = sequence.steps[Number(root.dataset.phase)];
      const story = root.querySelector('.grid-story');
      if (story) story.textContent = current.story;
      root.querySelectorAll('.grid-legend li').forEach(item => {
        item.style.opacity = current.focus &&
          !current.focusRegions.includes(item.dataset.region) ? '0.35' : '1';
      });
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
    play.addEventListener('click', () => {
      if (root.dataset.playing === 'true') return pause();
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
    }))).then(() => document.fonts.ready).then(() => {
      root.dataset.ready = 'true';
      picker.disabled = false;
      if (root.dataset.playing === 'true') schedule();
    });
  }
  show(Number(root.dataset.phase), false);
}
