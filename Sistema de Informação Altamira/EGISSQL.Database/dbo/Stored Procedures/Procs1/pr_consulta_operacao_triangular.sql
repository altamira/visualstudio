CREATE    PROCEDURE pr_consulta_operacao_triangular
---------------------------------------------------
--GBS - Global Business Sollution              2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Daniel C. Neto
--Banco de Dados: SAPSQL
--Objetivo: Listar Operações Triangulares. 
--Data: 19/03/2002
--Atualizado: 
-- Observaçao: - Foi constatado que há códigos de
-- clientes cadastrado na tabela cliente endereço
-- o qual não há correspondente desse código com 
-- tabela Cliente
-- Migrar Tabela Cliente_Endereco
---------------------------------------------------
@ic_parametro int,
@cd_pedido int,
@dt_inicial datetime,
@dt_final datetime

AS
--------------------------------------------------------------------------------------------
   If @ic_parametro = 1 -- Realiza a Consulta das Operações Triangulares
--------------------------------------------------------------------------------------------  
  Begin
    select
      t.sg_tipo_pedido,
      p.cd_pedido_venda,
      p.dt_pedido_venda,
      p.cd_cliente,
      (Select nm_fantasia_cliente From Cliente Where cd_cliente = p.cd_cliente) as 'nm_cliente_pedido',
      (Select nm_fantasia_cliente From Cliente Where cd_cliente = p.cd_cliente_entrega) as 'nm_cliente_entrega',
      p.cd_vendedor as 'cd_vendedor_pedido',
      (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = p.cd_vendedor) as 'nm_vendedor_externo',
      p.cd_vendedor_interno,
      (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = p.cd_vendedor_interno) as 'nm_vendedor_interno',
      te.nm_tipo_local_entrega as 'nm_tipo_endereco',
      st.sg_status_pedido,
      p.vl_total_pedido_venda
    from
      Pedido_Venda p Left Outer Join
      Tipo_Pedido t
        on p.cd_tipo_pedido = t.cd_tipo_pedido Left Outer Join
      Cliente c
        on p.cd_cliente = c.cd_cliente Left Outer Join
      Tipo_Local_Entrega te
        on p.cd_tipo_local_entrega = te.cd_tipo_local_entrega Left Outer Join
      Status_Pedido st
        on p.cd_status_pedido = st.cd_status_pedido
    where
      p.ic_operacao_triangular = 'S' and
      p.dt_cancelamento_pedido is null and
      p.dt_pedido_venda between @dt_inicial and @dt_final
    order by
      p.dt_pedido_venda desc, p.cd_pedido_venda desc

  end
--------------------------------------------------------------------------------------------
else If @ic_parametro = 2 -- Faz a seleção do Cliente para Relatórios.
--------------------------------------------------------------------------------------------  
  begin
    select
      p.cd_pedido_venda,
      p.dt_pedido_venda,
      Cast((i.qt_item_pedido_venda * i.vl_unitario_item_pedido) as numeric(25,2)) as 'vl_total',
      i.cd_item_pedido_venda,
      Cast(i.vl_unitario_item_pedido as numeric(25,2)) as 'vl_unitario_item_pedido',
      i.qt_item_pedido_venda,
      i.qt_liquido_item_pedido,
      i.qt_bruto_item_pedido,
      pd.cd_produto,
      i.nm_produto_pedido as 'nm_produto',
      i.nm_fantasia_produto,
      t.cd_transportadora,
      t.nm_transportadora,
      t.nm_fantasia,
      cp.cd_condicao_pagamento,
      cp.nm_condicao_pagamento,
      cp.qt_parcela_condicao_pgto,
      (Select nm_fantasia_vendedor From Vendedor Where cd_vendedor = p.cd_vendedor) as 'nm_fantasia_vendedor',
      p.cd_cliente,
      c.nm_fantasia_cliente,
      c.nm_razao_social_cliente,
      c.cd_cnpj_cliente,
      c.cd_cep,
      RTrim(LTrim(IsNull(c.cd_ddd,'') + IsNull(c.cd_telefone,''))) as 'cd_telefone',
      nm_endereco_cliente =
      LTRIM(RTRIM(IsNull(c.nm_endereco_cliente,''))) + ', ' + 
      LTrim(RTrim(IsNull(c.cd_numero_endereco,''))) + '- '+ 
      LTrim(RTrim(IsNull(c.nm_bairro,''))) + '- '+ 
      LTrim(RTrim(IsNull((Select nm_cidade From Cidade Where cd_cidade = c.cd_cidade),'')))+'- '+ 
      LTrim(RTrim(IsNull((Select nm_estado From Estado Where cd_estado = c.cd_estado),''))),
      p.cd_cliente_entrega,
      (Select nm_fantasia_cliente From Cliente Where cd_cliente = p.cd_cliente_entrega) as 'nm_cliente_entrega',
      (Select nm_razao_social_cliente From Cliente Where cd_cliente = p.cd_cliente_entrega) as 'nm_razao_social_cliente_entrega',
      ce.nm_endereco_cliente as 'nm_endereco_cliente_entrega',
      ce.cd_numero_endereco as 'cd_numero_endereco_entrega',
      ce.nm_bairro_cliente as 'nm_bairro_cliente_entrega',
      ce.cd_cnpj_cliente as 'cd_cnpj_cliente_entrega',
      ce.cd_cep_cliente as 'cd_cep_cliente_entrega',
      (Select c.cd_ddd + c.cd_telefone From Cliente Where cd_cliente = p.cd_cliente_entrega) as 'cd_telefone_entrega',
      cid.nm_cidade + '-' + est.sg_estado as 'nm_cidade_estado_entrega'
    from
      Pedido_Venda p Left Outer Join
      Pedido_Venda_Item i 
        on p.cd_pedido_venda = i.cd_pedido_venda Left Outer Join
      Tipo_Local_Entrega te 
        on p.cd_tipo_local_entrega = te.cd_tipo_local_entrega Left Outer Join
      Produto pd 
        on i.cd_produto = pd.cd_produto Left Outer Join
      Condicao_Pagamento cp 
        on p.cd_condicao_pagamento = cp.cd_condicao_pagamento Left Outer Join
      Cliente c
        on p.cd_cliente = c.cd_cliente Left Outer Join
      Cliente_Endereco ce
       on p.cd_cliente_entrega = ce.cd_cliente and
          ce.cd_tipo_endereco = 3 left outer join -- somente endereços para entrega
      Transportadora t
        on p.cd_transportadora = t.cd_transportadora Left Outer Join
      Estado est
        on ce.cd_estado = est.cd_estado left outer join
      Cidade cid  
        on ce.cd_cidade = cid.cd_cidade
    where
      p.ic_operacao_triangular = 'S' and
      p.dt_cancelamento_pedido is null and
      p.dt_pedido_venda between @dt_inicial and @dt_final

    order by
      p.dt_pedido_venda desc, p.cd_pedido_venda desc, i.cd_item_pedido_venda 
  
  end
--------------------------------------------------------------------------------------------
else If @ic_parametro = 3 -- Verifica dados do Local de Entrega
--------------------------------------------------------------------------------------------  
  begin
    select
      p.cd_pedido_venda,
      p.dt_pedido_venda,
      (Select nm_fantasia_cliente From Cliente Where cd_cliente = p.cd_cliente) as 'nm_cliente_pedido',
      (Select nm_fantasia_cliente From Cliente Where cd_cliente = p.cd_cliente_entrega) as 'nm_cliente_entrega',
      (Select nm_razao_social_cliente From Cliente Where cd_cliente = p.cd_cliente_entrega) as 'nm_razao_social_entrega',      (Select nm_razao_social_cliente From Cliente Where cd_cliente = p.cd_cliente) as 'nm_razao_social_pedido',
      ce.nm_endereco_cliente,
      ce.cd_numero_endereco,
      ce.nm_bairro_cliente,
      ce.cd_cnpj_cliente,
      ce.cd_cep_cliente,
      cid.nm_cidade + '-' + est.sg_estado as 'CidadeEstado'
    from
      Pedido_Venda p left outer join
      Tipo_Endereco te
        on p.cd_tipo_endereco = te.cd_tipo_endereco left outer join
      Cliente_Endereco ce
        on p.cd_cliente_entrega = ce.cd_cliente and
           ce.cd_tipo_endereco = 3 left outer join -- somente endereços para entrega
      Estado est
        on ce.cd_estado = est.cd_estado left outer join
      Cidade cid
        on ce.cd_cidade = cid.cd_cidade
    where
      p.cd_pedido_venda = @cd_pedido and
      p.ic_operacao_triangular = 'S' and
      p.dt_cancelamento_pedido is null and
      p.dt_pedido_venda between @dt_inicial and @dt_final
    order by
      p.dt_pedido_venda desc, p.cd_pedido_venda desc
  end


