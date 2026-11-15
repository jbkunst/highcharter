document.addEventListener('DOMContentLoaded', function () {
  const link = document.querySelector('main a[href$="series-gallery.html"]');
  if (!link || !document.querySelector('main #installation')) return;
  const frame = document.createElement('iframe');
  frame.src = 'home-gallery.html';
  frame.title = 'Compare sepal and petal measurements in 150 iris flowers';
  frame.className = 'home-gallery';
  frame.addEventListener('load', function () {
    const panel = frame.contentDocument.querySelector('main');
    if (panel) new ResizeObserver(() => { frame.style.height = panel.offsetHeight + 'px'; }).observe(panel);
  });
  link.closest('p').before(frame);
});
