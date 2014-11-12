------------------------------------------------------------------------------- 
CREATE  PROCEDURE pr_consulta_pedido_emissao
-------------------------------------------------------------------------------
--pr_consulta_pedido_emissao
-------------------------------------------------------------------------------
--GBS - Global Business Solution Ltda                                      2004
-------------------------------------------------------------------------------
--Stored Procedure        : Microsoft SQL Server 2000
--Autor(es)               : Johnny Mendes de Souza
--Banco de Dados          : EGISSQL
--Objetivo                : Consultar Pedidos
--Data                    : 29/04/2002
--Alteração               : Igor - 11/06/2002
--Desc. Alteração         : Inclusão do Tipo e Status do Pedido
--Alteração               : Fabio - 30.09.2003
--Desc. Alteração         : Inclusão da coluna de vendedor interno além de corrigir a apresentação do vendedor externo
--                        : 14/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso
--                        : 11.05.2005 - Colocado a Categoria do produto - Carlos Fernandes
--                        : 31/08/2005 - Relacionamento entre as tabelas Cliente - Cliente_Grupo
--                                       e inserção do campo nm_cliente_grupo - Wellington Souza Fagundes
--                        : 15.10.2005 - Verificação da Data de Entrega Comercial/PCP - Carlos Fernandes
--                        : 13.01.2006 - Implementar filtragem dos dados das consultas pelo vendedor - Fabio Cesar
--                        : 22.05.2006 - Melhoria d
--                        : 25.10.2006 - Area Produto = Márcio Rodrigues
--                        : 27.02.2007 - Verificar o Serviço - Carlos Fernandes
-- 22.07.2009 - Verificação - Carlos Fernandes
-- 14.10.2010 - Duplicidade devido ao número da Nota - Carlos Fernandes
-----------------------------------------------------------------------------------------------------------------------
 @dt_inicial DateTime,
 @dt_final   DateTime,
 @cd_usuario int = 0
AS
begin

	declare @cd_vendedor int

	--Define o vendedor para o cliente
	Select
		@cd_vendedor = dbo.fn_vendedor_internet(@cd_usuario)


 SELECT
 c.nm_fantasia_cliente,
 pv.dt_pedido_venda, 
 pv.cd_pedido_venda, 
 pvi.cd_item_pedido_venda, 
 case pvi.ic_pedido_venda_item when 'S' 
 then
    case when cast(pvi.ds_produto_pedido_venda as varchar(50))='' then
      (Select top 1 nm_servico from Servico with (nolock) 
       where cd_servico = pvi.cd_servico)
    else
      cast(pvi.ds_produto_pedido_venda as varchar(50)) end
 else
   pvi.nm_produto_pedido 
 end                                  as nm_produto, 

 case pvi.ic_pedido_venda_item when 'S' 
 then (Select top 1 sg_servico from Servico with (nolock) 
       where cd_servico = pvi.cd_servico)
 else
   pvi.nm_fantasia_produto
 end                                  as  nm_fantasia_produto, 

 pvi.cd_consulta, 
 pvi.cd_item_consulta,
 pv.nm_referencia_consulta,
 pvi.qt_item_pedido_venda,
 pvi.vl_unitario_item_pedido,
 pvi.pc_desconto_item_pedido,

 case when(pvi.dt_cancelamento_item is null) then  (qt_item_pedido_venda * vl_unitario_item_pedido) else 0 end AS vl_total,
 case when (pvi.dt_cancelamento_item is not null) then  (qt_item_pedido_venda * vl_unitario_item_pedido) else 0 end AS vl_totalcanc,

 case when pvi.dt_entrega_fabrica_pedido is not null
      then pvi.dt_entrega_fabrica_pedido
      else pvi.dt_entrega_vendas_pedido end as dt_entrega_fabrica_pedido,

 pvi.dt_entrega_vendas_pedido,
 pvi.dt_reprog_item_pedido,
 ns.cd_identificacao_nota_saida as cd_nota_saida,
 nsi.cd_item_nota_saida,
 pvi.dt_cancelamento_item,
 cp.nm_condicao_pagamento,
 t.nm_transportadora,
 pvi.cd_os_tipo_pedido_venda,
 pvi.cd_posicao_item_pedido,
 pv.cd_pdcompra_pedido_venda,
 pvi.cd_pdcompra_item_pedido,
 pvi.ic_tipo_montagem_item,
 pvi.ic_montagem_g_item_pedido,
 pvi.ic_subs_tributaria_item,
 pvi.qt_saldo_pedido_venda,
 tp.nm_tipo_pedido,
 tp.sg_tipo_pedido,
 st.nm_status_pedido,
 st.sg_status_pedido,
 pvi.nm_desconto_item_pedido,
 v.nm_fantasia_vendedor,
 vendi.nm_fantasia_vendedor as nm_fantasia_vendedor_interno,
 cap.nm_categoria_produto,
 cg.nm_cliente_grupo ,
 pvi.qt_area_produto,
 isnull(pvi.qt_item_pedido_venda,0) * isnull(pvi.qt_area_produto,0) as qt_total_area,
 dbo.fn_ultima_ordem_producao_item_pedido(pv.cd_pedido_venda, pvi.cd_item_pedido_venda) as cd_Processo,
 nsi.dt_restricao_item_nota,
 ns.dt_cancel_nota_saida

--select * from nota_saida_item
--select * from status_nota

into
  #PVEmissao

FROM
 Pedido_Venda pv                       with (nolock)
 INNER JOIN Pedido_Venda_Item pvi      with (nolock) ON pvi.cd_pedido_venda = pv.cd_pedido_venda 
 LEFT OUTER JOIN Transportadora t      with (nolock) ON pv.cd_transportadora = t.cd_transportadora 
 LEFT OUTER JOIN Destinacao_Produto dp with (nolock) ON pv.cd_destinacao_produto = dp.cd_destinacao_produto 
 LEFT OUTER JOIN Vendedor v            with (nolock) ON pv.cd_vendedor = v.cd_vendedor 
 LEFT OUTER JOIN Vendedor vendi        with (nolock) ON pv.cd_vendedor_interno = vendi.cd_vendedor

 LEFT OUTER JOIN vw_pedido_venda_item_nota_saida nsi on nsi.cd_pedido_venda      = pvi.cd_pedido_venda      and
                                                        nsi.cd_item_pedido_venda = pvi.cd_item_pedido_venda



--  LEFT OUTER JOIN Nota_Saida_Item nsi with (nolock)
--    ON pvi.cd_item_pedido_venda = nsi.cd_item_pedido_venda AND 
--       pvi.cd_pedido_venda      = nsi.cd_pedido_venda      
 
 LEFT OUTER JOIN Nota_Saida ns       with (nolock) on ns.cd_nota_saida   = nsi.cd_nota_saida 

 LEFT OUTER JOIN Condicao_Pagamento cp 
   ON pv.cd_condicao_pagamento = cp.cd_condicao_pagamento
 LEFT OUTER JOIN Cliente c with (nolock)
   ON pv.cd_cliente = c.cd_cliente 
 LEFT OUTER JOIN Tipo_Pedido tp 
   ON pv.cd_tipo_pedido = tp.cd_tipo_pedido 
 LEFT OUTER JOIN Status_Pedido st 
   ON pv.cd_status_pedido = st.cd_status_pedido
 LEFT OUTER JOIN Categoria_Produto cap 
   ON cap.cd_categoria_produto = pvi.cd_categoria_produto
 LEFT OUTER JOIN Cliente_Grupo cg 
   ON c.cd_cliente_grupo = cg.cd_cliente_grupo 
 WHERE 
   pv.dt_pedido_venda between @dt_inicial and @dt_final
   --13.01.2006 Realiza a filtragem pelo vendedor para os casos de acesso por um usuário remoto/internet (representante) - Fabio Cesar
   and IsNull(pv.cd_vendedor,0) = ( case @cd_vendedor
                                      when 0 then IsNull(pv.cd_vendedor,0)
                                      else @cd_vendedor
                                    end )

 ORDER BY 
   pv.dt_pedido_venda desc, pv.cd_pedido_venda DESC, pvi.cd_item_pedido_venda


delete from   #PVEmissao
where
  dt_restricao_item_nota is not null or
  dt_cancel_nota_saida is not null

  
select
  *
from
  #PVEmissao
order by
   dt_pedido_venda desc, cd_pedido_venda DESC, cd_item_pedido_venda


end


--select * from nota_saida_item where cd_nota_saida = 5549
--select * from nota_saida      where cd_nota_saida = 5549

