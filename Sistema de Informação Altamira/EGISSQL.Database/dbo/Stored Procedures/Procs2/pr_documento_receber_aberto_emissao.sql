
CREATE PROCEDURE pr_documento_receber_aberto_emissao
@cd_portador int,
@dt_inicial datetime,
@dt_final datetime,
@ic_dias  char(1)

AS

if (isnull(@ic_dias, 'N') = 'N')
  begin
    if (isnull(@cd_portador, 0) = 0)
      select
        d.cd_portador             as 'CodPortador',   
        p.nm_portador             as 'Portador',
	d.cd_identificacao        as 'Duplicata',
        c.nm_fantasia_cliente     as 'Cliente',
        d.dt_emissao_documento    as 'Emissao',
        d.dt_vencimento_documento as 'Vencimento',
        d.vl_documento_receber    as 'Valor',
        cast(str(d.vl_saldo_documento,25,2) as decimal(25,2))      as 'Saldo',
        isnull((select sum(x.vl_abatimento_documento)
                from Documento_Receber_Pagamento x
                where x.cd_documento_receber = d.cd_documento_receber), 0) 
                as 'Abatimento',
        cast(d.dt_vencimento_documento - isnull(d.dt_emissao_documento, getDate()) as int) 
                as 'Dias',
        p.nm_portador as 'Portador'
      from
         Documento_Receber d 
      left outer join 
        Cliente c
      on
        d.cd_cliente = c.cd_cliente
      left outer join
        Portador p
      on
        d.cd_portador = p.cd_portador
      where
        d.dt_emissao_documento Between @dt_inicial and @dt_final and
        d.dt_cancelamento_documento is null --and
--        d.dt_devolucao_documento is null
      order by
        d.cd_identificacao,
        d.cd_portador,
        d.dt_vencimento_documento
--    d.cd_identificacao -- Lucio
    else
      select  
        d.cd_portador             as 'CodPortador',   
        p.nm_portador             as 'Portador',
        d.cd_identificacao        as 'Duplicata',
        c.nm_fantasia_cliente     as 'Cliente',
        d.dt_emissao_documento    as 'Emissao',
        d.dt_vencimento_documento as 'Vencimento',
        d.vl_documento_receber    as 'Valor',
        cast(str(d.vl_saldo_documento,25,2) as decimal(25,2))      as 'Saldo',
        isnull((select sum(x.vl_abatimento_documento)
               from Documento_Receber_Pagamento x
               where x.cd_documento_receber = d.cd_documento_receber), 0) 
                              as 'Abatimento',
        cast(d.dt_vencimento_documento - isnull(d.dt_emissao_documento, getDate()) as int) 
                              as 'Dias'
      from
        Documento_Receber d 
      left outer join 
        Cliente c
      on
        d.cd_cliente = c.cd_cliente
      left outer join
        Portador p
      on
        d.cd_portador = p.cd_portador
      where
        d.dt_emissao_documento Between @dt_inicial and @dt_final and
        d.dt_cancelamento_documento is null and
        d.cd_portador = @cd_portador --and
--        d.dt_devolucao_documento is null
      order by    
        d.cd_identificacao,
        d.dt_vencimento_documento
    end
else
  begin
    if (isnull(@cd_portador, 0) = 0)
      select
        d.cd_portador             as 'CodPortador',   
        p.nm_portador             as 'Portador',
	d.cd_identificacao        as 'Duplicata',
        c.nm_fantasia_cliente     as 'Cliente',
        d.dt_emissao_documento    as 'Emissao',
        d.dt_vencimento_documento as 'Vencimento',
        d.vl_documento_receber    as 'Valor',
        cast(str(d.vl_saldo_documento,25,2) as decimal(25,2))      as 'Saldo',
        isnull((select sum(x.vl_abatimento_documento)
                from Documento_Receber_Pagamento x
                where x.cd_documento_receber = d.cd_documento_receber), 0) 
                as 'Abatimento',
        cast(d.dt_vencimento_documento - isnull(d.dt_emissao_documento, getDate()) as int) 
                as 'Dias',
        p.nm_portador as 'Portador'
      from
         Documento_Receber d 
      left outer join 
        Cliente c
      on
        d.cd_cliente = c.cd_cliente
      left outer join
        Portador p
      on
        d.cd_portador = p.cd_portador
      where
        d.dt_emissao_documento Between @dt_inicial and @dt_final and
        d.dt_cancelamento_documento is null --and
--        d.dt_devolucao_documento is null
      order by
        dias,
        d.cd_identificacao,
        d.cd_portador,
        d.dt_vencimento_documento
--    d.cd_identificacao -- Lucio
    else
      select  
        d.cd_portador             as 'CodPortador',   
        p.nm_portador             as 'Portador',
        d.cd_identificacao        as 'Duplicata',
        c.nm_fantasia_cliente     as 'Cliente',
        d.dt_emissao_documento    as 'Emissao',
        d.dt_vencimento_documento as 'Vencimento',
        d.vl_documento_receber    as 'Valor',
        cast(str(d.vl_saldo_documento,25,2) as decimal(25,2))      as 'Saldo',
        isnull((select sum(x.vl_abatimento_documento)
               from Documento_Receber_Pagamento x
               where x.cd_documento_receber = d.cd_documento_receber), 0) 
                              as 'Abatimento',
        cast(d.dt_vencimento_documento - isnull(d.dt_emissao_documento, getDate()) as int) 
                              as 'Dias'
      from
        Documento_Receber d 
      left outer join 
        Cliente c
      on
        d.cd_cliente = c.cd_cliente
      left outer join
        Portador p
      on
        d.cd_portador = p.cd_portador
      where
        d.dt_emissao_documento Between @dt_inicial and @dt_final and
        d.dt_cancelamento_documento is null and
        d.cd_portador = @cd_portador --and
  --      d.dt_devolucao_documento is null
      order by    
        dias,
        d.cd_identificacao,
        d.dt_vencimento_documento
  end

