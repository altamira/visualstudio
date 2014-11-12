-------------------------------------------------------------------------------  
--sp_helptext pr_migracao_altamira_fornecedor  
-------------------------------------------------------------------------------  
--GBS Global Business Solution Ltda                                        2006  
-------------------------------------------------------------------------------  
--Stored Procedure : Microsoft SQL Server 2000  
--Autor(es)        : Robert Gaffo  
--Banco de Dados   : Egissql  
--Objetivo         : Migração da Tabela de Fornecedor  
--Data             : 15.03.2009  
--Alteração        :   
------------------------------------------------------------------------------  
CREATE procedure pr_migracao_altamira_fornecedor  
as  
  
--Delta os Registros da Tabela Destino  
delete from Fornecedor_Cone  
delete from Fornecedor_Perfil  
--delete from Fornecedor_Informacao_Comercial  
delete from Fornecedor_Agenda  
delete from Fornecedor_Produto  
delete from Fornecedor_Contato  
delete from Fornecedor_Acesso_Intranet  
delete from Fornecedor_Endereco  
delete from Fornecedor_Logotipo  
delete from Fornecedor_Historico  
delete from Fornecedor_Concorrente  
delete from Fornecedor_Concorrente_Produto  
delete from Fornecedor_Iso  
delete from Fornecedor_Adiantamento  
delete from Fornecedor_Informacao_Compra  
delete from Fornecedor_Imposto_Produto  
delete from Fornecedor_Servico  
delete from Fornecedor_Diversos  
delete from Fornecedor_Sintegra  
delete from Fornecedor_Historico_Qualidade  
delete from Fornecedor_Produto_Preco  
delete from Fornecedor_Servico_Preco  
delete from Fornecedor_Licenca  
delete from Fornecedor_Fase  
delete from Fornecedor_Assunto  
delete from Fornecedor_Avaliacao  
delete from Fornecedor_Produto_Condicao_Pagto  
delete from Fornecedor  
  
--select * from DB_ALTAMIRA.dbo.CO_Fornecedor  
  
--Montagem da Tabela Temporária  
  
select  
  --Atributos da tabela origem com o nome da tabela destino  
identity(int, 1, 1)        as cd_fornecedor,  
case when rtrim(ltrim(isnull(f.cofc_Abreviado, ''))) = '' then  
  cast(f.cofc_nome as varchar(15))  
else  
  cast(f.cofc_Abreviado as varchar(15))  
end               as nm_fantasia_fornecedor,  
cast (f.cofc_nome as varchar(40))      as nm_razao_social,  
null            as nm_razao_social_comple,  
null            as nm_dominio_fornecedor,  
null             as ic_destinacao_fornecedor,  
null             as cd_suframa_fornecedor,  
null             as cd_reparticao_origem,  
getdate()          as dt_cadastro_fornecedor,  
cast (null as varchar)        as ds_fornecedor,  
null            as ic_equiparado_industrial,  
null             as ic_simples_fornecedor,  
null             as cd_banco,  
null            as cd_agencia_banco,  
null             as cd_conta_banco,  
case when(f.cofc_TipoPessoa = 'J') then  
  1  
else  
  2  
end           as cd_tipo_pessoa,  
null            as cd_ramo_atividade,  
null             as cd_comprador,  
4           as cd_usuario,  
getdate()           as dt_usuario,  
f.cofc_Fax         as cd_fax,  
f.cofc_Telefone         as cd_telefone,  
--(select top 1 cd_ddd_cidade from Cidade where nm_cidade = f.cofc_Cidade) as cd_ddd,  
f.cofc_DDDTelefone						  as cd_ddd,
1           as cd_pais,  --- select count(*) from fornecedor where cd_cidade is null group by cd_cidade  
(select top 1 cd_estado from Estado where sg_estado = f.cofc_Estado)as cd_estado,  
(select top 1 cd_cidade from Cidade where nm_cidade = f.cofc_Cidade)as cd_cidade,  
f.cofc_Bairro          as nm_bairro,  
null             as nm_complemento_endereco,  
null             as cd_numero_endereco,  
f.cofc_Endereco          as nm_endereco_fornecedor,  
f.cofc_Cep         as cd_cep,  
f.cofc_Codigo         as cd_cnpj_fornecedor,  
( select top 1 cd_identifica_cep from cep where cd_cep = f.cofc_Cep)as cd_identifica_cep,  
null           as sg_fornecedor,  
null           as cd_ip_fornecedor,  
null           as ic_wapnet_fornecedor,  
null           as cd_abablz_fornecedor,  
null           as cd_swift_fornecedor,  
null           as ic_iso_fornecedor,  
null           as dt_valid_iso_fornecedor,  
null           as cd_tipo_envio,  
1           as cd_condicao_pagamento,  
2           as cd_destinacao_produto,  
1           as cd_tipo_mercado,  
null           as cd_transportadora,  
f.cofc_Email         as nm_email_fornecedor,  
null           as cd_aplicacao_produto,  
'N'           as ic_iss_fornecedor,  
'N'           as ic_inss_fornecedor,  
null           as nm_ponto_ref_fornecedor,  
cast (null as varchar)        as ds_perfil_fornecedor,  
null           as cd_plano_financeiro,  
null           as cd_grupo_fornecedor,  
null           as cd_conta,  
cast (null as varchar)        as ds_endereco_fornecedor,  
null           as cd_fabricante,  
null           as ic_isento_insc_fornecedor,  
null           as cd_pag_guia_fornecedor,  
null           as ic_inscestadual_valida,  
null           as cd_inscEstadual,  
null           as cd_inscMunicipal,  
null           as pc_inss_fornecedor,  
null           as cd_senha_comnet_fornec,  
null           as ic_comnet_fornecedor,  
null           as dt_exportacao_registro,  
null           as cd_moeda,  
null           as cd_porto,  
null           as cd_idioma,  
null           as cd_porto_origem_padrao,  
null           as cd_barra_fornecedor,  
null           as ic_fmea_fornecedor,  
null           as ic_plano_fornecedor,  
null           as qt_dia_vcto_av_fornecedor,  
null           as dt_vcto_avaliacao_fornec,  
null           as cd_classif_fornecedor,  
null           as dt_iso_fornecedor,  
null           as ic_residuo_fornecedor,  
null           as ic_sucata_fornecedor,  
null           as cd_idioma_produto,  
null           as ic_status_fornecedor,  
null           as ic_analise_fornecedor,  
null           as dt_exportacao_fornecedor,  
null           as cd_identificacao_fornecedor,  
null           as ic_gera_cliente,  
null           as ic_gera_transportadora,  
null           as ic_valida_ie_fornecedor,  
null           as cd_certificado_avaliacao,  
null           as cd_certificado_iso_fornecedor,  
null           as cd_certificadora_qualidade,  
null           as cd_tipo_avaliacao,  
null           as ic_multi_form_fornecedor    
into  
  #Fornecedor  
from  
  db_altamira.dbo.co_fornecedor              f  with(nolock)  
--  inner join db_altamira.dbo.MigraFornecedor mf with(nolock) on mf.cofc_Codigo = f.cofc_Codigo    
  
-- select * from db_altamira.dbo.MigraFornecedor  
-- Inserção dos registros da Tabela Temporária na Tabela Destino Padrão  
  
insert into  
  Fornecedor   
select  
  *  
from  
  #Fornecedor  
  
  
--Mostra os registros migrados  
  
select * from Fornecedor  
  
  
--Montagem da Tabela Temporária  
  
select  
  --Atributos da tabela origem com o nome da tabela destino  
  f.cd_fornecedor,  
  identity(int,1,1)       as cd_contato_fornecedor,  
  fc.cofc_contato         as nm_contato_fornecedor,  
  cast(fc.cofc_contato as varchar(14))         as nm_fantasia_contato_forne,  
  f.cd_ddd                as cd_ddd_contato_fornecedor,  
  f.cd_telefone           as cd_telefone_contato_forne,  
  f.cd_fax                as cd_fax_contato_fornecedor,  
  null                    as cd_ramal_contato_forneced,  
  f.nm_email_fornecedor   as cd_email_contato_forneced,  
  cast (null as varchar)  as ds_observacao_contato_for,  
  null                    as cd_senha_intranet_contato,  
  null                    as cd_cargo,  
  null                    as cd_departamento,  
  null                    as cd_tipo_endereco,  
  4      as cd_usuario,  
  getdate()     as dt_usuario,  
  f.nm_fantasia_fornecedor,  
  null         as cd_celular_contato_fornec,  
  null         as ic_acesso_comnet_contato,  
  null        as cd_senha_comnet_contato,  
  null        as dt_nascimento_contato,  
  null         as cd_tratamento,  
  null        as cd_nivel_decisao,  
  null        as ic_status_contato,  
  null        as dt_status_contato,  
  null        as cd_ddd_celular,  
  null        as cd_ddi_contato_fornecedor,  
  null         as cd_ddi_celular,  
  null         as ic_mala_direta_contato  
into  
  #Fornecedor_Contato  
from  
  #Fornecedor f  
  inner join  db_altamira.dbo.co_fornecedor fc on f.cd_cnpj_fornecedor = fc.cofc_Codigo  
  
  
  
--Inserção dos registros da Tabela Temporária na Tabela Destino Padrão  
  
insert into  
  fornecedor_contato  
select  
  *   
from   
  #fornecedor_contato  
  
--Mostra os registros migrados  
  
--select * from Fornecedor_Contato  
  
--Deleção da Tabela Temporária  
  
drop table #Fornecedor  
drop table #Fornecedor_Contato  
  
