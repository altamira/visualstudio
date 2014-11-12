
CREATE VIEW vw_processo_producao_pedido_venda
------------------------------------------------------------------------------------
--sp_helptext vw_processo_producao_pedido_venda
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL ou EGISADMIN
--Objetivo	        : Mostra os Processos de Produção por Processo de Produção
--Data                  : 04.01.2008
--Atualização           : 
------------------------------------------------------------------------------------
as
 
select 
  pp.cd_processo,
  pp.dt_processo,
  pp.cd_pedido_venda,
  pp.cd_item_pedido_venda,
  pp.qt_planejada_processo,
  sp.nm_status_processo
from 
  processo_producao pp with (nolock)
  inner join status_processo sp on sp.cd_status_processo = pp.cd_status_processo
where
   pp.cd_status_processo = 5 --Encerradas

-- order by 
--    dt_processo desc

