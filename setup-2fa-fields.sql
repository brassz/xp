-- Adicionar campos para 2FA na tabela users
-- Execute este script no seu banco Supabase

ALTER TABLE users 
ADD COLUMN IF NOT EXISTS two_factor_secret TEXT,
ADD COLUMN IF NOT EXISTS two_factor_enabled BOOLEAN DEFAULT FALSE,
ADD COLUMN IF NOT EXISTS two_factor_backup_codes TEXT[], -- Códigos de backup
ADD COLUMN IF NOT EXISTS two_factor_setup_at TIMESTAMP WITH TIME ZONE;

-- Comentários para documentar os campos
COMMENT ON COLUMN users.two_factor_secret IS 'Secret key para geração de códigos TOTP (criptografado)';
COMMENT ON COLUMN users.two_factor_enabled IS 'Indica se o 2FA está ativo para o usuário';
COMMENT ON COLUMN users.two_factor_backup_codes IS 'Array de códigos de backup para recuperação';
COMMENT ON COLUMN users.two_factor_setup_at IS 'Data e hora quando o 2FA foi configurado';

-- Criar índice para melhor performance nas consultas de 2FA
CREATE INDEX IF NOT EXISTS idx_users_two_factor_enabled ON users(two_factor_enabled) WHERE two_factor_enabled = true;

-- Verificar se as colunas foram adicionadas
SELECT column_name, data_type, is_nullable, column_default 
FROM information_schema.columns 
WHERE table_name = 'users' 
AND column_name IN ('two_factor_secret', 'two_factor_enabled', 'two_factor_backup_codes', 'two_factor_setup_at')
ORDER BY column_name;