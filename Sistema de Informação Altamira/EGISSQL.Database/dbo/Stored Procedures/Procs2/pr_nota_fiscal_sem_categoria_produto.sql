
-------------------------------------------------------------------------------
--pr_nota_fiscal_sem_categoria_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Consulta das Notas Fiscais sem Categoria de Produto
--
--Data             : 28/10/2005
--Atualizado       : 28/10/2005 
-- 23.10.2010 - Ajuste do Número da Nota Fiscal - Carlos Fernandes

--------------------------------------------------------------------------------------------------
create procedure pr_nota_fiscal_sem_categoria_produto
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

--Select * from nota_saida_item
--select cd_vendedor,* from nota_saida

select
  v.nm_fantasia_vendedor      as Vendedor,
--  ns.cd_nota_saida            as Nota,
  case when isnull(ns.cd_identificacao_nota_saida,0)>0 then
         ns.cd_identificacao_nota_saida
      else
         ns.cd_nota_saida                  
  end                              as 'Nota',

  ns.dt_nota_saida            as Emissao,
  sn.nm_status_nota           as Status,
  nsi.cd_item_nota_saida      as Item,
  nsi.qt_item_nota_saida      as Qtd,
  nsi.cd_mascara_produto      as Codigo,
  nsi.nm_fantasia_produto     as Produto,
  nsi.nm_produto_item_nota    as Descricao,
  nsi.cd_pedido_venda         as Pedido,
  nsi.cd_item_pedido_venda    as ItemPed,
  ns.nm_fantasia_destinatario as Cliente

from
  Nota_Saida ns                  with (nolock) 
  inner join nota_saida_item nsi with (nolock) on nsi.cd_nota_saida = ns.cd_nota_saida
  left outer join status_nota sn with (nolock) on sn.cd_status_nota = ns.cd_status_nota
  left outer join vendedor    v  with (nolock) on v.cd_vendedor     = ns.cd_vendedor
where
  ns.dt_nota_saida between @dt_inicial and @dt_final and
  isnull(nsi.cd_categoria_produto,0) = 0




