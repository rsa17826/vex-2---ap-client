// prettier-ignore
const ASSETS = ["/","/main.css","/ruffle/ruffle.js","/apClient.js","/hintTracker.js","/aplog.js","/indexeddbProxy.js","/ruffle/core.ruffle.15317142e75ce021ac04.js","/ruffle/6ce4f603a1fe7cc88438.wasm","/vex2-modded.swf",]
// Install Service Worker and cache core assets
self.addEventListener("install", (event) => {
  self.skipWaiting()
  event.waitUntil(
    caches.open("cache").then((cache) => {
      return Promise.all(
        ASSETS.map((url) => {
          return cache.add(url.split("?")[0]).catch((err) => {
            console.error("❌ Failed to cache asset:", url, err)
          })
        }),
      )
    }),
  )
})

self.addEventListener("activate", (event) => {
  event.waitUntil(clients.claim())
})

let failedToFetch = false
let cache = null
// Network-first strategy: always prefer the live server,
// only serve from cache if the network request fails
self.addEventListener("fetch", (event) => {
  if (event.request.method !== "GET") return
  event.respondWith(
    (async () => {
      if (failedToFetch) {
        let res = getCached(event.request.url)
        if (!res) {
          console.error(
            `failed to get cached file!!!`,
            event.request.url,
          )
          throw new Error(
            `failed to get cached file!!! ${event.request.url}`,
          )
        }
        return res
      }
      try {
        // console.time(event.request.url)
        // const networkResponse = await fetch(event.request, {
        //   cache: "no-store",
        // })
        const networkResponse = await fetch(event.request)
        // console.timeEnd(event.request.url)
        // 🛑 Treat Nginx error status codes as failures
        if (
          networkResponse.status === 502 ||
          networkResponse.status === 504
        ) {
          throw new Error(`Gateway error: ${networkResponse.status}`)
        }
        // console.time(event.request.url)
        if (
          /^https?:\/\/([^\/]+\.)?(127.0.0.1|localhost)/.test(
            event.request.url,
          )
        ) {
          cache ??= await caches.open("cache")
          const cloned = networkResponse.clone()
          event.waitUntil(
            cache.put(event.request.url.split("?")[0], cloned),
          )
        }
        // console.timeEnd(event.request.url)
        return networkResponse
      } catch (err) {
        // console.error(`failed to get file!!!`, event.request.url, err)
        let res = getCached(event.request.url)
        if (res) return res
        console.error(
          `failed to get cached file!!!`,
          event.request.url,
          err,
        )
        throw err
      }
    })(),
  )
})

async function getCached(url) {
  // console.time(event.request.url)
  // failedToFetch = true
  // console.warn("SERVING FROM CACHE:", url)
  cache ??= await caches.open("cache")
  const cachedResponse = await cache.match(url.split("?")[0])
  // console.timeEnd(event.request.url)
  return cachedResponse
}
