
-------------------------------------------------------------------------------
--pr_ajuste_flags_composicao_standard_projeto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Ajuste os flags da Tabela Composição Standard Material
--Data             : 02.08.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_ajuste_flags_composicao_standard_projeto
as

--select * from composicao_standard_material

update
  Composicao_Standard_Material
set
 ic_compra_prod_material = 'N'
where
  ic_compra_prod_material is null

update
  Composicao_Standard_Material
set
 ic_desgaste_material = 'N'
where
  ic_desgaste_material is null

update
  Composicao_Standard_Material
set
 ic_reposicao_material = 'N'
where
  ic_reposicao_material is null
  
update
  Composicao_Standard_Material
set
 ic_ativo_material = 'S'
where
  ic_ativo_material is null


