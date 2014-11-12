
create procedure pr_posicao_contas_receber_portador_anual
@cd_portador int = 0,
@dt_inicial  datetime,
@dt_final    datetime
as

  select
    p.cd_portador,
    isnull(max(p.nm_portador),'Não Cadastrado') as 'Portador',
    --Vencidas
     (select sum(isnull(x.vl_saldo_documento,0)) 
      from documento_receber x
      where x.dt_vencimento_documento < @dt_inicial and x.vl_saldo_documento>0 and
            x.cd_portador = p.cd_portador)  as 'Vencidas',

    sum( case when month(dr.dt_vencimento_documento)=1  then isnull(dr.vl_saldo_documento,0) else 0.00 end ) as 'Jan',
    sum( case when month(dr.dt_vencimento_documento)=2  then isnull(dr.vl_saldo_documento,0) else 0.00 end ) as 'Fev',
    sum( case when month(dr.dt_vencimento_documento)=3  then isnull(dr.vl_saldo_documento,0) else 0.00 end ) as 'Mar',
    sum( case when month(dr.dt_vencimento_documento)=4  then isnull(dr.vl_saldo_documento,0) else 0.00 end ) as 'Abr',
    sum( case when month(dr.dt_vencimento_documento)=5  then isnull(dr.vl_saldo_documento,0) else 0.00 end ) as 'Mai',
    sum( case when month(dr.dt_vencimento_documento)=6  then isnull(dr.vl_saldo_documento,0) else 0.00 end ) as 'Jun',
    sum( case when month(dr.dt_vencimento_documento)=7  then isnull(dr.vl_saldo_documento,0) else 0.00 end ) as 'Jul',
    sum( case when month(dr.dt_vencimento_documento)=8  then isnull(dr.vl_saldo_documento,0) else 0.00 end ) as 'Ago',
    sum( case when month(dr.dt_vencimento_documento)=9  then isnull(dr.vl_saldo_documento,0) else 0.00 end ) as 'Set',
    sum( case when month(dr.dt_vencimento_documento)=10 then isnull(dr.vl_saldo_documento,0) else 0.00 end ) as 'Out',
    sum( case when month(dr.dt_vencimento_documento)=11 then isnull(dr.vl_saldo_documento,0) else 0.00 end ) as 'Nov',
    sum( case when month(dr.dt_vencimento_documento)=12 then isnull(dr.vl_saldo_documento,0) else 0.00 end ) as 'Dez',
    sum ( isnull(dr.vl_saldo_documento,0) )      as 'TotalGeral' 
  from
    Documento_receber dr
    left outer join Portador p on p.cd_portador = dr.cd_portador
  where
    dr.cd_portador = case when @cd_portador = 0 then dr.cd_portador else @cd_portador end and
    dr.dt_vencimento_documento between @dt_inicial and @dt_final                          and
    --dr.cd_portador = p.cd_portador  and
    dr.dt_cancelamento_documento is null and
    dr.dt_devolucao_documento    is null
  group by 
    p.cd_portador
  order by
    p.cd_portador

--    ((dr.cd_portador = @cd_portador) or (@cd_portador=0)) and

