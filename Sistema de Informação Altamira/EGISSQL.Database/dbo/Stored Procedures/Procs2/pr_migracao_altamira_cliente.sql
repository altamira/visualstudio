
-------------------------------------------------------------------------------
--pr_migracao_altamira_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Fernadnes / Robert Gaffo
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela de Clientes
--Data             : 04.03.2009 / 15.03.2009
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_altamira_cliente
as


--select * from db_altamira.dbo.VE_CLIENTESNOVO

--Delta os Registros da Tabela Destino
delete from registro_suporte
delete from projeto_sistema
delete from registro_atividade_cliente


delete from cliente_contato
delete from cliente_perfil
delete from cliente_vendedor
delete from registro_suporte
delete from cliente

--Montagem da Tabela Temporária

--select * from cliente

select
  --Atributos da tabela origem com o nome da tabela destino
  identity(int,1,1)                     			       as cd_cliente,
  cast(dbo.fn_texto_padrao(c.vecl_Abreviado) as varchar(15))	       as nm_fantasia_cliente,
  cast(dbo.fn_texto_padrao(c.vecl_Nome)      as varchar(45))           as nm_razao_social_cliente,
  
  case 
    when rtrim(ltrim(substring(dbo.fn_texto_padrao(c.vecl_Nome),46,80))) = '' then
      null
    else
      rtrim(ltrim(substring(dbo.fn_texto_padrao(c.vecl_Nome),46,80)))
    end                                                                as  nm_razao_social_cliente_c,

  null                                  			       as nm_dominio_cliente,
  cast(c.vecl_email  as varchar)                               			       as nm_email_cliente,
  null                                  			       as ic_destinacao_cliente,
  null                                  			       as cd_suframa_cliente,
  null                                  			       as cd_reparticao_origem,
  null                                  			       as pc_desconto_cliente,
  getdate()                                 			       as dt_cadastro_cliente,
--  cast(null as varchar)                        			       as ds_cliente,
  rtrim(ltrim(rtrim(c.vecl_Observacao)+' '+rtrim(c.vecl_Credito)+
  ' '+rtrim(c.vecl_contato)))                                              as ds_cliente,
  null                                  			       as cd_conceito_cliente,
  case when c.vecl_TipoPessoa='F' then 
    2 
  else 
    1 
  end				                                       as cd_tipo_pessoa,
  null                                  			       as cd_fonte_informacao,
  1                              			       as cd_ramo_atividade,
  1                              				       as cd_status_cliente,
  null                                  			       as cd_transportadora,
  null                                  			       as cd_criterio_visita,
  3                                 			       as cd_tipo_comunicacao,
  1 								       as cd_tipo_mercado,
  1 								       as cd_idioma,
  null                                  			       as cd_cliente_filial,
  null                                  			       as cd_identifica_cep,
  c.vecl_Codigo                           			       as cd_cnpj_cliente,
  null                           				       as cd_inscMunicipal,

  case 
    when ((dbo.fn_mascara_ie(c.vecl_inscricao) is null) and (c.vecl_TipoPessoa='F')) then
      'ISENTO'
    when c.vecl_TipoPessoa = 'F' then
      'ISENTO'
    else
      dbo.fn_mascara_ie(c.vecl_inscricao)
    end                                                                                        as cd_inscestadual,

  dbo.fn_mascara_cep(c.vecl_cep)                     			      		       as cd_cep,
  dbo.fn_texto_padrao(c.vecl_Endereco)                  			     	       as nm_endereco_cliente,
  null                				                       as cd_numero_endereco,
  null          				                       as nm_complemento_endereco,
  dbo.fn_texto_padrao(c.vecl_Bairro)                           			       as nm_bairro,
  (select min(cd_cidade) from Cidade where nm_cidade = c.vecl_Cidade and cd_estado = (select min(cd_estado) from Estado where sg_estado = c.vecl_Estado ))  as cd_cidade,
  (select min(cd_estado) from Estado where sg_estado = c.vecl_Estado ) as cd_estado,
  1 								       as cd_pais,
  cast(case 
    when len(dbo.fn_limpa_mascara_cnpj(c.vecl_DDD)) = 3 then	
      substring(dbo.fn_limpa_mascara_cnpj(c.vecl_DDD),2,len(dbo.fn_limpa_mascara_cnpj(c.vecl_DDD))) 
    when len(dbo.fn_limpa_mascara_cnpj(c.vecl_DDD)) = 4 then	 	 
      substring(dbo.fn_limpa_mascara_cnpj(c.vecl_DDD),3,len(dbo.fn_limpa_mascara_cnpj(c.vecl_DDD))) 
    else
      dbo.fn_limpa_mascara_cnpj(c.vecl_DDD)
  end as int)  as cd_ddd,

--  c.vecl_DDD                              			       as cd_ddd,
  dbo.fn_mascara_telefone(c.vecl_Telefone)                         			       as cd_telefone,
  dbo.fn_mascara_telefone(c.vecl_Fax)                                  			       as cd_fax,
  4 								       as cd_usuario,
  getdate() 							       as dt_usuario,
  null                                  			       as cd_cliente_sap,
  'S'                                   			       as ic_contrib_icms_cliente,
  null                                  			       as cd_aplicacao_segmento,
  null                                  			       as cd_filial_empresa,
  'S'                                    			       as ic_liberado_pesq_credito,
  null                                  			       as cd_tipo_tabela_preco,
  null                                  			       as cd_regiao,
  null                                  			       as cd_centro_custo,
  1                                     			       as cd_cliente_grupo,
  2                                  	           		       as cd_destinacao_produto,
  null                                  			       as ic_exportador_cliente,
  null                                  			       as nm_especificacao_ramo,
  'N'	                                  			       as ic_wapnet_cliente,
  ( select min(cd_vendedor) from vendedor where cd_vendedor = c.vecl_representante ) as cd_vendedor,
  null                                  			       as cd_vendedor_interno,
  1                                 			       as cd_condicao_pagamento,
  null                                  			       as cd_cliente_filial_sap,
  null                                  			       as cd_categoria_cliente,
  'N'	                                  			       as ic_wapnet_wap,
  null                                  			       as nm_divisao_area,
  null                                  			       as ic_permite_agrupar_pedido,
  null                                  			       as nm_ponto_ref_cliente,
  null                                  			       as pc_comissao_cliente,
  null                                  			       as ic_isento_insc_cliente,
  null                                  			       as cd_conta,
  cast(null as varchar)                        			       as ds_cliente_endereco,
  null                                  			       as ic_mp66_cliente,
  null                                  			       as nm_cidade_mercado_externo,
  null                                  			       as sg_estado_mercado_externo,
  null                                  			       as nm_pais_mercado_externo,
  null                                  			       as qt_distancia_cliente,
  null                                  			       as ic_rateio_comissao_client,
  null                                  			       as cd_pag_guia_cliente,
  null                                  			       as ic_inscestadual_valida,
  null                                  			       as ic_habilitado_suframa,
  null                                  			       as ic_global_cliente,
  null                                  			       as ic_foco_cliente,
  null                                  			       as ic_oem_cliente,
  null                                  			       as ic_distribuidor_cliente,
  null                                  			       as cd_cliente_global,
  null                                  			       as dt_exportacao_registro,
  null                                  			       as cd_porto,
  null                                  			       as cd_abablz_cliente,
  null                                  			       as cd_swift_cliente,
  1 								       as cd_moeda,
  null                                  			       as cd_barra_cliente,
  null                                  			       as ic_fmea_cliente,
  null                                  			       as cd_fornecedor_cliente,
  null                                  			       as ic_plano_controle_cliente,
  null                                  			       as ic_op_simples_cliente,
  null                                  			       as cd_dispositivo_legal,
  null                                  			       as ic_promocao_cliente,
  null                                  			       as ic_contrato_cliente,
  null                                  			       as cd_idioma_produto_exp,
  null                                  			       as cd_loja,
  null                                  			       as cd_tabela_preco,
  null                                  			       as pc_icms_reducao_cliente,
  null                                  			       as ic_epp_cliente,
  null                                  			       as ic_me_cliente,
  null                                  			       as cd_forma_pagamento,
  null                                  			       as ic_dif_aliq_icms,
  null                                  			       as cd_tratamento_pessoa,
  NULL                             			       as cd_tipo_pagamento,
  null                                  			       as cd_cliente_prospeccao,
  null                                  			       as cd_tipo_documento,
  null                                  			       as ic_sub_tributaria_cliente,
  'S'                               			       as ic_analise_cliente,
  null                                  			       as cd_portador,
  null                                  			       as cd_ddd_celular_cliente,
  null                                  			       as cd_celular_cliente,
  c.vecl_DataNascimento                          			       as dt_aniversario_cliente,
  null                                  			       as ic_inss_cliente,
  null                                  			       as ic_polo_plastico_cliente,
  null                                  			       as ic_dispositivo_polo,
  null                                  			       as ic_valida_ie_cliente,
  2                                 			       as cd_tipo_pagamento_frete,
  null                                  			       as ic_multi_form_cliente,
  null                                  			       as ic_fat_minimo_cliente,
  null                                  			       as ic_pis_cofins_cliente,
  null                                  			       as pc_pis_cliente,
  null                                  			       as pc_cofins_cliente,
  null                                  			       as cd_tipo_local_entrega,
  null                                  			       as ic_cpv_cliente,
  null                                  			       as cd_plano_financeiro,
  null                                  			       as ic_espelho_nota_cliente,
  null                                  			       as ic_arquivo_nota_cliente,
  null                                  			       as cd_interface,
  null                                  			       as qt_latitude_cliente,
  null                                  			       as qt_longitude_cliente,
  null                                  			       as cd_unidade_medida,
  null                                  			       as ic_ipi_base_st_cliente  
into
  #Cliente
from
  db_altamira.dbo.VE_CLIENTESNOVO c
  inner join db_altamira.dbo.migracliente mc on mc.vecl_Codigo = c.vecl_Codigo 
-- where
--  vecl_codigo = '04120966000628'
-- Inserção dos registros da Tabela Temporária na Tabela Destino Padrão
-- select *
-- from
--   db_altamira.dbo.VE_CLIENTESNOVO c
--select * from #cliente

insert into
  cliente
select
  *
from
  #Cliente



--Deleção da Tabela Temporária

drop table #Cliente

--Mostra os registros migrados

select * from cliente

--Cliente_Contato

select
  c.cd_cliente,
  identity(int,1,1) as cd_contato,
  x.vecl_contato    as  nm_contato_cliente,
  cast(x.vecl_contato as varchar(15))             as nm_fantasia_contato,
  null              as cd_ddd_contato_cliente,
  null              as cd_telefone_contato,
  null              as cd_fax_contato,
  null              as cd_celular,
  null              as cd_ramal,
  null              as cd_email_contato_cliente,
  cast(null as varchar) as ds_observacao_contato,
  null              as cd_tipo_endereco,
  null              as cd_cargo,
  null              as cd_acesso_cliente_contato,
  null              as cd_usuario,
  getdate()         as dt_usuario,
  null              as cd_setor_cliente,
  null              as dt_nascimento,
  null              as cd_departamento_cliente,
  null              as dt_nascimento_cliente,
  null              as ic_status_contato_cliente,
  null              as ic_mala_direta_contato,
  null              as ic_informativo_contato,
  null              as ic_brinde_contato,
  null              as cd_departamento,
  null              as dt_nascimento_contato,
  null              as cd_tratamento_pessoa,
  null              as cd_nivel_decisao,
  'A'               as ic_status_contato,
  null              as dt_status_contato,
  null              as cd_ddd_celular,
  null              as cd_ddi_contato_cliente,
  null              as cd_ddi_celular,
  null              as ic_nfe_contato
into 
  #Cliente_Contato
from
  Cliente c
  inner join   db_altamira.dbo.VE_CLIENTESNOVO x on x.vecl_Codigo = c.cd_cnpj_cliente

insert into cliente_contato
select
  *
from
  #Cliente_Contato

--Cliente_Vendedor

--Cliente_Endereço

--Cliente_Perfil

select
  c.cd_cliente,
  c.ds_cliente as ds_perfil_cliente,
  cast(null as varchar) as ds_perfil_entrega_cliente,
  4 as d_usuario,
  getdate() as dt_usuario
into
 #cliente_perfil
from
  cliente c

insert into
  cliente_perfil
select
  *
from 
  #Cliente_perfil

--delete from registro_suporte
--delete from projeto_sistema
--delete from registro_atividade_cliente

