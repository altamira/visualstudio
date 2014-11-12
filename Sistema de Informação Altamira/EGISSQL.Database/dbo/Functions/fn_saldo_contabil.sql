
CREATE FUNCTION fn_saldo_contabil
(@dt_base datetime,
 @cd_exercicio int,
 @cd_conta int)
RETURNS numeric(25,2)

AS
BEGIN

-- Reduzido
declare @cd_reduzido int
declare @ic_natureza char(1)
declare @vl_saldo    numeric(25,2)
declare @vl_debito   numeric(25,2)
declare @vl_credito  numeric(25,2)

select 
  @cd_reduzido = cd_conta_reduzido
from 
  plano_conta 
where
  cd_empresa = dbo.fn_empresa() and
  cd_conta = @cd_conta

-- Saldo Atual
select 
  @vl_saldo = case when (isnull(ic_saldo_atual_conta,'C') = 'C') then
                isnull(vl_saldo_atual_conta,0)
              else
                (isnull(vl_saldo_atual_conta,0)*(-1))
              end 
from 
  plano_conta 
where
  cd_empresa = dbo.fn_empresa() and
  cd_conta = @cd_conta

-- Movimento do Período Pedido
select 
  @vl_debito = sum(isnull(vl_lancamento_contabil,0))
from 
  movimento_contabil
where
  cd_reduzido_debito = @cd_reduzido and
  dt_lancamento_contabil > @dt_base and
  cd_empresa = dbo.fn_empresa() and
  cd_exercicio = @cd_exercicio

select 
  @vl_credito = sum(isnull(vl_lancamento_contabil,0))
from 
  movimento_contabil
where
  cd_reduzido_credito = @cd_reduzido and
  dt_lancamento_contabil > @dt_base and
  cd_empresa = dbo.fn_empresa() and
  cd_exercicio = @cd_exercicio

set @vl_saldo = @vl_saldo + isnull(@vl_debito,0) - isnull(@vl_credito,0)

return(@vl_saldo)

end

