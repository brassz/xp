const CACHE_NAME = 'nexus-pwa-v1';

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
    })
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
        })
      )
    )
  );
});

// Estratégia simples: cache-first para assets estáticos,
// network-first para o restante (como chamadas Supabase)
self.addEventListener('fetch', (event) => {
  const { request } = event;

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

  // Para assets locais, usar cache-first
  event.respondWith(
    caches.match(request).then((cached) => {
      if (cached) {
        return cached;
      }

      return fetch(request).then((response) => {
        // Clonar a resposta para colocar no cache
        const responseClone = response.clone();
        caches.open(CACHE_NAME).then((cache) => {
          cache.put(request, responseClone);
        });
        return response;
      });
    })
  );
});


