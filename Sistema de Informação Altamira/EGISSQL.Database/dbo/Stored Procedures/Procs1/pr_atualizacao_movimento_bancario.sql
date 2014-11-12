

create procedure pr_atualizacao_movimento_bancario
@cd_banco                 int,
@cd_conta_banco           int,
@cd_tipo_lancamento_fluxo char(1),
@cd_usuario               int
as

declare @cd_plano_financeiro     int
declare @cd_historico_financeiro int
declare @cd_moeda                int
 
set @cd_plano_financeiro     = 0
set @cd_historico_financeiro = 0
set @cd_moeda                = 0

--Busca os Parâmetros da Tabela Parametro_Extrato_Banco

select 
  @cd_plano_financeiro     = cd_plano_financeiro,
  @cd_historico_financeiro = cd_historico_financeiro,
  @cd_banco       = case when isnull(@cd_banco,0)=0       then cd_banco       else @cd_banco       end,
  @cd_conta_banco = case when isnull(@cd_conta_banco,0)=0 then cd_conta_banco else @cd_conta_banco end 
from
  Parametro_Extrato_Banco
where
  cd_empresa = dbo.fn_empresa()

--Moeda
--Trazer a Padrão

set @cd_moeda = 1

--Montagem da Tabela Auxiliar

select 
  --Busca Código p/ Gerar o número do Lançamento na Movimentação Banco

  identity(int, 10000,1 ) as cd_lancamento, 
  *
into #Movimento_Extrato_Bancario
from Extrato_Bancario
where
  cd_banco       = @cd_banco and
  cd_conta_banco = @cd_conta_banco

--Inclusão dos dados do Extrato Bancário referente ao Banco e Conta Corrente

insert INTO Conta_Banco_Lancamento 
(  cd_lancamento,
   dt_lancamento,
   vl_lancamento,
   nm_historico_lancamento,
   cd_conta_banco,
   cd_plano_financeiro,
   cd_tipo_operacao,
   cd_historico_financeiro,
   cd_moeda,
   cd_usuario,
   dt_usuario,
   cd_tipo_lancamento_fluxo,
   ic_lancamento_conciliado,
   ic_transferencia_conta,
   cd_empresa)

select 
   cd_lancamento,
   dt_extrato_banco,
   case when vl_extrato_banco<0 then vl_extrato_banco*(-1) else vl_extrato_banco end,
   nm_extrato_banco,
   cd_conta_banco,
   @cd_plano_financeiro,
   case when vl_extrato_banco>0 then 1 else 2 end,
   @cd_historico_financeiro,
   @cd_moeda,
   @cd_usuario,
   getdate(),
   @cd_tipo_lancamento_fluxo,
   'N',
   'N',
   dbo.fn_empresa()      --Se for primaveras parâmetro
                    
from 
   #Movimento_Extrato_Bancario
where
  cd_banco       = @cd_banco and
  cd_conta_banco = @cd_conta_banco


