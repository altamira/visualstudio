
CREATE PROCEDURE pr_analise_conferencia_reserva
----------------------------------------------------------------------------
--GBS - Global Business Solution	       2002
----------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Fabio Cesar 
--Banco de Dados: Egissql
--Objetivo: Lista os pedidos onde não foi encontrado um movimento de estoque correspondente ao mesmo
--Data: 23.04.2003
--      29/05/2003 - Johnny.
--
-- 14.04.2004 - Inclusão de filtro para trazer somentes itens de produto, caso o fantasia do 
--              produto do pedido de venda = null, ela pega direto da tabela de produto. - Igor Gama
--
-- 24.04.2009 : Tipo de Pedido e o Flag de Movimento de Estoque - Carlos Fernandes
-- 21.09.2009 : Ajustes Diversos - Carlos Fernandes
-- 16.03.2010 : Ajuste para Identificar se a Reserva for de Cancelamento permitir nova Reserva - Carlos Ferandes/Luis
----------------------------------------------------------------------------------------------------------------------

@cd_pedido_venda int = 0,
@dt_inicial      datetime,
@dt_final        datetime

AS

-- ============================================================
-- Seleciona todos os pedidos de venda que tenham sido fechados
-- contudo não geraram estoque de reserva no estoque
-- ============================================================

	Select 
		IDENTITY(int) Identificador,
		(Select top 1 nm_fantasia_cliente from Cliente with (nolock) where cd_cliente = pv.cd_cliente) as nm_fantasia_cliente,
		pvi.cd_pedido_venda,

                convert(varchar(20),

                  case when nsi.dt_nota_saida is not null 
                  then
                    nsi.dt_nota_saida
                  else                 
                    case when IsNull(pvi.dt_fechamento_pedido, pv.dt_fechamento_pedido) < pv.dt_pedido_venda then
                        pv.dt_pedido_venda
                    else
                      IsNull(pvi.dt_fechamento_pedido, pv.dt_fechamento_pedido)
                    end
                  end ,103)
                                                              as dt_fechamento,
		convert(varchar(20), pv.dt_pedido_venda, 103) as dt_pedido_venda,
		pvi.cd_item_pedido_venda,
		pvi.qt_item_pedido_venda,
		IsNull(pvi.nm_fantasia_produto, p.nm_fantasia_produto) nm_fantasia_produto,
		IsNull(pvi.nm_produto_pedido, p.nm_produto) nm_produto_pedido,
		pvi.cd_produto,
		pvi.vl_unitario_item_pedido,
                case when isnull(me.cd_tipo_movimento_estoque,0) = 3 then
                  cast(null as int )    
                else
                   me.cd_movimento_estoque
                end                                              as cd_movimento_estoque,
                tp.nm_tipo_pedido,
                tp.sg_tipo_pedido,
                isnull(tp.ic_sce_tipo_pedido,'N') as ic_sce_tipo_pedido,

  --Nota Fiscal

  nsi.cd_nota_saida,
  nsi.dt_nota_saida,
  nsi.dt_saida_nota_saida,
  nsi.cd_item_nota_saida,
  nsi.qt_item_nota_saida,
  nsi.qt_devolucao_item_nota,
  nsi.qt_item_nota_saida        as qt_faturada

--  nsi.cd_status_nota    

--select * from tipo_pedido

	into
		#Reservado

	from 
		Pedido_Venda pv        with (nolock) 
      inner join Pedido_Venda_Item pvi with (nolock) on pv.cd_pedido_venda = pvi.cd_pedido_venda 
      left outer join Produto p        with (nolock) on pvi.cd_produto = p.cd_produto
      left outer join Movimento_estoque me with (nolock)  on cast(pvi.cd_pedido_venda as varchar(30)) = me.cd_documento_movimento 
                                                             and pvi.cd_item_pedido_venda = me.cd_item_documento 
      left outer join Tipo_Pedido tp with (nolock)        on pv.cd_tipo_pedido = tp.cd_tipo_pedido
      LEFT OUTER JOIN vw_pedido_venda_item_nota_saida nsi        on nsi.cd_pedido_venda        = pvi.cd_pedido_venda      and
                                                                    nsi.cd_item_pedido_venda   = pvi.cd_item_pedido_venda

	where
          isnull(me.cd_tipo_movimento_estoque,0) <> 3 and
    IsNull(pvi.ic_pedido_venda_item,'P') = 'P'
		and
-- 		--Filtro de acordo com os parametros informados
-- 		(((@cd_pedido_venda = 0) and (pv.dt_pedido_venda between @dt_inicial and @dt_final))
-- 		or ((@cd_pedido_venda <> 0) and (pv.cd_pedido_venda = @cd_pedido_venda)))
          pv.cd_pedido_venda = case when @cd_pedido_venda = 0 then pv.cd_pedido_venda else @cd_pedido_venda end and
		dt_cancelamento_item is null and --Pedidos não cancelados
    IsNull(tp.ic_sce_tipo_pedido,'N') = 'S'

	Select 
		0 as selecionado,
		Identificador,		
		nm_fantasia_cliente,
		cd_pedido_venda,
		cd_item_pedido_venda,
		qt_item_pedido_venda,
		nm_fantasia_produto,
		dt_fechamento,
		dt_pedido_venda,
		nm_produto_pedido,
		vl_unitario_item_pedido,
		cd_produto,
                nm_tipo_pedido,
                sg_tipo_pedido,
                ic_sce_tipo_pedido,
                cd_movimento_estoque,
  cd_nota_saida,
  dt_nota_saida,
  dt_saida_nota_saida,
  cd_item_nota_saida,
  qt_item_nota_saida


	from
		#Reservado
	where
            dt_fechamento is not null and
		cd_movimento_estoque is null and
                dt_fechamento between @dt_inicial and @dt_final

	order by nm_fantasia_cliente
