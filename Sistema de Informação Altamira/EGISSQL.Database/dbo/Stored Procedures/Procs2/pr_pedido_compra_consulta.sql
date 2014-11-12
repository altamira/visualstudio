
CREATE PROCEDURE pr_pedido_compra_consulta
--pr_pedido_venda_consulta
---------------------------------------------------
-- GBS - Global Business Solution	       2002
-- Stored Procedure: Microsoft SQL Server       2000
-- Autor(es): Igor Gama
-- Banco de Dados: EgisSql
-- Objetivo: Realizar uma consulta de Pedido_Compra
-- Data: 31/05/2002
-- Alterado: - Tirado filtro de Período. - Daniel C Neto - 25/07/2002
--             Colocado dt_item_nec_ped_compra , cd_cotacao, cd_item_cotacao - Daniel C. Neto - 14/08/2002
--             Incluído máscara do grupo de produto - Daniel C. Neto - 25/08/2002
--             Usado Função de Formatação de Máscara - Daniel C. Neto - 27/08/2003
--             Incluído relação com tabela de servico - Daniel C. Neto - 05/09/2003
--             16.09.2003 - Adicionado campos referentes a Matéria Prima, caso o produto tiver o mesmo. - Daniel Duela
--             01.10.2003 - Adicionado campos 'Total_Compra_Item' - Daniel Duela
--             27/10/2003 - Incluído campos de Requisicao de Compra - Daniel C. Neto.
--             13.11.2003 - Incluido o Campo ic_atraso - Rafael M. Santiago
--	       19.11.2003 - Incluido o campo dt_entrega_item_ped_compr - RAFAEL M. SANTIAGO
--             24/11/2003 - Incluído qt_dias de entrega - Daniel C. Neto.
--             05/12/2003 - Incluído colunas referentes a matéria-prima - Daniel C. Neto.
--             05/12/2003 - Refeito cálculo de atraso - Daniel C. Neto.
--             08/12/2003 - Acerto - Daniel C. Neto.
--	       12/01/2004 - Acerto - Daniel C. Neto.	
--             21/01/2004 - 1 as Sel - Daniel C. Neto.
--             30/01/2004 - Colocado top 1 nas subqueries - Daniel C. Neto.
--             13/02/2004 - Valor total do pedido deve aparecer com IPI somado - Daniel C. Neto. 
--             18/02/2004 - Adicionado campo de saldo original - Daniel C. Neto.
--             10/03/2004 - Arrancado campo de qt_bruto_pedido - Daniel C. Neto.
--             06/05/2004 - Incluído 2 novos campos - Daniel C. Neto.
--             25/05/2004 - Incluído campos referentes ao Saldo do Produto. - Daniel C. Neto.
--             30.05.2006 - Atualização do procedimento visando performance e filtragem opcional - Fabio Cesar
---------------------------------------------------
@cd_pedido_compra as int,
@ic_excluir_saldo_zerado char(1) = 'N'
AS

  set nocount on

  declare @cd_fase_produto int
  declare @data_inicial datetime
  declare @data_final   datetime 
  declare @cd_ano int
  declare @cd_mes int

  Select top 1
    @cd_fase_produto = cd_fase_produto 
  from 
    Parametro_Suprimento 
  where 
    cd_empresa = dbo.fn_empresa() 

  -----------------------------------------------------
  -- Calcular as Datas
  -----------------------------------------------------
  SET DATEFORMAT ymd

  -- Decompor data final
  set @cd_ano = Year( Getdate() )
  set @cd_mes = Month( Getdate() )

  -- Data Final do Período
  set @data_final = dateadd( dd , -1, Cast(Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime) )

--   print 'Dt. Final'
--   print @data_final

  -- Definir a data Inicial para o cálculo Trimestral
  set @data_inicial = dateadd( mm , -2, @data_final )
  set @cd_mes = Month( @data_inicial ) 
  set @cd_ano = Year( @data_inicial ) 
  set @data_inicial = Cast(Str(@cd_ano)+'-'+Str(@cd_mes)+'-01' as DateTime)

--   print 'Dt. Inicial Calc. Trim.'
--   print @data_inicial


  SELECT
    1 as Sel,
    um.cd_unidade_medida,
    um.sg_unidade_medida, 
    pci.cd_pedido_compra,
    pc.dt_pedido_compra,
    pc.cd_comprador,
    (Select top 1 nm_comprador From Comprador Where cd_comprador = pc.cd_comprador) as 'nm_comprador',
    IsNull(pci.dt_item_canc_ped_compra, pc.dt_cancel_ped_compra) as dt_cancel_ped_compra,
    pc.ds_cancel_ped_compra,
    pc.vl_total_pedido_ipi as vl_total_pedido_compra, 
    pci.cd_cotacao,
    pci.cd_item_cotacao,
    pci.dt_item_nec_ped_compra,
    pci.qt_item_pesliq_ped_compra, 
    pci.qt_item_pesbr_ped_compra, 
    pci.cd_item_pedido_compra, 
    pci.dt_item_pedido_compra, 
    pci.qt_item_pedido_compra, 
    pci.qt_saldo_item_ped_compra, 
    pci.qt_saldo_item_ped_compra as 'qt_saldo_original', 
    pci.vl_item_unitario_ped_comp, 
    (pci.vl_total_item_pedido_comp) as 'Total_Compra_Item', 
    pci.dt_entrega_item_ped_compr,
    pc.dt_alteracao_ped_compra,
    pc.ds_alteracao_ped_compra,
    f.cd_fornecedor,
    f.nm_fantasia_fornecedor,		
    f.nm_razao_social,
    t.cd_transportadora,
    t.nm_transportadora,
    t.nm_fantasia,
    pc.cd_tipo_pedido, 
    (Select top 1 nm_tipo_pedido From Tipo_pedido Where cd_tipo_pedido = pc.cd_tipo_pedido) as 'nm_tipo_pedido',
    pc.cd_contato_fornecedor, 
    (Select top 1 nm_fantasia_contato_forne From Fornecedor_Contato Where cd_contato_fornecedor = pc.cd_contato_fornecedor and cd_fornecedor = pc.cd_fornecedor) as 'nm_fantasia_contato',
    dbo.fn_mascara_produto(pci.cd_produto) as cd_mascara_produto,
    pci.cd_produto,
    IsNull(pci.nm_fantasia_produto, s.nm_servico) as nm_fantasia_produto,
    CASE IsNull(prod.ic_especial_produto,'N')
      when 'S' then
        ltrim(IsNull(cast(pci.ds_item_pedido_compra as varchar(40)), IsNull(pci.nm_produto, s.nm_servico)))
      ELSE 
        IsNull(IsNull(pci.nm_produto, s.nm_servico),cast(pci.ds_item_pedido_compra as varchar(40))) 
    end as nm_produto,
    (case 
        when (IsNull(pci.cd_materia_prima,0) > 0 ) or
             (IsNull(ProdCusto.cd_mat_prima,0) > 0) then
              mp.nm_mat_prima
        else
              null 
     end ) as 'Materia_Prima',
    pci.nm_medbruta_mat_prima,
    pci.nm_medacab_mat_prima,
    cop.nm_condicao_pagamento,
    cop.sg_condicao_pagamento,
    cop.qt_parcela_condicao_pgto,
    ne.cd_nota_entrada,
    ne.dt_nota_entrada,
    (nei.vl_item_nota_entrada * nei.qt_item_nota_entrada) as 'qt_Qtdade',
    nei.cd_item_nota_entrada,
    nei.qt_item_nota_entrada,
    sp.cd_status_pedido,
    sp.nm_status_pedido,
    Cast(pci.ds_observacao_fabrica as varchar(255)) as ds_observacao_fabrica,
    Cast(pc.ds_pedido_compra as varchar(255)) as ds_pedido_compra,
    gp.cd_mascara_grupo_produto,
    pci.cd_requisicao_compra,
    pci.cd_requisicao_compra_item,
    case when cast(( convert(datetime,convert( varchar(10),getdate(),101),101) - pci.dt_entrega_item_ped_compr ) as int) > 0 and
	    pci.qt_saldo_item_ped_compra > 0 then 'S' else 'N' end as ic_atraso,
    pci.qt_dia_entrega_item_ped, 
    IsNull(tp.ic_pedido_mat_prima, 'N') as ic_pedido_mat_prima,
    case IsNull(pci.cd_pedido_venda,0)
      when 0 then 
        ''
      else
        (Select 
           top 1 cli.nm_fantasia_cliente 
         from 
           (Select top 1 cd_cliente from pedido_venda with (nolock) 
            where cd_pedido_venda = pci.cd_pedido_venda ) pv
           inner join cliente cli with (nolock) 
             on pv.cd_cliente = cli.cd_cliente)
    end as nm_fantasia_cliente,
    pci.cd_pedido_venda,
    pci.cd_item_pedido_venda,
    gp.ic_especial_grupo_produto,
     dbo.fn_consumo_medio
       ( @cd_fase_produto, pci.cd_produto, @data_inicial, @data_final) as total,
     ps.qt_consig_produto         as Saldo_Estoque_Consignacao,
    isnull(ps.qt_saldo_atual_produto,0.00)                    as 'Atual',
    isnull(ps.qt_saldo_reserva_produto,0.00)                  as 'Reserva',
    isnull(ps.qt_pd_compra_produto,0.00)                      as 'Compra',
    isnull(ps.qt_req_compra_produto,0.00)                     as 'Requisicao',
    isnull(ps.qt_consumo_produto,0.00)                        as 'Consumo',
    isnull(ps.qt_minimo_produto,0.00)                         as 'Minimo',
    isnull(((ps.qt_saldo_reserva_produto/
      Cast(ps.qt_consumo_produto as int))*30),0.00)  as 'Duracao',
    cast(pci.ds_item_pedido_compra as varchar(2000)) as ds_item_pedido_compra

  FROM
    Pedido_Compra pc with (nolock, index(pk_pedido_compra)) 
    inner join Pedido_Compra_Item pci with (nolock, index(PK_Pedido_Compra_Item)) 
      on pci.cd_pedido_compra = pc.cd_pedido_compra 
    left outer join Status_Pedido sp 
      on sp.cd_status_pedido = pc.cd_status_pedido 
    inner join Fornecedor f with (nolock, index(PK_Fornecedor)) 
      on f.cd_fornecedor = pc.cd_fornecedor 
    left outer join Produto prod with (nolock, index(PK_Produto)) 
      on prod.cd_produto = pci.cd_produto 
    left outer join Produto_Custo ProdCusto with (nolock, index(PK_Produto_Custo)) 
      on ProdCusto.cd_produto = pci.cd_produto
    left outer join Materia_Prima mp 
      on mp.cd_mat_prima = (case IsNull(pci.cd_materia_prima,0)
                              when 0 then ProdCusto.cd_mat_prima
                              else pci.cd_materia_prima end)
    left outer join Transportadora t with (nolock, index(pk_transportadora))
      on t.cd_transportadora = pc.cd_transportadora 
    left outer join Condicao_Pagamento cop with (nolock, index(pk_condicao_pagamento))
      on cop.cd_condicao_pagamento = pc.cd_condicao_pagamento 
    left outer join Nota_Entrada_Item nei with (nolock, index(IX_Nota_Entrada_Item_Pedido))
      on nei.cd_pedido_compra = pci.cd_pedido_compra and
         nei.cd_item_pedido_compra = pci.cd_item_pedido_compra
    left outer join Nota_Entrada ne with (nolock, index(PK_Nota_Entrada))
      on ne.cd_fornecedor = nei.cd_fornecedor and
         ne.cd_nota_entrada = nei.cd_nota_entrada and
         ne.cd_operacao_fiscal = nei.cd_operacao_fiscal and
         ne.cd_serie_nota_fiscal = nei.cd_serie_nota_fiscal
    left outer join Grupo_Produto gp with (nolock, index(pk_grupo_produto))
      on gp.cd_grupo_produto = prod.cd_grupo_produto 
    left outer join Servico s 
      on s.cd_servico = pci.cd_servico 
    left outer join Unidade_Medida um 
      on um.cd_unidade_medida = pci.cd_unidade_medida    
    left outer join Tipo_Pedido tp 
      on tp.cd_tipo_pedido = pc.cd_tipo_pedido 
    left outer join Produto_Saldo ps with (nolock, index(PK_Produto_Saldo)) 
      on ps.cd_produto = pci.cd_produto and
         ps.cd_fase_produto = @cd_fase_produto
  WHERE     
    pc.cd_pedido_compra = @cd_pedido_compra
    and IsNull(pci.qt_saldo_item_ped_compra,0) > (case IsNull(@ic_excluir_saldo_zerado,'S')
                                                    when 'S' then 0
                                                    else IsNull(pci.qt_saldo_item_ped_compra,0) - 1
                                                  end)

  ORDER BY
    pc.cd_pedido_compra, 
    pci.cd_item_pedido_compra


  set nocount off
