

/****** Object:  Stored Procedure dbo.pr_doc_rec_cobranca_fone    Script Date: 13/12/2002 15:08:26 ******/

CREATE PROCEDURE pr_doc_rec_cobranca_fone
@ic_parametro integer,
@dt_inicial datetime,
@dt_final datetime,
@cd_cliente integer,
@cd_documento_receber integer

AS

-------------------------------------------------------------------------------
if @ic_parametro = 1 -- consulta as duplicatas no período
-------------------------------------------------------------------------------
begin

  select 
    Distinct
    d.cd_identificacao,
    d.dt_emissao_documento,
    d.dt_vencimento_documento,
    d.vl_documento_receber,
    c.cd_cliente,
    c.nm_fantasia_cliente,
    d.cd_pedido_venda,
    cast((D.DT_VENCIMENTO_DOCUMENTO - GETDATE()) as int) as cd_tot_dia

  from
    Documento_Receber d,
    Cliente c
  where
    d.cd_cliente = c.cd_cliente                                   and
    d.dt_emissao_documento between @dt_inicial and @dt_final      and
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) > 0
  order by
    cd_tot_dia,
    d.dt_emissao_documento

end
  
else

-------------------------------------------------------------------------------
if @ic_parametro = 2 -- consulta as duplicatas no período por cliente
-------------------------------------------------------------------------------
begin

  select 
    Distinct
    d.cd_identificacao as 'Dup',
    d.dt_emissao_documento as 'Emissao',
    d.dt_vencimento_documento as 'Vencimento',
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) as 'Saldo',
    po.sg_portador as 'Port',
    p.dt_pagamento_documento as 'Pagto',
    d.cd_pedido_venda as 'Pedido',
    cast((D.DT_VENCIMENTO_DOCUMENTO - GETDATE()) as int) as 'Dias',
    d.cd_vendedor,
--    pv.cd_vendedor_interno as 'CodVI',
--  pv.cd_vendedor_pedido as 'CodVe',
    (select top 1 v.sg_vendedor from Vendedor, Pedido_Venda pv where v.cd_vendedor = pv.cd_vendedor_interno) as 'VI',
    (select top 1 v.sg_vendedor from Vendedor, Pedido_Venda pv where v.cd_vendedor = pv.cd_vendedor_pedido) as 'VE',    
    /*Case v.cd_tipo_vendedor
      When 1 then ISNULL(v.cd_vendedor,0)
    end as 'V.I.',
    Case v.cd_tipo_vendedor
      When 2 then ISNULL(v.cd_vendedor,0)
      When 3 then ISNULL(v.cd_vendedor,0)
    end as 'V.E.',*/
    v.nm_fantasia_vendedor as 'Vendedor',
    Case n.dt_saida_nota_saida
      When isnull(n.dt_saida_nota_saida,0) then 'N'
      Else 'S'
    end as 'Saiu',
   Case  -- Marca documento
      When d.dt_vencimento_documento > d.dt_emissao_documento + 10 then 'S'
      Else 'N'
    end as 'Marcado'
        

  from
    Documento_Receber d
  left outer Join
    Pedido_Venda pv
  on
    d.cd_cliente = pv.cd_cliente
  left outer Join
    Portador po
  on
    d.cd_portador = po.cd_portador
  left outer join
    Nota_Saida_Item ni
  on
    ni.cd_pedido_venda = d.cd_pedido_venda
  left outer join
    Nota_Saida n
  on
    n.cd_nota_saida = ni.cd_nota_saida
  left outer join
    Vendedor v
  on
    d.cd_vendedor = v.cd_vendedor                                 
  left outer join
    Documento_Receber_Pagamento p
  on
    d.cd_documento_receber = p.cd_documento_receber
  
  where
    d.cd_cliente = @cd_cliente                                    and
    cast(str(d.vl_saldo_documento,25,2) as decimal(25,2)) > 0
  order by
    Dias,
    Emissao

end

else
------------------------------------------------------------------------------
if @ic_parametro = 3 -- informação sobre a entrega do produto
------------------------------------------------------------------------------
begin

  select
      e.cd_entregador,
      e.nm_entregador,
      n.dt_saida_nota_saida       as 'Saida',
      n.ic_entrega_nota_saida     as 'Entregue',
       n.nm_obs_entrega_nota_saida
				   as 'Observacao'
    from
      Nota_Saida n
        Inner Join
      Entregador e
        on n.cd_entregador = e.cd_entregador
    where
      n.cd_pedido_venda = @cd_documento_receber
    order by
      n.dt_saida_nota_saida


end;
--  return




