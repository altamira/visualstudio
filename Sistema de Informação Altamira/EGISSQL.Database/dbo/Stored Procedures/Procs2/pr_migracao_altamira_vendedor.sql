
-------------------------------------------------------------------------------
--pr_migracao_altamira_vendedor
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
create procedure pr_migracao_altamira_vendedor

as

--Delta os Registros da Tabela Destino
delete from Vendedor_Regiao
delete from Vendedor_Meta
delete from Vendedor_Produto_Comissao
delete from Vendedor_Comissao
delete from Vendedor_Setor
delete from Vendedor_Imposto
delete from Vendedor_Valor_Comissao
delete from Vendedor_Adiantamento
delete from Vendedor_Email
delete from Vendedor_Nextel
delete from Vendedor

--select * from db_altamira.dbo.VE_Representantes order by verp_RazaoSocial

--Montagem da Tabela Temporária

select
  --Atributos da tabela origem com o nome da tabela destino
verp_codigo 							   as cd_vendedor,
cast (verp_RazaoSocial as varchar(40)) 				   as nm_vendedor,
cast (verp_RazaoSocial as varchar(15)) 			           as nm_fantasia_vendedor,
null								   as sg_vendedor,
verp_endereco 							   as nm_endereco_vendedor,
null								   as cd_numero_endereco,
null								   as nm_complemento_endereco,
verp_bairro 							   as nm_bairro_vendedor,
verp_DDD 							   as cd_ddd_vendedor,
verp_Telefone 							   as cd_telefone_vendedor,
verp_Fax							   as cd_fax_vendedor,
verp_CGC 							   as cd_cnpj_vendedor,
verp_inscricao							   as cd_inscestadual_vendedor,
null								   as cd_insmunicipal_vendedor,
null								   as nm_dominio_vendedor,
verp_Email 							   as nm_email_vendedor,
null								   as nm_email_particular,
null								   as pc_aliquota_irpj,
verp_Comissao							   as pc_comissao_vendedor,
verp_Contato							   as nm_contato_vendedor,
null								   as qt_visita_diaria_vendedor,
null								   as cd_agencia_banco_vendedor,
null								   as cd_conta_corrente,
verp_Cep 							   as cd_cep,
null								   as cd_banco,
1 								   as cd_pais,
(select top 1 cd_estado from Estado where sg_estado = verp_Estado) as cd_estado,
(select top 1 cd_cidade from Cidade where nm_cidade = verp_Cidade) as cd_cidade,
1 								   as cd_tipo_pessoa,
2 								   as cd_tipo_vendedor,
4 								   as cd_usuario,
getdate() 							   as dt_usuario,
'S' 								   as ic_ativo,
null								   as vl_meta,
verp_celular 	 						   as cd_celular,
null								   as ic_repnet_vendedor,
'N'								   as ic_wapnet_vendedor,
null								   as nm_logotipo_vendedor,
null								   as dt_acesso_repnet_vendedor,
null								   as dt_acesso_wapnet_vendedor,
null								   as vl_salario_vendedor,
null								   as ic_recibo_comis_vendedor,
null								   as dt_base_pagto_comissao,
null								   as dt_base_final_comissao,
null								   as ic_calcula_data_final,
null								   as ic_consiste_preco_orcado,
null								   as cd_tipo_comissao,
null								   as vl_piso_comissao_vendedor,
null								   as vl_teto_comissao_vendedor,
null								   as vl_salario_comis_vendedor,
null								   as cd_senha_reg_vendedor,
null								   as cd_celular_vendedor,
null								   as dt_base_pagamento_comis,
null								   as nm_ponto_ref_vendedor,
null								   as ic_email_orcam_vendedor,
null								   as cd_estrutura_venda,
null								   as cd_tipo_desconto_comissao,
null								   as cd_senha_operador_caixa,
null								   as ic_email_venda_vendedor,
null								   as pc_desconto_max_vendedor,
null								   as ic_empresa_vendedor,
null								   as ic_cad_proposta_vendedor,
null								   as nm_obs_proposta_vendedor,
null								   as ic_observacao_vendedor,
null								   as ic_frete_vendedor,
null								   as ic_tel_vendedor_proposta,
null								   as cd_centro_receita,
null								   as cd_centro_custo,
null								   as cd_departamento,
null								   as cd_loja,
null								   as pc_iss_vendedor,
null								   as cd_empresa_diversa,
null								   as cd_fornecedor,
null								   as cd_favorecido_empresa,
null								   as nm_assinatura_vendedor,
null								   as ic_copia_email_vendedor,
null								   as ic_fec_proposta_vendedor,
null								   as ic_analise_vendedor,
null								   as ic_acesso_vendedor,
null								   as ic_permite_edicao_cliente,
null								   as ic_email_visita_vendedor,
cast (null as varchar)						   as ds_perfil_vendedor,
null								   as cd_regional_venda,
null								   as cd_area_atuacao_venda
into
  #Vendedor
from
  db_altamira.dbo.VE_Representantes

--Inserção dos registros da Tabela Temporária na Tabela Destino Padrão

insert into
  Vendedor
select
  *
from
  #Vendedor


--Deleção da Tabela Temporária

drop table #Vendedor

--Mostra os registros migrados

select * from Vendedor

