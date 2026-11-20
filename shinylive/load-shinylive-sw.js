// Shinylive 0.10.12
// Copyright 2026 Posit, PBC

// src/utils.ts
function dirname(path) {
  if (path === "/" || path === "") {
    return "";
  }
  return path.replace(/[/]?[^/]+[/]?$/, "");
}
function currentScriptPath() {
  return new URL(import.meta.url).pathname;
}
function currentScriptDir() {
  return dirname(currentScriptPath());
}

// src/load-shinylive-sw.ts
var localhostNames = ["localhost", "127.0.0.1", "[::1]"];
if (window.location.protocol !== "https:" && !localhostNames.includes(window.location.hostname)) {
  const errorMessage = "Shinylive uses a Service Worker, which requires either a connection to localhost, or a connection via https.";
  document.body.innerText = errorMessage;
  throw Error(errorMessage);
}
var serviceWorkerDir;
var shinyliveMetaTag = document.querySelector(
  'meta[name="shinylive:serviceworker_dir"]'
);
if (shinyliveMetaTag !== null) {
  serviceWorkerDir = shinyliveMetaTag.content;
} else {
  serviceWorkerDir = dirname(currentScriptDir());
}
serviceWorkerDir = serviceWorkerDir.replace(/\/$/, "");
var serviceWorkerPath = serviceWorkerDir + "/shinylive-sw.js";
if ("serviceWorker" in navigator) {
  navigator.serviceWorker.register(serviceWorkerPath, { type: "module" }).then((registration) => registration.update()).then(() => console.log("Service Worker registered")).catch(() => console.log("Service Worker registration failed"));
  navigator.serviceWorker.ready.then(() => {
    if (!navigator.serviceWorker.controller) {
      window.location.reload();
    }
  });
}
