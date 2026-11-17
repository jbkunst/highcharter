function(el, x, sequence) {
  const chart = HighcharterWidget.getChart(el);
  const reducedMotion = matchMedia('(prefers-reduced-motion: reduce)').matches;
  // Highcharts can mutate its input data. Keep each R scene immutable.
  const snapshots = sequence.steps.map(step => JSON.stringify(step.options));
  const footer = document.createElement('div');
  footer.style.cssText = 'font:300 14px/1.6 "IBM Plex Sans",sans-serif;color:#666;text-align:center';
  el.after(footer);

  const legend = document.createElement('ul');
  legend.setAttribute('aria-label', 'Continentes');
  legend.style.cssText = 'display:flex;flex-wrap:wrap;justify-content:center;gap:6px 22px;padding:0;margin:8px 0;list-style:none';
  for (const region of sequence.legend) {
    const item = document.createElement('li');
    const key = document.createElement('span');
    key.style.cssText = 'display:inline-block;width:10px;height:10px;border-radius:50%;margin-right:6px';
    key.style.background = region.color;
    item.append(key, region.name);
    legend.append(item);
  }
  const caption = document.createElement('p');
  caption.setAttribute('role', 'status');
  caption.style.cssText = 'margin:8px auto 16px;max-width:750px;padding:0 12px;min-height:3.2em';
  const controls = document.createElement('div');
  controls.style.cssText = 'display:flex;flex-wrap:wrap;justify-content:center;gap:8px;padding:0 8px';

  function button(text, label) {
    const node = document.createElement('button');
    node.type = 'button';
    node.textContent = text;
    node.setAttribute('aria-label', label);
    node.style.cssText = 'padding:7px 15px;border:1px solid #ddd;border-radius:22px;background:#fff;color:#47475c;font:inherit;cursor:pointer';
    return node;
  }
  const previous = button('Anterior', 'Vista anterior');
  const play = button('Reproducir', 'Reproducir secuencia');
  play.style.background = '#47475c';
  play.style.color = '#fff';
  const next = button('Siguiente', 'Vista siguiente');
  const select = document.createElement('select');
  select.setAttribute('aria-label', 'Elegir vista');
  select.style.cssText = 'font:inherit;color:inherit;max-width:100%;padding:5px 8px;border:1px solid #ddd;border-radius:6px;background:#fff';
  sequence.steps.forEach((step, i) => {
    const option = document.createElement('option');
    option.value = i;
    option.textContent = (i + 1) + '/' + sequence.steps.length + ' · ' + step.label;
    select.append(option);
  });
  controls.append(previous, play, next, select);
  footer.append(legend, caption, controls);

  let index = 0;
  let playing = false;
  let timer;

  function sync() {
    select.value = index;
    previous.disabled = index === 0;
    next.disabled = index === sequence.steps.length - 1;
    play.textContent = playing ? 'Pausar' : index === sequence.steps.length - 1 ? 'Repetir' : 'Reproducir';
    play.setAttribute('aria-label', play.textContent + ' secuencia');
  }

  function show(i, animate) {
    index = i;
    const step = sequence.steps[i];
    const animation = animate && !reducedMotion ? {duration: step.duration} : false;
    const options = JSON.parse(snapshots[i]);
    // Animate new series as well as existing graphics. Manual navigation and
    // reduced-motion playback still apply the target state immediately.
    options.plotOptions.series.animation = animation;
    chart.update(options, true, true, animation);
    caption.textContent = step.caption;
    el.dataset.scene = step.id;
    sync();
  }

  function schedule(duration = 0) {
    clearTimeout(timer);
    timer = setTimeout(() => {
      if (!playing || !chart.container?.isConnected) return;
      if (index === sequence.steps.length - 1) {
        playing = false;
        sync();
        return;
      }
      show(index + 1, true);
      schedule(reducedMotion ? 0 : sequence.steps[index].duration);
    }, duration + sequence.steps[index].wait);
  }

  function pause() {
    playing = false;
    clearTimeout(timer);
    sync();
  }

  function choose(i) {
    pause();
    show(i, false);
  }

  previous.addEventListener('click', () => choose(Math.max(0, index - 1)));
  next.addEventListener('click', () => choose(Math.min(sequence.steps.length - 1, index + 1)));
  select.addEventListener('change', () => choose(Number(select.value)));
  play.addEventListener('click', () => {
    if (playing) return pause();
    if (index === sequence.steps.length - 1) show(0, false);
    playing = true;
    sync();
    schedule();
  });
  Highcharts.addEvent(chart, 'destroy', () => {
    clearTimeout(timer);
    footer.remove();
  });

  show(0, false);
  if (!reducedMotion) {
    playing = true;
    sync();
    schedule();
  }
}
