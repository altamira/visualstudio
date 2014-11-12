
-------------------------------------------------------------------------------
--sp_helptext pr_movimento_caixa_tipo_pagamento
-------------------------------------------------------------------------------
--pr_movimento_caixa_tipo_pagamento
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta do movimento de Caixa por Tipo de Pagamento
--Data             : 01.01.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_movimento_caixa_tipo_pagamento
@ic_parametro      int      = 0,
@cd_tipo_pagamento int      = 0,
@dt_inicial        datetime = '',
@dt_final          datetime = ''

as

------------------------------------------------------------------------------
--Resumo
------------------------------------------------------------------------------
if @ic_parametro = 1
begin

--  print 'Resumo'

  select
    tpc.nm_tipo_pagamento,
    sum(mc.vl_movimento_caixa) as vl_total_movimento
  into
    #ResumoTipoPagamento
  from  
    movimento_caixa mc                              with (nolock)
    left outer join movimento_caixa_recebimento mcr with (nolock) on mcr.cd_movimento_caixa      = mc.cd_movimento_caixa
    left outer join Motorista m                     with (nolock) on m.cd_motorista              = mcr.cd_motorista
    Inner Join Tipo_Movimento_Caixa tmc             with (nolock) on tmc.cd_tipo_movimento_caixa = mc.cd_tipo_movimento_caixa
    left outer join Tipo_Pagamento_Caixa tpc        with (nolock) on tpc.cd_tipo_pagamento       = mc.cd_tipo_pagamento
    left outer join Historico_Recebimento hr        with (nolock) on hr.cd_historico_recebimento = mcr.cd_historico_recebimento
    left outer join Condicao_Pagamento cp           with (nolock) on cp.cd_condicao_pagamento    = mc.cd_condicao_pagamento
  where
    mc.dt_movimento_caixa between @dt_inicial and @dt_final and
    mc.cd_tipo_pagamento = case when @cd_tipo_pagamento = 0 then mc.cd_tipo_pagamento else @cd_tipo_pagamento end
  group by
   tpc.nm_tipo_pagamento

  declare @vl_total_movimento float

  set @vl_total_movimento = 0

  select  
    @vl_total_movimento = isnull(vl_total_movimento,0)
  from
    #ResumoTipoPagamento

  select
    *,
    ( vl_total_movimento / @vl_total_movimento ) * 100 as pc_movimento
  from
    #ResumoTipoPagamento
  order by
    nm_tipo_pagamento
  
end

------------------------------------------------------------------------------
--Analítico
------------------------------------------------------------------------------

if @ic_parametro = 2

begin

  select
    mc.cd_movimento_caixa,
    mc.dt_movimento_caixa,
    tpc.nm_tipo_pagamento,
    mc.vl_movimento_caixa,
    cp.nm_condicao_pagamento,
    mcr.dt_vencimento_caixa,
    mcr.dt_pagamento_caixa,
    hr.nm_historico_recebimento,
    mcr.nm_historico_complemento

  from  
    movimento_caixa mc                              with (nolock)
    left outer join movimento_caixa_recebimento mcr with (nolock) on mcr.cd_movimento_caixa      = mc.cd_movimento_caixa
    left outer join Motorista m                     with (nolock) on m.cd_motorista              = mcr.cd_motorista
    Inner Join Tipo_Movimento_Caixa tmc             with (nolock) on tmc.cd_tipo_movimento_caixa = mc.cd_tipo_movimento_caixa
    left outer join Tipo_Pagamento_Caixa tpc        with (nolock) on tpc.cd_tipo_pagamento       = mc.cd_tipo_pagamento
    left outer join Historico_Recebimento hr        with (nolock) on hr.cd_historico_recebimento = mcr.cd_historico_recebimento
    left outer join Condicao_Pagamento cp           with (nolock) on cp.cd_condicao_pagamento    = mc.cd_condicao_pagamento
  where
    mc.dt_movimento_caixa between @dt_inicial and @dt_final and
    mc.cd_tipo_pagamento = case when @cd_tipo_pagamento = 0 then mc.cd_tipo_pagamento else @cd_tipo_pagamento end

  --select * from tipo_pagamento_caixa

end

--select * from movimento_caixa_recebimento

