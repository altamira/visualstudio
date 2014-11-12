
create procedure pr_posicao_contas_pagar_por_conta_anual
@cd_conta    int = 0,
@dt_inicial  datetime,
@dt_final    datetime
as

  select
    c.cd_tipo_conta_pagar,
    isnull( max(c.nm_tipo_conta_pagar),'Não Cadastrada') as 'Conta',

    --Vencidas

    ( select 
        sum (isnull(x.vl_saldo_documento_pagar,0) ) 
      from 
        documento_pagar x
      where 
        x.dt_vencimento_documento < @dt_inicial  and x.vl_saldo_documento_pagar>0 and
        x.cd_tipo_conta_pagar = c.cd_tipo_conta_pagar )   as 'Vencidas',

    sum( case when month(dr.dt_vencimento_documento) = 1   then isnull(dr.vl_saldo_documento_pagar,0) else 0 end ) as 'Jan',
    sum( case when month(dr.dt_vencimento_documento) = 2   then isnull(dr.vl_saldo_documento_pagar,0) else 0 end ) as 'Fev',
    sum( case when month(dr.dt_vencimento_documento) = 3   then isnull(dr.vl_saldo_documento_pagar,0) else 0 end ) as 'Mar',
    sum( case when month(dr.dt_vencimento_documento) = 4   then isnull(dr.vl_saldo_documento_pagar,0) else 0 end ) as 'Abr',
    sum( case when month(dr.dt_vencimento_documento) = 5   then isnull(dr.vl_saldo_documento_pagar,0) else 0 end ) as 'Mai',
    sum( case when month(dr.dt_vencimento_documento) = 6   then isnull(dr.vl_saldo_documento_pagar,0) else 0 end ) as 'Jun',
    sum( case when month(dr.dt_vencimento_documento) = 7   then isnull(dr.vl_saldo_documento_pagar,0) else 0 end ) as 'Jul',
    sum( case when month(dr.dt_vencimento_documento) = 8   then isnull(dr.vl_saldo_documento_pagar,0) else 0 end ) as 'Ago',
    sum( case when month(dr.dt_vencimento_documento) = 9   then isnull(dr.vl_saldo_documento_pagar,0) else 0 end ) as 'Set',
    sum( case when month(dr.dt_vencimento_documento) = 10  then isnull(dr.vl_saldo_documento_pagar,0) else 0 end ) as 'Out',
    sum( case when month(dr.dt_vencimento_documento) = 11  then isnull(dr.vl_saldo_documento_pagar,0) else 0 end ) as 'Nov',
    sum( case when month(dr.dt_vencimento_documento) = 12  then isnull(dr.vl_saldo_documento_pagar,0) else 0 end ) as 'Dez',
      
    sum ( dr.vl_saldo_documento_pagar )      as 'TotalGeral' 
  from
    Documento_Pagar dr
    left outer join Tipo_Conta_Pagar c on c.cd_tipo_conta_pagar = dr.cd_tipo_conta_pagar
  where
    IsNull(dr.cd_tipo_conta_pagar,0) = ( case when @cd_conta = 0 then
                                            IsNull(dr.cd_tipo_conta_pagar,0)
                                          else @cd_conta end )   and
    dr.dt_vencimento_documento between @dt_inicial and @dt_final and
    dr.dt_cancelamento_documento is null and
    dr.dt_devolucao_documento    is null
  group by 
    c.cd_tipo_conta_pagar
  order by
    c.cd_tipo_conta_pagar

