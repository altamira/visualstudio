
create procedure pr_limpa_base_contabil
@cd_empresa int

as

-- Limpeza dos Valores de Débito, Crédito e Saldo da Tabela Plano_Conta
Print('Limpeza dos Valores de Débito, Crédito e Saldo da Tabela Plano_Conta')
update Plano_Conta
set vl_saldo_inicial_conta = null,
    ic_saldo_inicial_conta = null,
    vl_debito_conta = null, 
    vl_credito_conta = null, 
    qt_lancamento_conta = null, 
    vl_saldo_atual_conta = null
where cd_empresa = @cd_empresa

-- Limpeza Saldos das Contas
Print('Limpeza Saldos das Contas')
delete from saldo_conta where cd_empresa = @cd_empresa
delete from saldo_conta_implantacao where cd_empresa = @cd_empresa

-- Limpeza Lote_Contabil
Print('Limpeza Lote_Contabil')
delete from lote_contabil where cd_empresa = @cd_empresa

-- Limpeza Movimento_Contabil
Print('Limpeza Movimento_Contabil')
delete from movimento_contabil where cd_empresa = @cd_empresa

