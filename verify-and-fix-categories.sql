-- Script para verificar e corrigir o problema das categorias de despesas
-- Execute este script no painel SQL do Supabase

-- =====================================================
-- VERIFICAR SE A TABELA EXISTE
-- =====================================================
SELECT 
    table_name,
    table_type
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name = 'expense_categories';

-- =====================================================
-- CRIAR TABELA SE NÃO EXISTIR
-- =====================================================
CREATE TABLE IF NOT EXISTS expense_categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL UNIQUE,
    description TEXT,
    color TEXT DEFAULT '#6B7280',
    icon TEXT DEFAULT 'receipt',
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- =====================================================
-- INSERIR CATEGORIAS PADRÃO
-- =====================================================
INSERT INTO expense_categories (name, description, color, icon) VALUES
('Alimentação', 'Despesas com comida e bebidas', '#EF4444', 'utensils'),
('Transporte', 'Despesas com locomoção', '#3B82F6', 'car'),
('Escritório', 'Material de escritório e equipamentos', '#8B5CF6', 'briefcase'),
('Marketing', 'Despesas com publicidade e marketing', '#F59E0B', 'megaphone'),
('Tecnologia', 'Equipamentos e software', '#10B981', 'laptop'),
('Saúde', 'Despesas médicas e farmácia', '#EC4899', 'heart'),
('Educação', 'Cursos, livros e treinamentos', '#6366F1', 'book'),
('Limpeza', 'Produtos de limpeza e higiene', '#14B8A6', 'spray'),
('Manutenção', 'Reparos e manutenções', '#F97316', 'wrench'),
('Outros', 'Despesas diversas', '#6B7280', 'folder')
ON CONFLICT (name) DO NOTHING;

-- =====================================================
-- HABILITAR RLS (Row Level Security)
-- =====================================================
ALTER TABLE expense_categories ENABLE ROW LEVEL SECURITY;

-- =====================================================
-- CRIAR POLÍTICAS DE SEGURANÇA
-- =====================================================
-- Permitir que todos vejam as categorias ativas
DROP POLICY IF EXISTS "Anyone can view active expense categories" ON expense_categories;
CREATE POLICY "Anyone can view active expense categories" ON expense_categories
    FOR SELECT USING (is_active = true);

-- =====================================================
-- VERIFICAR DADOS INSERIDOS
-- =====================================================
SELECT 
    id,
    name,
    description,
    color,
    icon,
    is_active,
    created_at
FROM expense_categories 
ORDER BY name;

-- =====================================================
-- CONTAR CATEGORIAS
-- =====================================================
SELECT 
    COUNT(*) as total_categories,
    COUNT(*) FILTER (WHERE is_active = true) as active_categories
FROM expense_categories;