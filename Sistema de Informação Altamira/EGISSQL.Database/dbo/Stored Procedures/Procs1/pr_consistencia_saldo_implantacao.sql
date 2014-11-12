
-----------------------------------------------------------------------------------
--pr_consistencia_saldo_implantacao
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2004                     
-----------------------------------------------------------------------------------
--Stored Procedure    : SQL Server Microsoft 2000
--Autor (es)          : Carlos Cardoso Fernandes         
--Banco Dados         : EGISSQL
--Objetivo            : Consistência dos Saldos de Balanço / Implantação
--                      para iniciar a Contabilidade com os valores de Débito/Crédito 
--                      consistentes
--Data                : 28/12/2004
--Atualizado          : 29/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso 
--                    : 01.02.2006 - Revisão - Carlos Fernandes
-----------------------------------------------------------------------------------

create procedure pr_consistencia_saldo_implantacao
@dt_inicial datetime,
@dt_final   datetime

as

--select * from plano_conta
--
--select * from saldo_conta_implantacao

declare @vl_debito  float
declare @vl_credito float
declare @ic_fechado char(3)

set @vl_debito  = 0
set @vl_credito = 0
set @ic_fechado = ''

--Valor Débito

select 
 @vl_debito = sum( isnull(sci.vl_saldo_implantacao,0) )
from 
 saldo_conta_implantacao sci,
 plano_conta pc
where
 sci.dt_implantacao between @dt_inicial and @dt_final and
 isnull(sci.ic_saldo_implantacao,'') = 'D'            and
 sci.cd_conta = pc.cd_conta                           --and
-- isnull(pc.ic_lancamento_conta,'N')  = 'S'

--Valor Crédito

select 
 @vl_credito = sum( isnull(sci.vl_saldo_implantacao,0) )
from 
 saldo_conta_implantacao sci,
 plano_conta pc
where
 sci.dt_implantacao between @dt_inicial and @dt_final and
 isnull(sci.ic_saldo_implantacao,'') = 'C'            and
 sci.cd_conta = pc.cd_conta                           --and
-- isnull(pc.ic_lancamento_conta,'N')  = 'S'


if isnull(@vl_debito,0)<>isnull(@vl_credito,0)
begin
  set @ic_fechado = 'Não'
end
else
  set @ic_fechado = 'Sim'

select 
  @ic_fechado            as Fechado,
  isnull(@vl_debito,0)   as Debito,
  isnull(@vl_credito,0)  as Credito


