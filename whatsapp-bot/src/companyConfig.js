export const COMPANY_IDS = [
  'nexus',
  'litoral',
  'mogiana',
  'erechim',
  'imperatriz',
  'brunoassoni',
];

const COMPANY_ENV = {
  nexus: {
    urlKey: 'NEXT_PUBLIC_SUPABASE_URL_EMPRESA1',
    anonKey: 'NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA1',
    serviceKey: 'SUPABASE_SERVICE_ROLE_KEY_EMPRESA1',
  },
  litoral: {
    urlKey: 'NEXT_PUBLIC_SUPABASE_URL_EMPRESA2',
    anonKey: 'NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA2',
    serviceKey: 'SUPABASE_SERVICE_ROLE_KEY_EMPRESA2',
  },
  mogiana: {
    urlKey: 'NEXT_PUBLIC_SUPABASE_URL_EMPRESA3',
    anonKey: 'NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA3',
    serviceKey: 'SUPABASE_SERVICE_ROLE_KEY_EMPRESA3',
  },
  erechim: {
    urlKey: 'NEXT_PUBLIC_SUPABASE_URL_EMPRESA4',
    anonKey: 'NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA4',
    serviceKey: 'SUPABASE_SERVICE_ROLE_KEY_EMPRESA4',
  },
  imperatriz: {
    urlKey: 'NEXT_PUBLIC_SUPABASE_URL_EMPRESA5',
    anonKey: 'NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA5',
    serviceKey: 'SUPABASE_SERVICE_ROLE_KEY_EMPRESA5',
  },
  brunoassoni: {
    urlKey: 'NEXT_PUBLIC_SUPABASE_URL_EMPRESA6',
    anonKey: 'NEXT_PUBLIC_SUPABASE_ANON_KEY_EMPRESA6',
    serviceKey: 'SUPABASE_SERVICE_ROLE_KEY_EMPRESA6',
  },
};

export function resolveCompanyId(input) {
  if (!input) return 'nexus';
  const id = String(input).trim().toLowerCase();
  if (COMPANY_IDS.includes(id)) return id;
  return 'nexus';
}

export function getSupabaseConfig(companyId) {
  const resolved = resolveCompanyId(companyId);
  const keys = COMPANY_ENV[resolved];
  const url = process.env[keys.urlKey];
  const serviceRoleKey = process.env[keys.serviceKey];
  const anonKey = process.env[keys.anonKey];

  return {
    companyId: resolved,
    url,
    key: serviceRoleKey || anonKey,
    keyType: serviceRoleKey ? 'service_role' : 'anon',
  };
}

