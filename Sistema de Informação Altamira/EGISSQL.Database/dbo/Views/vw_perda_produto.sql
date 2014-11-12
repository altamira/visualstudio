
CREATE VIEW vw_perda_produto
------------------------------------------------------------------------------------
--sp_helptext vw_perda_produto
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Consulta de Perda por Produto
--Data                  : 07.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from consulta_itens

select
  i.cd_produto,
  i.cd_consulta,
  i.cd_item_consulta,
  i.qt_item_consulta,
  i.vl_unitario_item_consulta,
  i.qt_item_consulta * i.vl_unitario_item_consulta as vl_total_perda,
  i.dt_perda_consulta_itens,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto  
  
from
  consulta_itens i          with (nolock) 
  inner join consulta c     with (nolock) on c.cd_consulta = i.cd_consulta
  left outer join produto p with (nolock) on p.cd_produto  = i.cd_produto

where
  i.dt_perda_consulta_itens is not null
   
