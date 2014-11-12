


CREATE PROCEDURE pr_consulta_pedidos_aguardando
-------------------------------------------------------------------------------
--pr_consulta_pedidos_aguardando
-------------------------------------------------------------------------------
--GBS - Global Business Sollution Ltda                                     2004
-------------------------------------------------------------------------------
--Stored Procedure          : Microsoft SQL Server 2000
--Autor(es)                 : Daniel Carrasco Neto
--Banco de Dados            : SAPSQL
--Objetivo                  : Consulta Pedidos Aguardando
--Data                      : 14/03/2002
--Atualizado                : 26/08/2003 - Adição de Filtro por Categoria de Produto (DUELA)
--                          : 14/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                            11/11/2005 - Inclusão do campo cd_categoria_produto - ELIAS
--------------------------------------------------------------------------------------------

@dt_inicial           datetime,
@dt_final             datetime,
@cd_categoria_produto int

AS


  select 
    t.sg_tipo_pedido,
    t.nm_tipo_pedido,
    p.cd_status_pedido,
    st.sg_status_pedido,
    p.cd_pedido_venda,
    p.dt_pedido_venda,
    i.nm_fantasia_produto as 'nm_produto',
    c.cd_cliente,
    c.nm_fantasia_cliente,
    c.nm_razao_social_cliente,
    c.cd_cnpj_cliente,
    c.cd_cep,
    LTRIM(RTRIM(c.nm_endereco_cliente)) + ', ' + 
    LTrim(RTrim(c.cd_numero_endereco)) + '- '+ 
    LTrim(RTrim(c.nm_bairro)) + '- '+ 
    LTrim(RTrim(cid.nm_cidade))+'- '+ 
    uf.sg_estado as 'nm_endereco_cliente',
    c.cd_ddd + c.cd_telefone as 'cd_telefone',    
    i.cd_item_pedido_venda,
    i.qt_item_pedido_venda,
    i.dt_entrega_vendas_pedido,
    i.dt_entrega_fabrica_pedido,  
    i.vl_unitario_item_pedido,
    p.dt_cancelamento_pedido,
    p.ds_cancelamento_pedido,
    case when(i.dt_cancelamento_item is null) then  (i.qt_item_pedido_venda * vl_unitario_item_pedido) else 0 end as 'vl_item_total',
    case when (i.dt_cancelamento_item is not null) then  (i.qt_item_pedido_venda * vl_unitario_item_pedido) else 0 end as 'vl_totalcanc',
    tr.sg_tipo_restricao,
    tr.nm_tipo_restricao_pedido,
    p.cd_vendedor,
    (Select top 1 nm_fantasia_vendedor From Vendedor Where cd_vendedor = p.cd_vendedor) as 'nm_vendedor_externo',
    p.cd_vendedor_interno,
    (Select top 1 nm_fantasia_vendedor From Vendedor Where cd_vendedor = p.cd_vendedor_interno) as 'nm_vendedor_interno',
    (Select top 1 nm_fantasia_contato From Cliente_Contato where cd_cliente = p.cd_cliente and cd_contato = p.cd_contato) as 'nm_contato',
    pd.cd_categoria_produto
  from Pedido_Venda p 
    left Outer Join Pedido_Venda_Item i on p.cd_pedido_venda = i.cd_pedido_venda 
    left outer Join Produto pd on pd.cd_produto=i.cd_produto
    left outer join Tipo_Pedido t on p.cd_tipo_pedido = t.cd_tipo_pedido 
    Left outer join Status_Pedido st on p.cd_status_pedido = st.cd_status_pedido 
    Left Outer Join Cliente c on p.cd_cliente = c.cd_cliente 
    Left outer join Tipo_Restricao_Pedido tr on p.cd_tipo_restricao_pedido = tr.cd_tipo_restricao_pedido 
    Left Outer Join CEP ce on c.cd_identifica_cep = ce.cd_identifica_cep 
    inner join Cidade cid on ce.cd_cidade = cid.cd_cidade 
    inner join Estado uf on ce.cd_estado = uf.cd_estado
  where
    ISNULL(p.cd_tipo_restricao_pedido,0) > 0 and
    p.dt_pedido_venda between @dt_inicial and @dt_final and
    (pd.cd_categoria_produto=@cd_categoria_produto or @cd_categoria_produto=0)
  order by 
    p.dt_pedido_venda desc, p.cd_pedido_venda desc, i.cd_item_pedido_venda
  Desc


