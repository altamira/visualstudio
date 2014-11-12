
CREATE VIEW vw_pedido_venda_item_nota_saida
------------------------------------------------------------------------------------
--sp_helptext vw_pedido_venda_item_nota_saida
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2009
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--
--Autor(es)             : Carlos Fernandes
--
--Banco de Dados	: EGISSQL 
--
--Objetivo	        : Mostrar as Notas Fiscais Faturadas por Pedido de Venda
--
--Data                  : 12.02.2009
--
--Atualização           : 04.08.2010 - Acertos Diversos - Carlos Fernandes
-- 05.10.2010 - Identificação da Nota Fiscal --> ( Nota_Saida --> cd_identificacao_nota_saida ) - Carlos Fernandes
-- 14.10.2010 - Novo Atributo - Carlos Fernandes
-------------------------------------------------------------------------------------------------------------------
as

      
SELECT
  nsi.cd_pedido_venda,
  nsi.cd_item_pedido_venda,

  max(isnull(ns.cd_identificacao_nota_saida,
      ns.cd_nota_saida))              as cd_identificacao_nota_saida,

  max(ns.cd_nota_saida)               as cd_nota_saida,

  --Número da Nota Fiscal
--   max( case when isnull(ns.cd_identificacao_nota_saida,0)<>0 
--   then
--        ns.cd_identificacao_nota_saida
--   else ns.cd_nota_saida 
--   end )                            as cd_nota_saida,     

  max(ns.dt_nota_saida)            as dt_nota_saida,
  max(ns.dt_saida_nota_saida)      as dt_saida_nota_saida,
  max(nsi.cd_item_nota_saida)      as cd_item_nota_saida,
  sum(nsi.qt_devolucao_item_nota)  as qt_devolucao_item_nota,
  sum(nsi.qt_item_nota_saida)      as qt_item_nota_saida,
  max(ns.dt_cancel_nota_saida)     as dt_cancel_nota_saida,
  max(ns.nm_mot_cancel_nota_saida) as nm_mot_cancel_nota_saida,
  max(isnull(ns.cd_status_nota,0)) as cd_status_nota,
  max(nsi.dt_restricao_item_nota)  as dt_restricao_item_nota

 FROM
   Nota_Saida_Item nsi            with (nolock)
   inner join Nota_Saida ns       with (nolock) ON ns.cd_nota_saida       = nsi.cd_nota_saida
   inner join Operacao_Fiscal opf with (nolock) on opf.cd_operacao_fiscal = nsi.cd_operacao_fiscal
 WHERE
   isnull(opf.ic_comercial_operacao,'N')='S' and
   ns.cd_status_nota not in (7,4)            and
   isnull(nsi.cd_pedido_venda,0)>0           and
   isNull(nsi.qt_item_nota_saida,0) > IsNull(nsi.qt_devolucao_item_nota,0) --Trás somente as nota que possuem saldo

--select ic_comercial_operacao,* from operacao_fiscal

GROUP BY
  nsi.cd_pedido_venda,
  nsi.cd_item_pedido_venda     

--select * from status_nota
 
