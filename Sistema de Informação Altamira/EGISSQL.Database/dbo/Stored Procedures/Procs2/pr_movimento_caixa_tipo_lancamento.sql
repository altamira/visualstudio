
-------------------------------------------------------------------------------
--sp_helptext pr_movimento_caixa_tipo_lancamento
-------------------------------------------------------------------------------
--pr_movimento_caixa_tipo_lancamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Lançamento no Caixa por Tipo de Lançamento
--
--Data             : 16.01.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_movimento_caixa_tipo_lancamento
@ic_parametro       int      = 0,
@cd_tipo_lancamento int      = 0,
@dt_inicial         datetime = '',
@dt_final           datetime = ''

as

--select * from movimento_caixa_recebimento
--select * from tipo_lancamento_caixa
--select * from historico_recebimento
--select * from Tipo_Documento 
--select * from terminal_caixa

select
  mc.cd_movimento_caixa,
  mc.dt_movimento_caixa,
  mc.cd_tipo_lancamento,
  tl.nm_tipo_lancamento,
  mc.vl_movimento_recebimento,
  mc.dt_vencimento_caixa,
  mc.dt_pagamento_caixa,
  hr.nm_historico_recebimento,
  mc.nm_historico_complemento,
  td.sg_tipo_documento,
  mc.cd_documento,
  v.nm_veiculo,
  m.nm_motorista,
  oc.nm_operador_caixa,
  mc.nm_obs_movimento_caixa,
  tc.sg_terminal_caixa,
  mc.dt_cancel_movimento

into
  #Mov_Tipo_Lancamento

from
  Movimento_Caixa_Recebimento mc           with (nolock)
  left outer join Tipo_Lancamento_Caixa tl with (nolock) on tl.cd_tipo_lancamento       = mc.cd_tipo_lancamento
  left outer join Veiculo               v  with (nolock) on v.cd_veiculo                = mc.cd_veiculo
  left outer join Motorista             m  with (nolock) on m.cd_motorista              = mc.cd_motorista
  left outer join Operador_Caixa       oc  with (nolock) on oc.cd_operador_caixa        = mc.cd_operador_caixa
  left outer join Historico_Recebimento hr with (nolock) on hr.cd_historico_recebimento = mc.cd_historico_recebimento
  left outer join Terminal_Caixa        tc with (nolock) on tc.cd_terminal_caixa        = mc.cd_terminal_caixa
  left outer join Tipo_Documento        td with (nolock) on td.cd_tipo_documento        = mc.cd_tipo_documento

where
  mc.dt_movimento_caixa between @dt_inicial and @dt_final and
  mc.dt_cancel_movimento is null

order by
  mc.dt_movimento_caixa,
  mc.cd_tipo_lancamento


--Resumo

if @ic_parametro = 1
begin
  declare @vl_total float
  set @vl_total = 0.00

  select
    @vl_total = sum ( vl_movimento_recebimento )
  from
    #Mov_Tipo_Lancamento 

  select
    cd_tipo_lancamento,
    nm_tipo_lancamento              as Tipo_Lancamento,
    sum( vl_movimento_recebimento ) as Total,
    pc_total = ( sum (vl_movimento_recebimento ) / @vl_total ) * 100
  from
    #Mov_Tipo_Lancamento 
  group by
    cd_tipo_lancamento,
    nm_tipo_lancamento
  order by
    cd_tipo_lancamento
     
end

--Analítico

if @ic_parametro = 2
begin

  select
    mc.*
  from
    #Mov_Tipo_Lancamento mc
  where
    mc.dt_movimento_caixa between @dt_inicial and @dt_final and
    mc.cd_tipo_lancamento = case when @cd_tipo_lancamento = 0 then mc.cd_tipo_lancamento else @cd_tipo_lancamento end and
    mc.dt_cancel_movimento is null

  order by
    mc.dt_movimento_caixa,
    mc.cd_tipo_lancamento

end
    
