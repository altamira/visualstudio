
-------------------------------------------------------------------------------  
--sp_helptext pr_consulta_indice_transformacao_materia_prima  
-------------------------------------------------------------------------------  
--pr_consulta_indice_transformacao_materia_prima  
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2008  
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Douglas de Paula Lopes
--Banco de Dados   : Egissql  
--Objetivo         :   
--Data             : 27.08.2008  
--Alteração        : 28.08.2008   
--14.10.2008 - Acerto da Quantidade Planejada - Carlos Fernandes
--15.10.2008 - Complemento dos Campos - Carlos Fernandes
--02.10.2010 - Número da Nota Fiscal / Novo campo --> cd_identificacao_nota_saida - Carlos Fernandes
--------------------------------------------------------------------------------------------------------  

create procedure pr_consulta_indice_transformacao_materia_prima  
@dt_inicial  datetime,  
@dt_final    datetime  

as

select 

  pp.cd_processo,
  pp.cd_produto,
  pp.cd_pedido_venda, 
  round(isnull(ppc.qt_real_processo * pp.qt_planejada_processo,0) - isnull(ppc.qt_comp_processo,0),2) as PerdaGanho,
  pp.cd_item_pedido_venda,
  pp.qt_planejada_processo,
  pp.dt_entrega_processo, 
  pp.dt_processo,
--  ppc.qt_comp_processo,
  ppc.qt_real_processo * pp.qt_planejada_processo as qt_real_processo,              
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.ds_produto,          
  p.nm_produto, 

  --Número da Nota Fiscal de Saída

  case when isnull(ns.cd_identificacao_nota_saida,0)<>0 then
    ns.cd_identificacao_nota_saida 
  else
    ns.cd_nota_saida
  end                    as cd_nota_saida,                                            


  ns.dt_nota_saida,
  ppc.cd_componente_processo,
  pc.cd_mascara_produto  as cd_mascara_componente,
  pc.nm_fantasia_produto as nm_fantasia_componente,
  pc.nm_produto          as nm_produto_componente,         
  ppc.qt_comp_processo,
  --Continuar Refugo
  0.00                   as qt_refugo,
  0.00                   as qt_nao_conforme,
  round(isnull(ppc.qt_real_processo * pp.qt_planejada_processo,0) - isnull(ppc.qt_comp_processo,0),2) as PerdaGanhoT
  
  --( select sum(qt_peca_ruim_produzida,0) )

--select * from status_processo
--select * from processo_producao_componente
--select * from processo_producao_apontamento

from
  processo_producao                       pp       with(nolock)
  inner join processo_producao_componente ppc      with(nolock) on ppc.cd_processo          = pp.cd_processo
  left outer join nota_saida_item              nsi with(nolock) on nsi.cd_pedido_venda      = pp.cd_pedido_venda and
                                                                   nsi.cd_item_pedido_venda = pp.cd_item_pedido_venda and
                                                                   nsi.dt_cancel_item_nota_saida is null  
                                                                   
  left outer join nota_saida                   ns  with(nolock) on ns.cd_nota_saida         = nsi.cd_nota_saida     and
                                                                   ns.cd_status_nota<>7
 
  left outer join produto                 p        with(nolock) on p.cd_produto             = pp.cd_produto
  left outer join produto                 pc       with(nolock) on pc.cd_produto            = ppc.cd_produto

where
  isnull(pp.dt_entrega_processo,pp.dt_processo) between @dt_inicial and @dt_final and
  isnull(pp.cd_status_processo,0) = 5 --Encerrada

