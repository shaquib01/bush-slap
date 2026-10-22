const CACHE = "bush-slap-v39";
const CORE = [
  "/",
  "/index.html",
  "/manifest.json",
  "/assets/jungle-backdrop.svg",
  "/assets/slap-burst.svg"
];

self.addEventListener("install", event => {
  event.waitUntil(
    caches.open(CACHE)
      .then(async cache => {
        // Keep the offline shell installable even if a decorative asset is unavailable.
        await Promise.allSettled(CORE.map(path => cache.add(path)));
      })
      .then(() => self.skipWaiting())
  );
});

self.addEventListener("activate", event => {
  event.waitUntil(
    caches.keys().then(keys =>
      Promise.all(keys.filter(key => key !== CACHE).map(key => caches.delete(key)))
    ).then(() => self.clients.claim())
  );
});

self.addEventListener("fetch", event => {
  const request = event.request;
  if (request.method !== "GET") return;

  const url = new URL(request.url);
  if (url.origin !== self.location.origin) return;

  event.respondWith((async () => {
    const cached = await caches.match(request);
    if (cached) return cached;

    try {
      const response = await fetch(request);
      if (response.ok && response.type !== "opaque") {
        const copy = response.clone();
        await caches.open(CACHE).then(cache => cache.put(request, copy));
      }
      return response;
    } catch {
      if (request.mode === "navigate") {
        return (await caches.match("/index.html")) ||
          new Response("Bush Slap is offline. Reconnect once to load the game.", {
            status: 503,
            headers: { "Content-Type": "text/plain; charset=utf-8" }
          });
      }
      return new Response("This game asset is not available offline yet.", {
        status: 503,
        headers: { "Content-Type": "text/plain; charset=utf-8" }
      });
    }
  })());
});
