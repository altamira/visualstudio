
create procedure pr_posicao_contas_receber_portador
@cd_portador int = 0,
@dt_inicial  datetime,
@dt_final    datetime
as

  select
    p.cd_portador,
    isnull(max(p.nm_portador),'Portador não Cadastrado') as 'Portador',
    --Vencidas
    sum( case when ((dr.dt_vencimento_documento < @dt_inicial) and (isnull (vl_saldo_documento,0)>0 )) then
    dr.vl_saldo_documento else 0 end ) as 'Vencidas',

    sum( case when ((dr.dt_vencimento_documento between @dt_inicial and @dt_final) ) then
    dr.vl_saldo_documento else 0 end ) as 'Mes',

    sum( case when ((dr.dt_vencimento_documento between @dt_final+1 and @dt_final+30) ) then
    dr.vl_saldo_documento else 0 end ) as '30 dias',

    sum( case when ((dr.dt_vencimento_documento between @dt_final+31 and  @dt_final+60) ) then
    dr.vl_saldo_documento else 0 end ) as '60 dias',

    sum( case when ((dr.dt_vencimento_documento between @dt_final+61 and @dt_final+90) ) then
    dr.vl_saldo_documento else 0 end ) as '90 dias',

    sum( case when ((dr.dt_vencimento_documento >= @dt_final+91 ) ) then
    dr.vl_saldo_documento else 0 end ) as '120 dias',
      
    sum ( dr.vl_saldo_documento )      as 'TotalGeral' 
  from
    Documento_receber dr
    left outer join Portador p on p.cd_portador = dr.cd_portador
  where
    dr.cd_portador = case when @cd_portador = 0 then dr.cd_portador else @cd_portador end and
    --dr.cd_portador = p.cd_portador  and
    dr.dt_cancelamento_documento is null and
    dr.dt_devolucao_documento    is null and
    isnull(dr.vl_saldo_documento,0)>0
  group by 
    p.cd_portador
  order by
    p.cd_portador

--    ((dr.cd_portador = @cd_portador) or (@cd_portador=0)) and

