
CREATE VIEW vw_processo_producao_produto
------------------------------------------------------------------------------------
--sp_helptext vw_processo_producao_produto
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2008
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Mostrar a Quantidade de Produtos em Ordem de Produção
--Data                  : 07.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as
 
--select * from processo_producao
--select * from status_processo

select
  p.cd_processo,
  p.dt_processo,
  p.cd_produto,
  p.qt_planejada_processo
from
  processo_producao p with (nolock)
where
  p.cd_status_processo in (3,4) and
  isnull(p.cd_produto,0)>0



