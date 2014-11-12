
-------------------------------------------------------------------------------
--sp_helptext pr_deleta_nota_registro_tipo_pedido
-------------------------------------------------------------------------------
--pr_deleta_nota_registro_tipo_pedido
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Deleção das Notas Fiscais de Entrada por Tipo de Pedido
--                   antes do processamento do Registro de Saída                   
--Data             : 27.03.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_deleta_nota_registro_tipo_pedido
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from tipo_pedido
--select * from nota_saida_registro

select
  nr.*
into
  #NotaRegistro
from
  nota_saida_registro nr
  inner join nota_saida ns       on ns.cd_nota_saida    = nr.cd_nota_saida
  inner join nota_saida_item nsi on nsi.cd_nota_saida   = ns.cd_nota_saida
  inner join pedido_venda    pv  on pv.cd_pedido_venda  = nsi.cd_pedido_venda
  inner join tipo_pedido     tp  on tp.cd_tipo_pedido   = pv.cd_tipo_pedido
where
  isnull(nsi.cd_pedido_venda,0)>0             and
  isnull(tp.ic_imposto_tipo_pedido,'S') = 'N' and
  ns.dt_nota_saida between @dt_inicial and @dt_final  


select
  nr.*
into
  #NotaRegistroItem
from
  nota_saida_item_registro nr
  inner join nota_saida ns       on ns.cd_nota_saida    = nr.cd_nota_saida
  inner join nota_saida_item nsi on nsi.cd_nota_saida   = ns.cd_nota_saida
  inner join pedido_venda    pv  on pv.cd_pedido_venda  = nsi.cd_pedido_venda
  inner join tipo_pedido     tp  on tp.cd_tipo_pedido   = pv.cd_tipo_pedido
where
  isnull(nsi.cd_pedido_venda,0)>0             and
  isnull(tp.ic_imposto_tipo_pedido,'S') = 'N' and
  ns.dt_nota_saida between @dt_inicial and @dt_final  


--select * from #NotaRegistro
--select * from #NotaRegistroItem

delete from Nota_Saida_Registro            where cd_nota_saida in ( select cd_nota_saida from #NotaRegistro )

delete from Nota_Saida_Item_Registro where cd_nota_saida in ( select cd_nota_saida from #NotaRegistroItem )


drop table #NotaRegistro
drop table #NotaRegistroItem


