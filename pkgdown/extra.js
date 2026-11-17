// Keep the initializer in pkgdown's shared asset, including on the 404 page.
window.dataLayer = window.dataLayer || [];
function gtag() { dataLayer.push(arguments); }
gtag('js', new Date());
gtag('config', 'G-ECZ9XLT78C');

// Use Bootstrap TOC's documented scope option: only article sections belong
// in the sidebar, not Highcharts' hidden screen-reader headings.
jQuery(function () {
  // htmlwidgets initially measures hidden tab panes at zero width.
  document.addEventListener('shown.bs.tab', function () {
    window.dispatchEvent(new Event('resize'));
    if (window.Highcharts) {
      Highcharts.charts.forEach(chart => {
        if (chart && chart.renderTo.getBoundingClientRect().width > 0) chart.reflow();
      });
    }
  });
  const toc = document.querySelector('.template-article #toc');
  if (toc && window.Toc) {
    Toc.init({
      $nav: jQuery(toc).empty(),
      $scope: jQuery('main .section.level2 > h2')
    });
  }

  const frame = document.querySelector('iframe.home-gallery');
  if (!frame) return;
  let observed;
  function observeGallery() {
    const panel = frame.contentDocument.querySelector('main');
    if (panel && panel !== observed) {
      observed = panel;
      let pending;
      new ResizeObserver(() => {
        cancelAnimationFrame(pending);
        pending = requestAnimationFrame(() => {
          const height = Math.ceil(panel.getBoundingClientRect().height) + 8 + 'px';
          if (frame.style.height !== height) frame.style.height = height;
        });
      }).observe(panel);
    }
  }
  frame.addEventListener('load', observeGallery);
  // A cached iframe may finish before this DOM-ready callback is registered.
  observeGallery();
});
