
--------------------------------------------------------------------------------
CREATE PROCEDURE pr_proposta_aberta_vendedor
--------------------------------------------------------------------------------
--pr_proposta_aberta_vendedor 
--------------------------------------------------------------------------------
--GBS - Global Business Solution  Ltda                                      2004 
--------------------------------------------------------------------------------
--Stored Procedure      : Microsoft SQL Server 2000 
--Autor(es)             : Daniel C. Neto 
--Banco de Dados        : EGISSQL 
--Objetivo              : Trazer as propostas em aberto por vendedor no período.
--Data                  : 14/08/2003
--Artualização          : 13/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                      : 17.05.2005 - Verificação dos filtros - Carlos Fernandes
--                      : 17.06.2005 - Revisão - Carlos Fernandes
--------------------------------------------------------------------------------- 

@ic_parametro        int,  
@cd_filtro           int,
@cd_tipo_vendedor    int,
@dt_inicial          datetime,
@dt_final            datetime

as 

-------------------------------------------------------------------------------
if @ic_parametro = 1 -- Consulta de Propostas por Vendedor.
-------------------------------------------------------------------------------

begin

SELECT    DISTINCT
ic_fechada_consulta,
           co.cd_consulta, 
           cli.nm_fantasia_cliente, 
           co.dt_consulta, 
           cc.nm_fantasia_contato, 
           co.vl_total_consulta, 
           cp.nm_condicao_pagamento, 
           dp.nm_destinacao_produto, 
           v.nm_fantasia_vendedor, 
           vi.nm_fantasia_vendedor AS nm_vendedor_interno,
           (select count(x.cd_item_consulta) 
            from Consulta_Itens x 
            where 
		       x.cd_consulta = co.cd_consulta ) as 'qtd_itens',co.cd_vendedor

FROM       Consulta co 
           left outer join consulta_itens ci     on ci.cd_consulta = co.cd_consulta
           INNER JOIN      Cliente cli           ON co.cd_cliente = cli.cd_cliente 
           left outer join Cliente_Contato cc    ON cli.cd_cliente = cc.cd_cliente AND co.cd_contato = cc.cd_contato 
           left outer join Condicao_Pagamento cp ON co.cd_condicao_pagamento = cp.cd_condicao_pagamento 
           left outer join Destinacao_Produto dp ON co.cd_destinacao_produto = dp.cd_destinacao_produto 
           left outer join Vendedor v            ON co.cd_vendedor           = v.cd_vendedor 
           left outer join Vendedor vi           ON co.cd_vendedor_interno   = vi.cd_vendedor
where
	 	( co.dt_consulta between @dt_inicial and @dt_final ) and
		(
			(isnull(co.cd_vendedor,0) = (case isnull(@cd_filtro,0) when 0 then isnull(co.cd_vendedor,0) else isnull(@cd_filtro,0) end) and @cd_tipo_vendedor <> 1) or

      	(isnull(co.cd_vendedor_interno,0) = case isnull(@cd_filtro,0) when 0 then isnull(co.cd_vendedor_interno,0) else isnull(@cd_filtro,0) end and @cd_tipo_vendedor = 1)
		) and
    	co.dt_fechamento_consulta is null and
    	ci.dt_fechamento_consulta is null and
    	isnull(ci.cd_pedido_venda,0) = 0  and
    	ci.dt_perda_consulta_itens is null and
		isnull(ic_fechada_consulta, 'N') = 'N'

order by
  co.dt_consulta desc


end

--select * from consulta_itens

---------------------------------------------------------------------------------
else if @ic_parametro = 2 -- Filtro por Proposta
---------------------------------------------------------------------------------
begin

SELECT     cd_item_consulta, 
	   nm_fantasia_produto, 
	   nm_produto_consulta, 
           qt_item_consulta, 
           vl_lista_item_consulta, 
           pc_desconto_item_consulta, 
           vl_unitario_item_consulta,
           ( qt_item_consulta * vl_unitario_item_consulta ) as 'vl_total' 
	  
FROM       Consulta_Itens
WHERE
		cd_consulta = @cd_filtro and
    	dt_fechamento_consulta is null and
    	isnull(cd_pedido_venda,0) = 0  and
    	dt_perda_consulta_itens is null
end

