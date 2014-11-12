
CREATE VIEW vw_venda_bi
AS 

SELECT 
	pv.cd_pedido_venda, 
	isnull(pv.ic_amostra_pedido_venda, 'N') as ic_amostra_pedido_venda, 
	pv.dt_pedido_venda, 
	pvi.dt_item_pedido_venda,                    
	pv.cd_cliente, 
	pv.cd_condicao_pagamento, 
        pv.dt_credito_pedido_venda,
        case when isnull(co.cd_cliente_origem,0)>0 
        then
          cli.nm_fantasia_cliente
        else 
          c.nm_fantasia_cliente
        end                                     as 'nm_fantasia_cliente', 
	pv.cd_vendedor, 
	ve.nm_vendedor                          as 'nm_vendedor_externo', 
	pv.cd_vendedor_interno, 
	vi.nm_vendedor                          as 'nm_vendedor_interno', 
	pv.cd_usuario_atendente, 
	pvi.cd_item_pedido_venda, 
	isnull(pvi.cd_produto, 0)               as cd_produto, 
        p.cd_mascara_produto,
	pvi.nm_fantasia_produto, 
	pvi.nm_produto_pedido                   as nm_produto, 
        um.sg_unidade_medida,
	pvi.qt_item_pedido_venda, 
	pvi.qt_saldo_pedido_venda, 
	pvi.dt_entrega_vendas_pedido, 
	CASE WHEN (pvi.dt_cancelamento_item IS NULL) THEN (pvi.vl_unitario_item_pedido) ELSE 0 END AS vl_unitario_item_pedido, 
	pvi.vl_lista_item_pedido, 
	pvi.pc_ipi, 
	pvi.pc_icms, 
	CASE WHEN (pvi.dt_cancelamento_item IS NULL) THEN ((((pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda) * pvi.pc_ipi )/100 )) ELSE 0 END AS vl_ipi,
	pvi.pc_reducao_base_item, 
	pv.cd_destinacao_produto, 
	cp.cd_grupo_categoria, 
	gc.nm_grupo_categoria, 
	pvi.cd_categoria_produto, 
        cp.cd_mascara_categoria,
	cp.nm_categoria_produto, 
	c.cd_estado, 
	c.cd_pais, 
	c.cd_cidade, 
        c.cd_regiao,
 	( select top 1 cd_regiao_venda from Vendedor_Regiao where cd_vendedor = pv.cd_vendedor ) as cd_regiao_venda,
	--vr.cd_regiao_venda, 
	pvi.cd_servico, 
	pv.cd_loja, 
	isnull(c.cd_tipo_mercado, 0) AS cd_tipo_mercado, 
	CASE WHEN isnull(vl_custo_produto, 0) = 0 THEN isnull(vl_custo_contabil_produto, 0) 
	   ELSE isnull(vl_custo_produto, 0) END AS CustoProduto, 
	dbo.fn_custo_pedido_venda_especial(pv.cd_pedido_venda, pvi.cd_item_pedido_venda) AS CustoComposicao, 
	isnull(tm.nm_tipo_mercado, 'Sem Definição') AS nm_tipo_mercado,
	pvi.ic_pedido_venda_item,
        pv.cd_exportador,
        pv.dt_cancelamento_pedido,
        pvi.dt_cancelamento_item,
	CASE WHEN (pvi.dt_cancelamento_item IS NULL) THEN ((pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda)) ELSE 0 END AS vl_total_pedido_venda, 
        pv.cd_vendedor_pedido,
        pvi.vl_frete_item_pedido,
        dbo.fn_vl_liquido_venda('V',(pvi.vl_unitario_item_pedido * pvi.qt_item_pedido_venda), 
                                        pvi.pc_icms, pvi.pc_ipi, pv.cd_destinacao_produto, '') as 'ValorLiquido',
        (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido)
        + --Frete
        isnull(pv.vl_frete_pedido_venda,0)
        + --IPI
        (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido * (pvi.pc_ipi/100))
        - --Cancelamento
        case when (IsNull(pvi.dt_cancelamento_item,'') <> '') or (IsNull(pv.dt_cancelamento_pedido,'') <> '')
                 then (pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido)
                 else 0
            end                                                                               as 'ValorTotalIPI',

        cli.nm_fantasia_cliente          as ClientePedido,
        cli.nm_fantasia_cliente          as ClienteOrigem,
        0.00                             as vl_pis_item_pedido,
        0.00                             as vl_cofins_item_pedido,
        0.00                             as vl_icms_item_pedido,
        0.00                             as vl_ipi_item_pedido,
        isnull(c.cd_ramo_atividade,0)    as cd_ramo_atividade,
        isnull(ra.nm_ramo_atividade,'')  as nm_ramo_atividade,
        isnull(pa.nm_pais,'')            as nm_pais,
        isnull(e.nm_estado,'')           as nm_estado,
        isnull(cid.nm_cidade,'')         as nm_cidade,
        isnull(cr.cd_cliente_regiao,0)   as cd_cliente_regiao,
        isnull(cr.nm_cliente_regiao,'')  as nm_cliente_regiao,
        isnull(pvi.cd_consulta,0)        as cd_consulta,
        isnull(pvi.cd_item_consulta,0)   as cd_item_consulta,
        isnull(pvi.cd_tabela_preco,0)    as cd_tabela_preco,


        --Casos Especiais de Serviço = Produto 

        isnull(pvi.cd_produto_servico,0) as cd_produto_servico,
        fcp.ic_avista_forma_condicao,


        case when isnull(fcp.ic_avista_forma_condicao,'N')='N' then 
          pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido 
        else
          0.00
        end                                                            as Total_Prazo,


        case when isnull(fcp.ic_avista_forma_condicao,'N')='S' then 
           pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido 
        else
          0.00
        end                                                            as Total_Vista,

        case when isnull(mp.nm_marca_produto,'')<>'' then
           mp.nm_marca_produto
        else
           p.nm_marca_produto
        end                                                            as nm_marca_produto,

        isnull(p.qt_multiplo_embalagem,0)                              as qt_multiplo_embalagem,

-----------------------------------------------------------------------------------------------------------      
        --Somente para Clientes que operam com controle de Embalagem/Unidade
-----------------------------------------------------------------------------------------------------------      

        Unidade     =  case when pvi.cd_unidade_medida = 15 then pvi.qt_item_pedido_venda else 0 end,

        Embalagem   =  case when pvi.cd_unidade_medida = 2  then pvi.qt_item_pedido_venda else 0 end,

        --Valores------------------------------------------------------------------------------------------ 
 
        vl_unidade   =  case when pvi.cd_unidade_medida = 15 then pvi.qt_item_pedido_venda else 0 end
                        * pvi.vl_unitario_item_pedido,

        vl_embalagem =  case when pvi.cd_unidade_medida = 2  then pvi.qt_item_pedido_venda else 0 end
                        * pvi.vl_unitario_item_pedido,

        isnull(pv.ic_bonificacao_pedido_venda,'N') as ic_bonificacao_pedido_venda,
        isnull(pv.ic_garantia_pedido_venda,'N')    as ic_garantia_pedido_venda,

        isnull(fp.nm_familia_produto,'')           as nm_familia_produto,
        isnull(gp.nm_grupo_produto,'')             as nm_grupo_produto


-----------------------------------------------------------------------------------------------------------      

--select * from pedido_venda
        
FROM         
	Pedido_Venda pv                      with (nolock)
	INNER JOIN Pedido_Venda_Item pvi     with (nolock) ON pv.cd_pedido_venda       = pvi.cd_pedido_venda 
	INNER JOIN Cliente c                 with (nolock) ON pv.cd_cliente            = c.cd_cliente 
	LEFT OUTER JOIN Categoria_Produto cp with (nolock) ON pvi.cd_categoria_produto = cp.cd_categoria_produto 
	LEFT OUTER JOIN Grupo_Categoria gc   with (nolock) ON cp.cd_grupo_categoria    = gc.cd_grupo_categoria 
	LEFT OUTER JOIN Vendedor ve          with (nolock) ON pv.cd_vendedor           = ve.cd_vendedor 
	LEFT OUTER JOIN Vendedor vi          with (nolock) ON pv.cd_vendedor_interno   = vi.cd_vendedor 
	--LEFT OUTER JOIN Vendedor_Regiao vr ON pv.cd_vendedor = vr.cd_vendedor 
        LEFT OUTER JOIN Produto p            with (nolock) ON p.cd_produto             = pvi.cd_produto
	LEFT OUTER JOIN Produto_Custo pc     with (nolock) ON pc.cd_produto            = pvi.cd_produto 
        LEFT OUTER JOIN Unidade_Medida um    with (nolock) ON um.cd_unidade_medida     = pvi.cd_unidade_medida
	LEFT OUTER JOIN Tipo_Mercado tm      with (nolock) ON tm.cd_tipo_mercado       = c.cd_tipo_mercado
        left outer join Cliente_Origem co    with (nolock) ON co.cd_cliente            = pv.cd_cliente and
                                                              co.cd_cliente_origem     = pv.cd_cliente_origem


        left outer join Cliente        cli   with (nolock) ON cli.cd_cliente           = co.cd_cliente_origem
        left outer join Ramo_Atividade ra    with (nolock) ON ra.cd_ramo_atividade     = c.cd_ramo_atividade
        left outer join Pais           pa    with (nolock) on pa.cd_pais               = c.cd_pais
        left outer join Estado         e     with (nolock) on e.cd_estado              = c.cd_estado and
                                                              e.cd_pais                = c.cd_pais
        left outer join Cidade         cid   with (nolock) on cid.cd_pais              = c.cd_pais   and
                                                              cid.cd_estado            = c.cd_estado and
                                                              cid.cd_cidade            = c.cd_cidade 
        left outer join Cliente_Regiao cr    with (nolock) on cr.cd_cliente_regiao     = c.cd_regiao
        left outer join Tipo_Pedido    tp    with (nolock) on tp.cd_tipo_pedido        = pv.cd_tipo_pedido
        left outer join condicao_pagamento cpg       with (nolock) on cpg.cd_condicao_pagamento  = pv.cd_condicao_pagamento
        left outer join forma_condicao_pagamento fcp with (nolock) on fcp.cd_forma_condicao      = cpg.cd_forma_condicao
        left outer join Marca_Produto mp             with (nolock) on mp.cd_marca_produto        = p.cd_marca_produto
        left outer join Familia_Produto fp           with (nolock) on fp.cd_familia_produto      = p.cd_familia_produto
        left outer join Grupo_Produto   gp           with (nolock) on gp.cd_grupo_produto        = p.cd_grupo_produto          
--select * from cliente_origem
--select * from regiao
--select * from regiao_venda
--select * from cliente_regiao
--select cd_unidade_medida,* from pedido_venda_item
--select nm_marca_produto,* from produto

WHERE     

  convert(varchar(7),isnull(pvi.dt_cancelamento_item, DateAdd(month,1,pv.dt_pedido_venda)),121) > 
  convert(varchar(7),pv.dt_pedido_venda,121)                 AND
  isnull(pv.ic_consignacao_pedido, 'N')  <> 'S'              AND 
  pvi.qt_item_pedido_venda * pvi.vl_unitario_item_pedido > 0 AND 
  isnull(pv.ic_amostra_pedido_venda,'N') <> 'S'              AND
  isnull(pv.vl_total_pedido_venda,0) > 0                     AND
  --Casos Especiais de Serviço = Produto 
  isnull(pvi.cd_produto_servico,0)   = 0                     AND
  isnull(tp.ic_gera_bi,'S')          = 'S' 

  --Ludinei 01.03.2006 (Controle para casos de item 99) 
  --Teremos que criar um parâmetro porque tem cliente que utilizam pedidos maiores até 100 itens
  --and pvi.cd_item_pedido_venda <= (case when c.cd_tipo_mercado=1 then 80 else 999 end) 

