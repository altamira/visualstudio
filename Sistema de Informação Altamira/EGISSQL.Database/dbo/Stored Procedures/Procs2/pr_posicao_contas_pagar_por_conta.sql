
create procedure pr_posicao_contas_pagar_por_conta
@cd_conta int,
@dt_inicial  datetime,
@dt_final    datetime
as

  select
    c.cd_tipo_conta_pagar,
    isnull( max(c.nm_tipo_conta_pagar),'Conta não Cadastrada') as 'Conta',

    --Vencidas

    sum( case when ((dr.dt_vencimento_documento < @dt_inicial) and (vl_saldo_documento_pagar>0 )) then
    dr.vl_saldo_documento_pagar else 0 end ) as 'Vencidas',

    sum( case when ((dr.dt_vencimento_documento between @dt_inicial and @dt_final) ) then
    dr.vl_saldo_documento_pagar else 0 end ) as 'Mes',

    sum( case when ((dr.dt_vencimento_documento between @dt_final+1 and @dt_final+30) ) then
    dr.vl_saldo_documento_pagar else 0 end ) as '30 dias',

    sum( case when ((dr.dt_vencimento_documento between @dt_final+31 and  @dt_final+60) ) then
    dr.vl_saldo_documento_pagar else 0 end ) as '60 dias',

    sum( case when ((dr.dt_vencimento_documento between @dt_final+61 and @dt_final+90) ) then
    dr.vl_saldo_documento_pagar else 0 end ) as '90 dias',

    sum( case when ((dr.dt_vencimento_documento >= @dt_final+91 ) ) then
    dr.vl_saldo_documento_pagar else 0 end ) as '120 dias',
      
    sum ( dr.vl_saldo_documento_pagar )      as 'TotalGeral' 
  from
    Documento_Pagar dr
    left outer join Tipo_Conta_Pagar c on c.cd_tipo_conta_pagar = dr.cd_tipo_conta_pagar
  where
    IsNull(dr.cd_tipo_conta_pagar,0) = ( case when @cd_conta = 0 then
                                            IsNull(dr.cd_tipo_conta_pagar,0)
                                          else @cd_conta end ) and
    dr.dt_cancelamento_documento is null and
    dr.dt_devolucao_documento    is null
  group by 
    c.cd_tipo_conta_pagar
  order by
    c.cd_tipo_conta_pagar

