function (el) {
  const chart = HighcharterWidget.getChart(el);
  const panel = el.closest('main');
  const measures = panel.querySelectorAll('input[name="measure"]');
  const reduced = window.matchMedia('(prefers-reduced-motion: reduce)');
  let timer;
  let observer;

  function cancelIntro() {
    clearTimeout(timer);
    if (observer) observer.disconnect();
  }

  function showMeasure(measure) {
    cancelIntro();
    measures.forEach(input => { input.checked = input.value === measure; });
    chart.tooltip.hide(0);
    for (const series of chart.series) {
      for (const point of series.data) {
        point.update({
          x: point.options[measure + '.Length'],
          y: point.options[measure + '.Width']
        }, false);
      }
    }
    // The same cubic ease-in-out as the transitions on jkunst.com.
    chart.redraw(reduced.matches ? false : {
      duration: 1400,
      easing: t => t < 0.5 ? 4 * t * t * t : 1 - Math.pow(-2 * t + 2, 3) / 2
    });
  }

  for (const input of measures) {
    input.addEventListener('change', () => showMeasure(input.value));
  }
  panel.addEventListener('pointerdown', cancelIntro, { once: true });
  panel.addEventListener('focusin', cancelIntro, { once: true });

  if (!reduced.matches) {
    observer = new IntersectionObserver(([entry]) => {
      clearTimeout(timer);
      if (entry.isIntersecting && entry.intersectionRatio >= 0.5) {
        timer = setTimeout(() => {
          if (!document.hidden && !reduced.matches) showMeasure('Petal');
        }, 1200);
      }
    }, { threshold: 0.5 });
    observer.observe(el);
  }
}
