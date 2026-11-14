"""Run from the package root with R, highcharter, Shiny and Playwright installed."""
import os
import subprocess
import tempfile
import time
from pathlib import Path
from urllib.request import urlopen

from playwright.sync_api import sync_playwright


def test_stock_proxy():
    with tempfile.TemporaryDirectory() as directory:
        port_file = Path(directory, "port")
        start = """
            port <- httpuv::randomPort()
            writeLines(as.character(port), commandArgs(TRUE)[1])
            app <- source("inst/examples/stock-proxy.R", local = TRUE)$value
            shiny::runApp(app, port = port, host = "127.0.0.1", launch.browser = FALSE)
        """
        proc = subprocess.Popen(["Rscript", "-e", start, str(port_file)])
        try:
            for _ in range(150):
                if proc.poll() is not None:
                    raise RuntimeError("Shiny exited before the test started")
                if port_file.exists():
                    url = "http://127.0.0.1:" + port_file.read_text().strip()
                    try:
                        with urlopen(url, timeout=1):
                            break
                    except OSError:
                        pass
                time.sleep(0.2)
            else:
                raise TimeoutError("Shiny did not start")

            with sync_playwright() as pw:
                browser = pw.chromium.launch(executable_path=os.getenv("CHROMOTE_CHROME"))
                page = browser.new_page()
                page.goto(url)
                page.wait_for_function("window.HighcharterWidget?.getChart('prices')?.hasRendered")
                page.evaluate("window.initialChart = HighcharterWidget.getChart('prices')")
                assert page.evaluate("initialChart.get('closing').getColumn('y')[0]") == 20
                page.get_by_role("button", name="Update").click()
                page.wait_for_function("""() => {
                    const chart = HighcharterWidget.getChart('prices');
                    const axis = chart.get('days').getExtremes();
                    return chart === window.initialChart && chart.get('closing').getColumn('y')[0] === 25
                        && axis.min === Date.UTC(2025, 0, 3) && axis.max === Date.UTC(2025, 0, 8);
                }""")
                browser.close()
        finally:
            proc.terminate()
            proc.wait(timeout=15)


if __name__ == "__main__":
    test_stock_proxy()
