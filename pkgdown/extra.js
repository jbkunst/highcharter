document.addEventListener('DOMContentLoaded', function () {
  const link = document.querySelector('main a[href$="series-gallery.html"]');
  if (!link || !document.querySelector('main h2#installation, main #installation')) return;
  const frame = document.createElement('iframe');
  frame.src = 'home-gallery.html';
  frame.title = 'Four interactive highcharter examples';
  frame.className = 'home-gallery';
  frame.addEventListener('load', function () {
    const grid = frame.contentDocument.querySelector('main');
    if (grid) new ResizeObserver(() => { frame.style.height = grid.offsetHeight + 'px'; }).observe(grid);
  });
  link.closest('p').after(frame);
});
