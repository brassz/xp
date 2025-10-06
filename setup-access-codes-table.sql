-- Criar tabela para códigos de acesso
CREATE TABLE IF NOT EXISTS access_codes (
    id SERIAL PRIMARY KEY,
    email VARCHAR(255) NOT NULL,
    code VARCHAR(6) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    expires_at TIMESTAMP WITH TIME ZONE NOT NULL,
    used BOOLEAN DEFAULT FALSE,
    ip_address VARCHAR(45),
    user_agent TEXT
);

-- Índices para otimização
CREATE INDEX IF NOT EXISTS idx_access_codes_email ON access_codes(email);
CREATE INDEX IF NOT EXISTS idx_access_codes_code ON access_codes(code);
CREATE INDEX IF NOT EXISTS idx_access_codes_expires_at ON access_codes(expires_at);

-- Função para limpar códigos expirados (executar periodicamente)
CREATE OR REPLACE FUNCTION cleanup_expired_access_codes()
RETURNS void AS $$
BEGIN
    DELETE FROM access_codes 
    WHERE expires_at < CURRENT_TIMESTAMP 
    OR (used = TRUE AND created_at < CURRENT_TIMESTAMP - INTERVAL '1 day');
END;
$$ LANGUAGE plpgsql;

-- Comentários
COMMENT ON TABLE access_codes IS 'Tabela para armazenar códigos de acesso temporários para login';
COMMENT ON COLUMN access_codes.code IS 'Código de 6 dígitos enviado por email';
COMMENT ON COLUMN access_codes.expires_at IS 'Data/hora de expiração do código (5 minutos após criação)';
COMMENT ON COLUMN access_codes.used IS 'Indica se o código já foi utilizado';