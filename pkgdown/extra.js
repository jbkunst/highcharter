// Keep the initializer in pkgdown's shared asset, including on the 404 page.
window.dataLayer = window.dataLayer || [];
function gtag() { dataLayer.push(arguments); }
gtag('js', new Date());
gtag('config', 'G-ECZ9XLT78C');

// Use Bootstrap TOC's documented scope option: only article sections belong
// in the sidebar, not Highcharts' hidden screen-reader headings.
jQuery(function () {
  // Restore the original Datalegreya graph lettering after the font has loaded.
  // Keep plain package names for assistive technology and font-load failures.
  const wordmark = 'h|1i|0g|3h|2c|1h|2a|1r|3t|2e|1r|2';
  function decorate(node, text) {
    const label = document.createElement('span');
    label.className = 'visually-hidden';
    label.textContent = 'highcharter';
    const graphic = document.createElement('span');
    graphic.className = 'highcharter-wordmark';
    graphic.setAttribute('aria-hidden', 'true');
    graphic.textContent = text;
    node.replaceChildren(label, graphic);
  }
  [
    ['.template-home #highcharter', 'Datalegreya-Gradient', wordmark + '{rpackage}'],
    ['.navbar-brand', 'Datalegreya-Thin', wordmark]
  ].forEach(([selector, font, text]) => {
    const node = document.querySelector(selector);
    if (!node) return;
    document.fonts.load(`1em "${font}"`).then(fonts => {
      if (fonts.length) decorate(node, text);
    }).catch(() => {});
  });

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
