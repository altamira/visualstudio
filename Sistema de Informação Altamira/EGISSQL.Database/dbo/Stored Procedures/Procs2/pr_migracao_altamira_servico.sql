
-------------------------------------------------------------------------------
--pr_migracao_altamira_servico
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Robert Gaffo
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela
--Data             : 15.03.2009
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_altamira_servico
as

--Delta os Registros da Tabela Destino
delete from Servico_Especial
delete from Servico_Email
delete from Servico_Especial
delete from servico_terceiro
delete from Servico_Historico
delete from Servico_Contabilizacao
delete from Servico_Cidade
delete from Servico_Script
delete from Servico_Apresentacao
delete from Servico_Especial_Custo
delete from Servico_Custo
delete from Servico_Veiculo
delete from Servico_Modelo_Veiculo
delete from Servico_Opcional_Veiculo
delete from Servico

--select * from db_altamira.dbo.CO_servico

--Montagem da Tabela Temporária

select
  --Atributos da tabela origem com o nome da tabela destino
1 				    as cd_grupo_servico,
cose_codigo 			    as cd_servico,
null 				    as cd_mascara_servico,
cast(cose_descricao as varchar(40)) as nm_servico,
null 				    as sg_servico,
cast(cose_descricao as varchar(16)) as ds_servico,
4 				    as cd_usuario,
getdate() 			    as dt_usuario,
null 				    as cd_unidade_medida,
null 				    as cd_grupo_produto,
null 				    as vl_servico,
getdate()			    as dt_cadastro,
null 				    as cd_unidade_servico,
null 				    as pc_irrf_servico,
null 				    as pc_iss_servico,
null 				    as pc_comissao_servico,
null 				    as cd_iss_grupo_servico,
null 				    as cd_operacao_fiscal,
null 				    as cd_categoria_produto,
null 				    as ic_garantia_servico,
null 				    as qt_dia_garantia_servico,
null 				    as qt_fator_conv_extra,
null 				    as ic_retencao_servico,
null 				    as ic_rentecao_iss_obrig,
null 				    as ic_retencao_fed_servico,
null 				    as ic_livro_iss_servico,
null 				    as cd_op_fisc_interestadual,
null 				    as pc_desconto_servico,
null 				    as ic_sat_servico,
null 				    as ic_lp_servico,
null 				    as cd_grupo_preco_produto,
null 				    as vl_custo_servico,
null 				    as ic_retencao_inss_servico,
null 				    as pc_inss_servico,
null 				    as ic_processo_servico,
null 				    as cd_tipo_produto,
null 				    as cd_modalidade_servico
into
  #Servico
from
  db_altamira.dbo.CO_servico

--Inserção dos registros da Tabela Temporária na Tabela Destino Padrão

insert into
  Servico
select
  *
from
  #Servico


--Deleção da Tabela Temporária

drop table #Servico

--Mostra os registros migrados

select * from servico

