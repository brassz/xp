// =====================================================
// INTEGRAÇÃO DE COMISSÕES NOS RELATÓRIOS NEXUS
// =====================================================
// Funções para incluir dados de comissões nos relatórios
// semanais e mensais existentes
// =====================================================

// =====================================================
// FUNÇÕES PARA BUSCAR DADOS DE COMISSÕES
// =====================================================

/**
 * Busca comissões por período
 */
async function getCommissionsByPeriod(startDate, endDate, filters = {}) {
    try {
        let query = supabase
            .from('commissions_with_details')
            .select('*')
            .gte('operation_date', startDate)
            .lte('operation_date', endDate);

        // Aplicar filtros opcionais
        if (filters.user_id) {
            query = query.eq('user_id', filters.user_id);
        }
        
        if (filters.reference_type) {
            query = query.eq('reference_type', filters.reference_type);
        }
        
        if (filters.status) {
            query = query.eq('status', filters.status);
        }

        const { data, error } = await query.order('operation_date', { ascending: false });

        if (error) {
            console.error('Erro ao buscar comissões:', error);
            return [];
        }

        return data || [];
    } catch (error) {
        console.error('Erro ao buscar comissões por período:', error);
        return [];
    }
}

/**
 * Busca resumo de comissões usando a função do banco
 */
async function getCommissionSummary(startDate, endDate, filters = {}) {
    try {
        const { data, error } = await supabase
            .rpc('generate_commission_report', {
                start_date: startDate,
                end_date: endDate,
                user_filter: filters.user_id || null,
                reference_type_filter: filters.reference_type || null
            });

        if (error) {
            console.error('Erro ao gerar resumo de comissões:', error);
            return null;
        }

        return data && data.length > 0 ? data[0] : null;
    } catch (error) {
        console.error('Erro ao buscar resumo de comissões:', error);
        return null;
    }
}

/**
 * Busca comissões agrupadas por usuário
 */
async function getCommissionsByUser(startDate, endDate) {
    try {
        const { data, error } = await supabase
            .from('commissions_with_details')
            .select('user_id, user_name, commission_amount, status')
            .gte('operation_date', startDate)
            .lte('operation_date', endDate);

        if (error) {
            console.error('Erro ao buscar comissões por usuário:', error);
            return [];
        }

        // Agrupar por usuário
        const groupedData = {};
        data.forEach(commission => {
            const userId = commission.user_id || 'sem_usuario';
            const userName = commission.user_name || 'Sem usuário';
            
            if (!groupedData[userId]) {
                groupedData[userId] = {
                    user_id: userId,
                    user_name: userName,
                    total_commission: 0,
                    pending_commission: 0,
                    paid_commission: 0,
                    count: 0
                };
            }
            
            groupedData[userId].total_commission += parseFloat(commission.commission_amount || 0);
            groupedData[userId].count++;
            
            if (commission.status === 'pending') {
                groupedData[userId].pending_commission += parseFloat(commission.commission_amount || 0);
            } else if (commission.status === 'paid') {
                groupedData[userId].paid_commission += parseFloat(commission.commission_amount || 0);
            }
        });

        return Object.values(groupedData);
    } catch (error) {
        console.error('Erro ao buscar comissões por usuário:', error);
        return [];
    }
}

// =====================================================
// FUNÇÕES PARA INTEGRAR COMISSÕES NOS RELATÓRIOS EXISTENTES
// =====================================================

/**
 * Gera relatório semanal com comissões (extensão da função existente)
 */
async function generateWeeklyReportWithCommissions() {
    try {
        showInfoMessage('Gerando relatório semanal com comissões...');

        const today = new Date();
        const lastWeek = new Date(today.getTime() - 7 * 24 * 60 * 60 * 1000);
        
        // Buscar dados existentes de empréstimos
        const { data: loans, error: loansError } = await supabase
            .from('loans_with_details')
            .select('*')
            .gte('loan_date', lastWeek.toISOString().split('T')[0])
            .lte('loan_date', today.toISOString().split('T')[0]);

        if (loansError) {
            throw new Error('Erro ao buscar empréstimos: ' + loansError.message);
        }

        // Buscar dados de comissões
        const commissions = await getCommissionsByPeriod(
            lastWeek.toISOString().split('T')[0],
            today.toISOString().split('T')[0]
        );

        const commissionSummary = await getCommissionSummary(
            lastWeek.toISOString().split('T')[0],
            today.toISOString().split('T')[0]
        );

        const commissionsByUser = await getCommissionsByUser(
            lastWeek.toISOString().split('T')[0],
            today.toISOString().split('T')[0]
        );

        // Criar PDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        let yPosition = 20;

        // Cabeçalho
        doc.setFontSize(18);
        doc.text('RELATÓRIO SEMANAL - EMPRÉSTIMOS E COMISSÕES', 20, yPosition);
        yPosition += 10;

        doc.setFontSize(12);
        doc.text(`Período: ${lastWeek.toLocaleDateString('pt-BR')} a ${today.toLocaleDateString('pt-BR')}`, 20, yPosition);
        yPosition += 15;

        // Seção de Empréstimos
        doc.setFontSize(14);
        doc.text('RESUMO DE EMPRÉSTIMOS', 20, yPosition);
        yPosition += 10;

        const totalLoans = loans.length;
        const totalAmount = loans.reduce((sum, loan) => sum + parseFloat(loan.amount || 0), 0);
        const totalInterest = loans.reduce((sum, loan) => sum + (parseFloat(loan.amount || 0) * parseFloat(loan.interest_rate || 0) / 100), 0);

        doc.setFontSize(10);
        doc.text(`Total de empréstimos: ${totalLoans}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor total emprestado: R$ ${totalAmount.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Total de juros: R$ ${totalInterest.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 15;

        // Seção de Comissões
        doc.setFontSize(14);
        doc.text('RESUMO DE COMISSÕES', 20, yPosition);
        yPosition += 10;

        doc.setFontSize(10);
        if (commissionSummary) {
            doc.text(`Total de comissões: ${commissionSummary.total_commissions}`, 20, yPosition);
            yPosition += 6;
            doc.text(`Valor total de comissões: R$ ${parseFloat(commissionSummary.total_commission_amount || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
            yPosition += 6;
            doc.text(`Taxa média de comissão: ${parseFloat(commissionSummary.avg_commission_rate || 0).toFixed(2)}%`, 20, yPosition);
            yPosition += 6;
            doc.text(`Comissões pendentes: ${commissionSummary.pending_commissions}`, 20, yPosition);
            yPosition += 6;
            doc.text(`Comissões pagas: ${commissionSummary.paid_commissions}`, 20, yPosition);
            yPosition += 15;
        } else {
            doc.text('Nenhuma comissão encontrada no período', 20, yPosition);
            yPosition += 15;
        }

        // Comissões por Usuário
        if (commissionsByUser.length > 0) {
            doc.setFontSize(14);
            doc.text('COMISSÕES POR USUÁRIO', 20, yPosition);
            yPosition += 10;

            doc.setFontSize(10);
            commissionsByUser.forEach(user => {
                if (yPosition > 270) {
                    doc.addPage();
                    yPosition = 20;
                }
                
                doc.text(`${user.user_name}:`, 20, yPosition);
                yPosition += 6;
                doc.text(`  • Total: R$ ${user.total_commission.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 25, yPosition);
                yPosition += 6;
                doc.text(`  • Pendente: R$ ${user.pending_commission.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 25, yPosition);
                yPosition += 6;
                doc.text(`  • Pago: R$ ${user.paid_commission.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 25, yPosition);
                yPosition += 8;
            });
        }

        // Detalhes das Comissões
        if (commissions.length > 0) {
            yPosition += 10;
            doc.setFontSize(14);
            doc.text('DETALHES DAS COMISSÕES', 20, yPosition);
            yPosition += 10;

            doc.setFontSize(8);
            commissions.forEach(commission => {
                if (yPosition > 270) {
                    doc.addPage();
                    yPosition = 20;
                }

                const operationDate = new Date(commission.operation_date).toLocaleDateString('pt-BR');
                const commissionAmount = parseFloat(commission.commission_amount || 0);
                const interestAmount = parseFloat(commission.interest_amount || 0);
                
                doc.text(`${operationDate} - ${commission.client_name} (${commission.reference_type})`, 20, yPosition);
                yPosition += 4;
                doc.text(`  Juros: R$ ${interestAmount.toLocaleString('pt-BR', { minimumFractionDigits: 2 })} | Comissão: R$ ${commissionAmount.toLocaleString('pt-BR', { minimumFractionDigits: 2 })} | Status: ${commission.status}`, 20, yPosition);
                yPosition += 6;
            });
        }

        // Salvar PDF
        const fileName = `relatorio_semanal_comissoes_${new Date().getTime()}.pdf`;
        doc.save(fileName);

        showInfoMessage('Relatório semanal com comissões gerado com sucesso!');

    } catch (error) {
        console.error('Erro ao gerar relatório semanal com comissões:', error);
        showErrorMessage('Erro ao gerar relatório semanal: ' + error.message);
    }
}

/**
 * Gera relatório mensal com comissões
 */
async function generateMonthlyReportWithCommissions() {
    try {
        showInfoMessage('Gerando relatório mensal com comissões...');

        const today = new Date();
        const firstDayOfMonth = new Date(today.getFullYear(), today.getMonth(), 1);
        const lastDayOfMonth = new Date(today.getFullYear(), today.getMonth() + 1, 0);

        // Buscar dados existentes de empréstimos
        const { data: loans, error: loansError } = await supabase
            .from('loans_with_details')
            .select('*')
            .gte('loan_date', firstDayOfMonth.toISOString().split('T')[0])
            .lte('loan_date', lastDayOfMonth.toISOString().split('T')[0]);

        if (loansError) {
            throw new Error('Erro ao buscar empréstimos: ' + loansError.message);
        }

        // Buscar dados de comissões
        const commissions = await getCommissionsByPeriod(
            firstDayOfMonth.toISOString().split('T')[0],
            lastDayOfMonth.toISOString().split('T')[0]
        );

        const commissionSummary = await getCommissionSummary(
            firstDayOfMonth.toISOString().split('T')[0],
            lastDayOfMonth.toISOString().split('T')[0]
        );

        const commissionsByUser = await getCommissionsByUser(
            firstDayOfMonth.toISOString().split('T')[0],
            lastDayOfMonth.toISOString().split('T')[0]
        );

        // Criar PDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        let yPosition = 20;

        // Cabeçalho
        doc.setFontSize(18);
        doc.text('RELATÓRIO MENSAL - EMPRÉSTIMOS E COMISSÕES', 20, yPosition);
        yPosition += 10;

        const monthName = firstDayOfMonth.toLocaleDateString('pt-BR', { month: 'long', year: 'numeric' });
        doc.setFontSize(12);
        doc.text(`Mês: ${monthName}`, 20, yPosition);
        yPosition += 15;

        // Seção de Empréstimos
        doc.setFontSize(14);
        doc.text('RESUMO DE EMPRÉSTIMOS', 20, yPosition);
        yPosition += 10;

        const totalLoans = loans.length;
        const totalAmount = loans.reduce((sum, loan) => sum + parseFloat(loan.amount || 0), 0);
        const totalInterest = loans.reduce((sum, loan) => sum + (parseFloat(loan.amount || 0) * parseFloat(loan.interest_rate || 0) / 100), 0);

        doc.setFontSize(10);
        doc.text(`Total de empréstimos: ${totalLoans}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Valor total emprestado: R$ ${totalAmount.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 6;
        doc.text(`Total de juros: R$ ${totalInterest.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
        yPosition += 15;

        // Seção de Comissões
        doc.setFontSize(14);
        doc.text('RESUMO DE COMISSÕES', 20, yPosition);
        yPosition += 10;

        doc.setFontSize(10);
        if (commissionSummary) {
            doc.text(`Total de comissões: ${commissionSummary.total_commissions}`, 20, yPosition);
            yPosition += 6;
            doc.text(`Valor total de comissões: R$ ${parseFloat(commissionSummary.total_commission_amount || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
            yPosition += 6;
            doc.text(`Taxa média de comissão: ${parseFloat(commissionSummary.avg_commission_rate || 0).toFixed(2)}%`, 20, yPosition);
            yPosition += 6;
            doc.text(`Comissões pendentes: ${commissionSummary.pending_commissions}`, 20, yPosition);
            yPosition += 6;
            doc.text(`Comissões pagas: ${commissionSummary.paid_commissions}`, 20, yPosition);
            yPosition += 15;

            // Análise de Performance
            const commissionPercentage = totalInterest > 0 ? (parseFloat(commissionSummary.total_commission_amount || 0) / totalInterest * 100) : 0;
            doc.text(`Percentual de comissão sobre juros: ${commissionPercentage.toFixed(2)}%`, 20, yPosition);
            yPosition += 15;
        } else {
            doc.text('Nenhuma comissão encontrada no período', 20, yPosition);
            yPosition += 15;
        }

        // Comissões por Usuário
        if (commissionsByUser.length > 0) {
            doc.setFontSize(14);
            doc.text('RANKING DE COMISSÕES POR USUÁRIO', 20, yPosition);
            yPosition += 10;

            // Ordenar por total de comissão
            commissionsByUser.sort((a, b) => b.total_commission - a.total_commission);

            doc.setFontSize(10);
            commissionsByUser.forEach((user, index) => {
                if (yPosition > 270) {
                    doc.addPage();
                    yPosition = 20;
                }
                
                doc.text(`${index + 1}º ${user.user_name}:`, 20, yPosition);
                yPosition += 6;
                doc.text(`  • Total: R$ ${user.total_commission.toLocaleString('pt-BR', { minimumFractionDigits: 2 })} (${user.count} operações)`, 25, yPosition);
                yPosition += 6;
                doc.text(`  • Pendente: R$ ${user.pending_commission.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 25, yPosition);
                yPosition += 6;
                doc.text(`  • Pago: R$ ${user.paid_commission.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 25, yPosition);
                yPosition += 8;
            });
        }

        // Salvar PDF
        const fileName = `relatorio_mensal_comissoes_${monthName.replace(/\s/g, '_')}_${new Date().getTime()}.pdf`;
        doc.save(fileName);

        showInfoMessage('Relatório mensal com comissões gerado com sucesso!');

    } catch (error) {
        console.error('Erro ao gerar relatório mensal com comissões:', error);
        showErrorMessage('Erro ao gerar relatório mensal: ' + error.message);
    }
}

/**
 * Gera relatório específico de comissões
 */
async function generateCommissionOnlyReport(startDate, endDate) {
    try {
        showInfoMessage('Gerando relatório de comissões...');

        const commissions = await getCommissionsByPeriod(startDate, endDate);
        const commissionSummary = await getCommissionSummary(startDate, endDate);
        const commissionsByUser = await getCommissionsByUser(startDate, endDate);

        // Criar PDF
        const { jsPDF } = window.jspdf;
        const doc = new jsPDF();

        let yPosition = 20;

        // Cabeçalho
        doc.setFontSize(18);
        doc.text('RELATÓRIO DE COMISSÕES', 20, yPosition);
        yPosition += 10;

        doc.setFontSize(12);
        doc.text(`Período: ${new Date(startDate).toLocaleDateString('pt-BR')} a ${new Date(endDate).toLocaleDateString('pt-BR')}`, 20, yPosition);
        yPosition += 15;

        // Resumo Geral
        doc.setFontSize(14);
        doc.text('RESUMO GERAL', 20, yPosition);
        yPosition += 10;

        doc.setFontSize(10);
        if (commissionSummary) {
            doc.text(`Total de comissões: ${commissionSummary.total_commissions}`, 20, yPosition);
            yPosition += 6;
            doc.text(`Valor total de comissões: R$ ${parseFloat(commissionSummary.total_commission_amount || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
            yPosition += 6;
            doc.text(`Valor total de juros: R$ ${parseFloat(commissionSummary.total_interest_amount || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 20, yPosition);
            yPosition += 6;
            doc.text(`Taxa média de comissão: ${parseFloat(commissionSummary.avg_commission_rate || 0).toFixed(2)}%`, 20, yPosition);
            yPosition += 6;
            doc.text(`Comissões pendentes: ${commissionSummary.pending_commissions}`, 20, yPosition);
            yPosition += 6;
            doc.text(`Comissões pagas: ${commissionSummary.paid_commissions}`, 20, yPosition);
            yPosition += 15;
        }

        // Por tipo de operação
        const commissionsByType = {};
        commissions.forEach(commission => {
            const type = commission.reference_type;
            if (!commissionsByType[type]) {
                commissionsByType[type] = {
                    count: 0,
                    total_commission: 0,
                    total_interest: 0
                };
            }
            commissionsByType[type].count++;
            commissionsByType[type].total_commission += parseFloat(commission.commission_amount || 0);
            commissionsByType[type].total_interest += parseFloat(commission.interest_amount || 0);
        });

        if (Object.keys(commissionsByType).length > 0) {
            doc.setFontSize(14);
            doc.text('POR TIPO DE OPERAÇÃO', 20, yPosition);
            yPosition += 10;

            doc.setFontSize(10);
            Object.entries(commissionsByType).forEach(([type, data]) => {
                const typeName = type === 'loan' ? 'Empréstimos' : type === 'installment' ? 'Parcelamentos' : type;
                doc.text(`${typeName}:`, 20, yPosition);
                yPosition += 6;
                doc.text(`  • Quantidade: ${data.count}`, 25, yPosition);
                yPosition += 6;
                doc.text(`  • Comissões: R$ ${data.total_commission.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 25, yPosition);
                yPosition += 6;
                doc.text(`  • Juros base: R$ ${data.total_interest.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 25, yPosition);
                yPosition += 8;
            });
            yPosition += 10;
        }

        // Por usuário
        if (commissionsByUser.length > 0) {
            doc.setFontSize(14);
            doc.text('POR USUÁRIO', 20, yPosition);
            yPosition += 10;

            commissionsByUser.sort((a, b) => b.total_commission - a.total_commission);

            doc.setFontSize(10);
            commissionsByUser.forEach(user => {
                if (yPosition > 270) {
                    doc.addPage();
                    yPosition = 20;
                }
                
                doc.text(`${user.user_name}:`, 20, yPosition);
                yPosition += 6;
                doc.text(`  • Total: R$ ${user.total_commission.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 25, yPosition);
                yPosition += 6;
                doc.text(`  • Pendente: R$ ${user.pending_commission.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 25, yPosition);
                yPosition += 6;
                doc.text(`  • Pago: R$ ${user.paid_commission.toLocaleString('pt-BR', { minimumFractionDigits: 2 })}`, 25, yPosition);
                yPosition += 8;
            });
        }

        // Salvar PDF
        const fileName = `relatorio_comissoes_${new Date().getTime()}.pdf`;
        doc.save(fileName);

        showInfoMessage('Relatório de comissões gerado com sucesso!');

    } catch (error) {
        console.error('Erro ao gerar relatório de comissões:', error);
        showErrorMessage('Erro ao gerar relatório de comissões: ' + error.message);
    }
}

// =====================================================
// FUNÇÕES PARA INTERFACE DE COMISSÕES
// =====================================================

/**
 * Carrega e exibe comissões pendentes
 */
async function loadPendingCommissions() {
    try {
        const { data, error } = await supabase
            .from('pending_commissions')
            .select('*')
            .order('operation_date', { ascending: false });

        if (error) {
            console.error('Erro ao carregar comissões pendentes:', error);
            return;
        }

        // Atualizar interface (assumindo que existe um elemento para exibir)
        const container = document.getElementById('pending-commissions-list');
        if (container) {
            container.innerHTML = '';
            
            if (data && data.length > 0) {
                data.forEach(commission => {
                    const commissionElement = createCommissionElement(commission);
                    container.appendChild(commissionElement);
                });
            } else {
                container.innerHTML = '<p>Nenhuma comissão pendente encontrada.</p>';
            }
        }

    } catch (error) {
        console.error('Erro ao carregar comissões pendentes:', error);
    }
}

/**
 * Cria elemento HTML para exibir comissão
 */
function createCommissionElement(commission) {
    const div = document.createElement('div');
    div.className = 'commission-item';
    div.innerHTML = `
        <div class="commission-header">
            <h4>${commission.client_name}</h4>
            <span class="commission-amount">R$ ${parseFloat(commission.commission_amount || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}</span>
        </div>
        <div class="commission-details">
            <p><strong>Tipo:</strong> ${commission.reference_type === 'loan' ? 'Empréstimo' : 'Parcelamento'}</p>
            <p><strong>Data:</strong> ${new Date(commission.operation_date).toLocaleDateString('pt-BR')}</p>
            <p><strong>Juros:</strong> R$ ${parseFloat(commission.interest_amount || 0).toLocaleString('pt-BR', { minimumFractionDigits: 2 })}</p>
            <p><strong>Taxa:</strong> ${commission.commission_rate}%</p>
            <p><strong>Usuário:</strong> ${commission.user_name || 'N/A'}</p>
        </div>
        <div class="commission-actions">
            <button onclick="markCommissionAsPaid('${commission.id}')" class="btn btn-success">Marcar como Paga</button>
        </div>
    `;
    return div;
}

/**
 * Marca comissão como paga
 */
async function markCommissionAsPaid(commissionId) {
    try {
        const { error } = await supabase
            .from('commissions')
            .update({ 
                status: 'paid',
                paid_date: new Date().toISOString().split('T')[0]
            })
            .eq('id', commissionId);

        if (error) {
            throw error;
        }

        showInfoMessage('Comissão marcada como paga!');
        loadPendingCommissions(); // Recarregar lista

    } catch (error) {
        console.error('Erro ao marcar comissão como paga:', error);
        showErrorMessage('Erro ao marcar comissão como paga: ' + error.message);
    }
}

// =====================================================
// INICIALIZAÇÃO E EVENTOS
// =====================================================

// Adicionar botões para os novos relatórios (quando o DOM estiver carregado)
document.addEventListener('DOMContentLoaded', function() {
    // Adicionar botão para relatório semanal com comissões
    const weeklyButton = document.getElementById('generate-weekly-report');
    if (weeklyButton) {
        weeklyButton.addEventListener('click', generateWeeklyReportWithCommissions);
    }

    // Adicionar botão para relatório mensal com comissões
    const monthlyButton = document.getElementById('generate-monthly-report');
    if (monthlyButton) {
        monthlyButton.addEventListener('click', generateMonthlyReportWithCommissions);
    }

    // Carregar comissões pendentes se estivermos na página de comissões
    if (document.getElementById('pending-commissions-list')) {
        loadPendingCommissions();
    }
});

// Exportar funções para uso global
window.generateWeeklyReportWithCommissions = generateWeeklyReportWithCommissions;
window.generateMonthlyReportWithCommissions = generateMonthlyReportWithCommissions;
window.generateCommissionOnlyReport = generateCommissionOnlyReport;
window.loadPendingCommissions = loadPendingCommissions;
window.markCommissionAsPaid = markCommissionAsPaid;