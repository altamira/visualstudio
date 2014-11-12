
create  VIEW vw_in86_centro_custos_despesas
--vw_in86_centro_custos_despesas
---------------------------------------------------------
--GBS - Global Business Solution	                   2004
--Stored Procedure	: Microsoft SQL Server           2004
--Autor(es)		      : André Godoi
--Banco de Dados	  : EGISSQL
--Objetivo		      : Selecionar as Despesas por Centro de Custo
--                    4.9.3  
--Data			        : 02/04/2004
---------------------------------------------------
as

select
  dt_usuario             as 'DATAATUALIZACAO',
  cd_centro_custo        as 'CODIGO',
  nm_centro_custo        as 'DESCRICAO'

from
  centro_custo  
