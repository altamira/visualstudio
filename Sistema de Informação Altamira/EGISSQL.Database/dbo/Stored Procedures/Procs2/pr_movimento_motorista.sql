
-------------------------------------------------------------------------------
--sp_helptext pr_movimento_motorista
-------------------------------------------------------------------------------
--pr_movimento_motorista
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Movimento do Motorista
--Data             : 21.10.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_movimento_motorista
@ic_parametro int      = 1,
@cd_motorista int      = 0,
@dt_inicial   datetime = '',
@dt_final     datetime = ''

as

--Resumo

if @ic_parametro = 1
begin

select
  m.cd_motorista,
  m.nm_motorista,
  mc.dt_movimento_caixa,
 'vl_movimento_caixa' =
  sum(  case when tmc.ic_entrada_saida = 'E' then mc.vl_movimento_caixa
               else mc.vl_movimento_caixa * -1 end ),

 'vl_movimento_credito' =
  sum (    case when tmc.ic_entrada_saida = 'E' then mc.vl_movimento_caixa else 0 end ),

 'vl_movimento_debito' =
  sum (    case when tmc.ic_entrada_saida = 'S' then mc.vl_movimento_caixa else 0 end ),

  0.00  as vl_saldo_motorista

from
  movimento_caixa mc                              with (nolock)
  left outer join movimento_caixa_recebimento mcr with (nolock) on mcr.cd_movimento_caixa = mc.cd_movimento_caixa
  left outer join Motorista m                     with (nolock) on m.cd_motorista         = mcr.cd_motorista
  Inner Join Tipo_Movimento_Caixa tmc             with (nolock) on tmc.cd_tipo_movimento_caixa = mc.cd_tipo_movimento_caixa
where
  mc.dt_movimento_caixa between @dt_inicial and @dt_final
group by
  m.cd_motorista,
  m.nm_motorista,
  mc.dt_movimento_caixa 
order by
  m.nm_motorista

end


-------------------------------------------------------------------------------
--Analítico
-------------------------------------------------------------------------------

if @ic_parametro = 2
begin

  print 'analítico - movimeto Caixa'

  --select * from movimento_caixa

  select
    m.cd_motorista,
    m.nm_motorista,
    mc.dt_movimento_caixa,
    mc.cd_movimento_caixa,
    mc.vl_movimento_caixa  
   

  from
    movimento_caixa mc                              with (nolock)
    left outer join movimento_caixa_recebimento mcr with (nolock) on mcr.cd_movimento_caixa      = mc.cd_movimento_caixa
    left outer join Motorista m                     with (nolock) on m.cd_motorista              = mcr.cd_motorista
    inner Join Tipo_Movimento_Caixa tmc             with (nolock) on tmc.cd_tipo_movimento_caixa = mc.cd_tipo_movimento_caixa
  where
    mc.dt_movimento_caixa between @dt_inicial and @dt_final
  order by
    m.nm_motorista

end

