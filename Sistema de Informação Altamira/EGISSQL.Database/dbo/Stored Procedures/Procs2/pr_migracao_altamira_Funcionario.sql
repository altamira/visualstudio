
-------------------------------------------------------------------------------
--pr_migracao_altamira_Funcionario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Robert Gaffo
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela
--Data             : 29.03.2009
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_altamira_Funcionario
as

--Delta os Registros da Tabela Destino
delete from Funcionario_Contrato
delete from Funcionario_Contrato_Parcela
delete from Funcionario_Exame_Medico
delete from Funcionario_Adicional
delete from Funcionario_Reajuste
delete from Funcionario_Acesso
delete from Funcionario_Habilidade
delete from Funcionario_Evento
delete from Funcionario_Imagem_Documento
delete from Funcionario_Seguro
delete from Funcionario_Endereco
delete from Funcionario_Estrangeiro
delete from Funcionario_Dependente
delete from Funcionario_Dependente_Endereco
delete from Funcionario_Documento
delete from Funcionario_Informacao
delete from Funcionario_Aprovacao
delete from Funcionario_Curriculum
delete from Funcionario_Meio_Transporte
delete from Funcionario_Ferias
delete from Funcionario_Calculo
delete from Funcionario

--select * from db_altamira.dbo.rh_funcionarios

--Montagem da Tabela Temporária

select
  --Atributos da tabela origem com o nome da tabela destino
cast(fu_chapa as int) 		as cd_funcionario,
null 				as cd_empresa,
cast(fu_nome as varchar(50))	as nm_funcionario,
null 				as cd_chapa_funcionario,
null 				as cd_agencia_funcionario,
null 				as cd_conta_funcionario,
null 				as cd_banco,
4				as cd_usuario,
getdate()			as dt_usuario,
null 				as cd_seguradora,
null 				as cd_cartao_cred_func,
null 				as nm_cartao_cred_func,
null 				as cd_rg_funcionario,
null 				as cd_cpf_funcionario,
fu_Admissao			as dt_admissao_funcionario,
null 				as cd_centro_custo,
null 				as cd_departamento,
null 				as cd_cartao_credito,
cast(null as varchar)   	as ds_perfil,
null 				as cd_estrutura_empresa,
null 				as dt_ultima_avaliacao,
null 				as dt_ultimo_reajuste,
null 				as cd_nacionalidade,
null 				as cd_sexo,
null 				as cd_grau_instrucao,
null				as dt_nascimento_funcionario,
null 				as cd_tipo_salario,
null 				as cd_categoria_salario,
null 				as cd_cargo_funcionario,
null 				as cd_turno,
null 				as ic_ponto_funcionario,
null 				as ic_sindicato_funcionario,
null 				as cd_nivel_funcionario,
null 				as cd_ddd_funcionario,
null 				as cd_telefone_funcionario,
null 				as nm_foto_funcionario,
null 				as ic_deficiente_funcionario,
null 				as qt_ano_chegada_funcionario,
null 				as dt_cadastro_funcionario,
null 				as cd_registro_funcionario,
null 				as cd_situacao_funcionario,
null 				as cd_estado_civil,
null 				as cd_cel_funcionario,
null 				as cd_ddd_cel_funcionario,
cast(fu_nome as varchar(15))	as nm_fantasia_funcionario,
null 				as cd_vinculo_empregaticio,
null 				as cd_identificacao_funcionario,
null 				as cd_pais,
null 				as cd_estado,
null 				as cd_cidade,
null 				as cd_localizacao_bem,
null 				as cd_fornecedor,
null 				as qt_limite_req_viagem,
null 				as nm_email_funcionario,
null 				as nm_setor_funcionario,
null 				as cd_tipo_aprovacao,
null 				as cd_assunto_viagem,
null 				as cd_local_viagem,
null 				as cd_setor_funcionario,
null 				as nm_endereco_funcionario,
null 				as nm_bairro_funcionario,
null 				as nm_compl_end_funcionario,
null 				as cd_cep,
null 				as cd_identifica_cep,
null 				as cd_numero_endereco,
null 				as cd_conta,
null 				as cd_planta,
null 				as nm_local_funcionario,
null 				as cd_seccao,
null 				as nm_recado_funcionario,
null 				as nm_site_funcionario,
null 				as cd_funcionario_liberacao  
into
  #Funcionario
from
  db_altamira.dbo.rh_funcionarios

--Inserção dos registros da Tabela Temporária na Tabela Destino Padrão

insert into
  Funcionario
select
  *
from
  #Funcionario


--Deleção da Tabela Temporária

drop table #Funcionario

--Mostra os registros migrados

select * from Funcionario

