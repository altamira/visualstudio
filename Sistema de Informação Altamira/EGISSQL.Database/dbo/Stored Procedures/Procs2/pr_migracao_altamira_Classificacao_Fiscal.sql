
-------------------------------------------------------------------------------
--pr_migracao_altamira_Classificacao_Fiscal
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Robert Gaffo
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela
--Data             : 29.03.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_altamira_Classificacao_Fiscal
as

--Delta os Registros da Tabela Destino
delete from Classificacao_Fiscal_Idioma
delete from Classificacao_Fiscal_Estado
delete from Classificacao_Fiscal_Dispos
delete from Classificacao_Fiscal_Historico
delete from Classificacao_Fiscal

--select * from db_altamira.dbo.SI_TabelaNCM

--Montagem da Tabela Temporária

select
  --Atributos da tabela origem com o nome da tabela destino
identity(int, 1, 1)		as cd_classificacao_fiscal,
cod_ncm				as cd_mascara_classificacao,
cast(nome_ncm as varchar(40))	as nm_classificacao_fiscal,
null				as sg_classificacao_fiscal,
null 				as pc_ipi_classificacao,
null 				as ic_subst_tributaria,
null 				as ic_base_reduzida,
null 				as cd_dispositivo_legal,
null 				as cd_unidade_medida,
null 				as pc_importacao,
4 				as cd_usuario,
getdate()			as dt_usuario,
null 				as qt_siscomex_clas_fiscal,
cast(null as varchar) 		as ds_classificacao_fiscal,
null 				as ic_ativa_classificacao,
null 				as cd_tributacao,
null 				as cd_dispositivo_legal_ipi,
null 				as cd_especie_produto,
null 				as pc_ipi_entrada_classif,
null 				as cd_norma_origem,
null 				as cd_grupo_bem,
null 				as ic_licenca_importacao,
null 				as ic_ipi_valor,
null 				as vl_ipi_classificacao,
null 				as cd_extipi,
null 				as cd_genero_ncm_produto
into
  #Classificacao_Fiscal
from
  db_altamira.dbo.SI_TabelaNCM

--Inserção dos registros da Tabela Temporária na Tabela Destino Padrão

insert into
  Classificacao_Fiscal
select
  *
from
  #Classificacao_Fiscal

--Deleção da Tabela Temporária

drop table #Classificacao_Fiscal

--Mostra os registros migrados

select * from Classificacao_Fiscal

