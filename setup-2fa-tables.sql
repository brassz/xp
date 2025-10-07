-- Script para configurar tabelas de 2FA no Supabase
-- Execute este script no SQL Editor do Supabase

-- Tabela para armazenar configurações de 2FA dos usuários
CREATE TABLE IF NOT EXISTS user_2fa_settings (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    is_enabled BOOLEAN DEFAULT FALSE,
    secret_key TEXT, -- Para TOTP (Google Authenticator, etc.)
    backup_codes TEXT[], -- Códigos de backup
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(user_id)
);

-- Tabela para armazenar códigos temporários de 2FA (email/SMS)
CREATE TABLE IF NOT EXISTS temp_2fa_codes (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    code VARCHAR(6) NOT NULL,
    code_type VARCHAR(20) NOT NULL CHECK (code_type IN ('email', 'sms', 'backup')),
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    INDEX idx_user_code_type (user_id, code_type),
    INDEX idx_expires_at (expires_at)
);

-- Tabela para log de tentativas de 2FA
CREATE TABLE IF NOT EXISTS user_2fa_attempts (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL REFERENCES auth.users(id) ON DELETE CASCADE,
    attempt_type VARCHAR(20) NOT NULL CHECK (attempt_type IN ('totp', 'email', 'sms', 'backup')),
    success BOOLEAN NOT NULL,
    ip_address INET,
    user_agent TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    INDEX idx_user_attempts (user_id, created_at),
    INDEX idx_failed_attempts (user_id, success, created_at)
);

-- Função para limpar códigos expirados
CREATE OR REPLACE FUNCTION cleanup_expired_2fa_codes()
RETURNS void AS $$
BEGIN
    DELETE FROM temp_2fa_codes 
    WHERE expires_at < NOW() - INTERVAL '1 hour';
END;
$$ LANGUAGE plpgsql;

-- Trigger para atualizar updated_at automaticamente
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_user_2fa_settings_updated_at
    BEFORE UPDATE ON user_2fa_settings
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- RLS (Row Level Security) policies
ALTER TABLE user_2fa_settings ENABLE ROW LEVEL SECURITY;
ALTER TABLE temp_2fa_codes ENABLE ROW LEVEL SECURITY;
ALTER TABLE user_2fa_attempts ENABLE ROW LEVEL SECURITY;

-- Políticas de segurança - usuários só podem ver seus próprios dados
CREATE POLICY "Users can view own 2FA settings" ON user_2fa_settings
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can update own 2FA settings" ON user_2fa_settings
    FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own 2FA settings" ON user_2fa_settings
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own 2FA settings" ON user_2fa_settings
    FOR DELETE USING (auth.uid() = user_id);

-- Políticas para códigos temporários (apenas serviço pode gerenciar)
CREATE POLICY "Service can manage temp codes" ON temp_2fa_codes
    FOR ALL USING (true);

-- Políticas para logs de tentativas (apenas leitura para usuários)
CREATE POLICY "Users can view own 2FA attempts" ON user_2fa_attempts
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Service can insert 2FA attempts" ON user_2fa_attempts
    FOR INSERT WITH CHECK (true);

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_user_2fa_settings_user_id ON user_2fa_settings(user_id);
CREATE INDEX IF NOT EXISTS idx_temp_2fa_codes_user_id ON temp_2fa_codes(user_id);
CREATE INDEX IF NOT EXISTS idx_temp_2fa_codes_expires ON temp_2fa_codes(expires_at);
CREATE INDEX IF NOT EXISTS idx_user_2fa_attempts_user_id ON user_2fa_attempts(user_id);

-- Função para gerar códigos de backup
CREATE OR REPLACE FUNCTION generate_backup_codes(user_uuid UUID)
RETURNS TEXT[] AS $$
DECLARE
    codes TEXT[] := '{}';
    i INTEGER;
    code TEXT;
BEGIN
    -- Gerar 10 códigos de backup de 8 caracteres cada
    FOR i IN 1..10 LOOP
        code := UPPER(SUBSTRING(MD5(RANDOM()::TEXT || NOW()::TEXT) FROM 1 FOR 8));
        codes := array_append(codes, code);
    END LOOP;
    
    RETURN codes;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Função para verificar se um código de backup é válido
CREATE OR REPLACE FUNCTION verify_backup_code(user_uuid UUID, input_code TEXT)
RETURNS BOOLEAN AS $$
DECLARE
    user_codes TEXT[];
    remaining_codes TEXT[] := '{}';
    code TEXT;
    is_valid BOOLEAN := FALSE;
BEGIN
    -- Buscar códigos de backup do usuário
    SELECT backup_codes INTO user_codes
    FROM user_2fa_settings
    WHERE user_id = user_uuid AND is_enabled = TRUE;
    
    IF user_codes IS NULL THEN
        RETURN FALSE;
    END IF;
    
    -- Verificar se o código existe e removê-lo da lista
    FOREACH code IN ARRAY user_codes LOOP
        IF code = UPPER(input_code) THEN
            is_valid := TRUE;
        ELSE
            remaining_codes := array_append(remaining_codes, code);
        END IF;
    END LOOP;
    
    -- Se o código foi válido, atualizar a lista removendo o código usado
    IF is_valid THEN
        UPDATE user_2fa_settings
        SET backup_codes = remaining_codes,
            updated_at = NOW()
        WHERE user_id = user_uuid;
    END IF;
    
    RETURN is_valid;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Comentários para documentação
COMMENT ON TABLE user_2fa_settings IS 'Configurações de autenticação de dois fatores por usuário';
COMMENT ON TABLE temp_2fa_codes IS 'Códigos temporários de 2FA enviados por email/SMS';
COMMENT ON TABLE user_2fa_attempts IS 'Log de tentativas de autenticação 2FA para auditoria';

-- Inserir configuração padrão para usuários existentes (opcional)
-- INSERT INTO user_2fa_settings (user_id, is_enabled)
-- SELECT id, FALSE FROM auth.users
-- WHERE id NOT IN (SELECT user_id FROM user_2fa_settings);