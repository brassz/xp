// =====================================================
// SCRIPT PARA CORRIGIR COLUNA DE MULTA VIA API
// =====================================================
// Este script pode ser executado no console do navegador
// para adicionar a coluna fine_amount se ela não existir

async function fixFineColumn() {
    console.log('🔧 Iniciando correção da coluna de multa...');
    
    // Verificar se supabase está disponível
    if (typeof supabase === 'undefined') {
        console.error('❌ Supabase não está disponível. Certifique-se de estar na página do sistema.');
        return;
    }
    
    try {
        // Executar SQL para adicionar a coluna
        const { data, error } = await supabase.rpc('exec_sql', {
            query: `
                -- Adicionar coluna fine_amount se não existir
                DO $$ 
                BEGIN
                    IF NOT EXISTS (
                        SELECT 1 FROM information_schema.columns 
                        WHERE table_name = 'payments' AND column_name = 'fine_amount'
                    ) THEN
                        ALTER TABLE payments 
                        ADD COLUMN fine_amount DECIMAL(10,2) DEFAULT 0.00 CHECK (fine_amount >= 0);
                        
                        -- Migrar dados da coluna 'fine' se existir
                        IF EXISTS (
                            SELECT 1 FROM information_schema.columns 
                            WHERE table_name = 'payments' AND column_name = 'fine'
                        ) THEN
                            UPDATE payments SET fine_amount = COALESCE(fine, 0);
                        END IF;
                        
                        RAISE NOTICE 'Coluna fine_amount criada e dados migrados com sucesso!';
                    ELSE
                        RAISE NOTICE 'Coluna fine_amount já existe';
                    END IF;
                END $$;
            `
        });
        
        if (error) {
            console.error('❌ Erro ao executar SQL:', error);
            console.log('\n⚠️ A função exec_sql pode não estar disponível.');
            console.log('Por favor, execute o script SQL manualmente no painel do Supabase.');
            console.log('Arquivo: fix-fine-column-name.sql');
            return;
        }
        
        console.log('✅ Correção aplicada com sucesso!');
        
        // Verificar se funcionou
        const { data: testData, error: testError } = await supabase
            .from('payments')
            .select('id, fine_amount')
            .limit(1);
        
        if (testError) {
            console.error('❌ Erro ao verificar coluna:', testError);
        } else {
            console.log('✅ Coluna fine_amount está funcionando!');
            console.log('📊 Dados de teste:', testData);
        }
        
        // Mostrar estatísticas de multas
        const { data: stats, error: statsError } = await supabase
            .from('payments')
            .select('fine_amount');
        
        if (!statsError && stats) {
            const totalPayments = stats.length;
            const paymentsWithFine = stats.filter(p => (p.fine_amount || 0) > 0).length;
            const totalFines = stats.reduce((sum, p) => sum + (parseFloat(p.fine_amount) || 0), 0);
            
            console.log('\n📊 ESTATÍSTICAS DE MULTAS:');
            console.log(`Total de pagamentos: ${totalPayments}`);
            console.log(`Pagamentos com multa: ${paymentsWithFine}`);
            console.log(`Total em multas: R$ ${totalFines.toFixed(2)}`);
        }
        
        console.log('\n✨ Correção concluída! Recarregue a página (F5) para ver as mudanças.');
        
    } catch (error) {
        console.error('❌ Erro inesperado:', error);
        console.log('\n⚠️ Execute o script SQL manualmente no painel do Supabase.');
        console.log('Arquivo: fix-fine-column-name.sql');
    }
}

// Executar a correção
console.log('🚀 Para executar a correção, copie e cole o comando abaixo:');
console.log('fixFineColumn()');
console.log('\nOu execute automaticamente em 3 segundos...');

// Descomentar a linha abaixo para executar automaticamente
// setTimeout(fixFineColumn, 3000);
