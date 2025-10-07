-- Criar tabela para códigos de verificação
CREATE TABLE IF NOT EXISTS verification_codes (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  email TEXT NOT NULL,
  code TEXT NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  expires_at TIMESTAMP WITH TIME ZONE DEFAULT (NOW() + INTERVAL '5 minutes'),
  used BOOLEAN DEFAULT FALSE,
  ip_address TEXT,
  user_agent TEXT
);

-- Criar índices para performance
CREATE INDEX IF NOT EXISTS idx_verification_codes_email ON verification_codes(email);
CREATE INDEX IF NOT EXISTS idx_verification_codes_expires ON verification_codes(expires_at);
CREATE INDEX IF NOT EXISTS idx_verification_codes_code ON verification_codes(code);

-- Criar função para limpar códigos expirados
CREATE OR REPLACE FUNCTION cleanup_expired_codes()
RETURNS void AS $$
BEGIN
  DELETE FROM verification_codes 
  WHERE expires_at < NOW() OR used = true;
END;
$$ LANGUAGE plpgsql;

-- Criar trigger para limpeza automática (opcional)
-- Executa limpeza a cada inserção
CREATE OR REPLACE FUNCTION trigger_cleanup_codes()
RETURNS TRIGGER AS $$
BEGIN
  -- Limpar códigos expirados a cada 100 inserções (para não sobrecarregar)
  IF random() < 0.01 THEN
    PERFORM cleanup_expired_codes();
  END IF;
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Criar o trigger
DROP TRIGGER IF EXISTS cleanup_codes_trigger ON verification_codes;
CREATE TRIGGER cleanup_codes_trigger
  AFTER INSERT ON verification_codes
  FOR EACH ROW
  EXECUTE FUNCTION trigger_cleanup_codes();

-- Política de segurança (RLS)
ALTER TABLE verification_codes ENABLE ROW LEVEL SECURITY;

-- Permitir inserção para usuários autenticados
CREATE POLICY "Allow insert verification codes" ON verification_codes
  FOR INSERT WITH CHECK (true);

-- Permitir leitura apenas do próprio email
CREATE POLICY "Allow read own verification codes" ON verification_codes
  FOR SELECT USING (true);

-- Permitir update apenas para marcar como usado
CREATE POLICY "Allow update verification codes" ON verification_codes
  FOR UPDATE USING (true);

-- Comentários para documentação
COMMENT ON TABLE verification_codes IS 'Tabela para armazenar códigos de verificação por email';
COMMENT ON COLUMN verification_codes.email IS 'Email para o qual o código foi enviado';
COMMENT ON COLUMN verification_codes.code IS 'Código de verificação de 6 dígitos';
COMMENT ON COLUMN verification_codes.expires_at IS 'Data/hora de expiração do código (5 minutos após criação)';
COMMENT ON COLUMN verification_codes.used IS 'Indica se o código já foi utilizado';
COMMENT ON COLUMN verification_codes.ip_address IS 'IP do usuário que solicitou o código (opcional)';
COMMENT ON COLUMN verification_codes.user_agent IS 'User agent do navegador (opcional)';

-- Inserir dados de exemplo (opcional, remover em produção)
-- INSERT INTO verification_codes (email, code) VALUES ('teste@exemplo.com', '123456');