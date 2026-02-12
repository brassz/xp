const CACHE_NAME = 'nexus-pwa-v2';

// Arquivos estáticos principais para cache
const CORE_ASSETS = [
  '/',
  '/index.html',
  '/app.js',
  '/manifest.json',
  '/assets/images/nexus-logo-circular.png',
  '/assets/images/nexus-logo-compact.png'
];

self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME).then((cache) => {
      return cache.addAll(CORE_ASSETS);
    }).then(() => self.skipWaiting())
  );
});

self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((cacheNames) =>
      Promise.all(
        cacheNames.map((cacheName) => {
          if (cacheName !== CACHE_NAME) {
            return caches.delete(cacheName);
          }
          return Promise.resolve();
        })
      )
    ).then(() => self.clients.claim())
  );
});

self.addEventListener('message', (event) => {
  if (event.data && event.data.type === 'SKIP_WAITING') {
    self.skipWaiting();
  }
});

async function networkFirst(request) {
  try {
    const response = await fetch(request);
    const responseClone = response.clone();
    const cache = await caches.open(CACHE_NAME);
    cache.put(request, responseClone);
    return response;
  } catch (error) {
    return caches.match(request);
  }
}

async function cacheFirst(request) {
  const cached = await caches.match(request);
  if (cached) {
    return cached;
  }
  
  const response = await fetch(request);
  const responseClone = response.clone();
  const cache = await caches.open(CACHE_NAME);
  cache.put(request, responseClone);
  return response;
}

self.addEventListener('fetch', (event) => {
  const { request } = event;
  if (request.method !== 'GET') return;

  // Ignorar chamadas de outros protocolos
  if (!request.url.startsWith(self.location.origin) && !request.url.includes('supabase.co')) {
    return;
  }

  // Para Supabase (API e arquivos), usar network-first
  if (request.url.includes('supabase.co')) {
    event.respondWith(
      fetch(request).catch(() => caches.match(request))
    );
    return;
  }

  const url = new URL(request.url);
  const isAppShellRequest = request.mode === 'navigate' ||
    url.pathname === '/' ||
    url.pathname.endsWith('/index.html') ||
    url.pathname.endsWith('/app.js');
  
  // App shell em network-first para evitar versões antigas do JS
  if (isAppShellRequest) {
    event.respondWith(networkFirst(request));
    return;
  }
  
  // Assets locais estáticos em cache-first
  event.respondWith(cacheFirst(request));
});
