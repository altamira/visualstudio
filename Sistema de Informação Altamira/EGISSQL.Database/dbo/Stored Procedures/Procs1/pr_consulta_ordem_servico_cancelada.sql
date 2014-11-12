
-------------------------------------------------------------------------------
--pr_consulta_ordem_servico_cancelada
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de OS Canceladas
--Data             : 09/12/2004
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_ordem_servico_cancelada
as

Select 
      os.dt_cancelamento_ordem_serv,
      os.cd_ordem_servico,
      os.dt_ordem_servico,
      c.nm_fantasia_cliente,
      t.nm_fantasia_tecnico,
      os.ds_cancelamento_ordem_serv,
      p.nm_fantasia_produto as nm_equipamento,
      os.vl_total_ordem_servico 
From 
      Ordem_Servico os
       left outer join Cliente c on
      c.cd_cliente = os.cd_cliente  
       left outer join Tecnico t on
      t.cd_tecnico = os.cd_tecnico
       left outer join numero_serie_equipamento nse on
      nse.cd_equipamento_serie = os.cd_equipamento_serie
       left outer join Produto p on
      p.cd_produto = nse.cd_produto 
where 
      os.dt_cancelamento_ordem_serv is not null
