
-------------------------------------------------------------------------------
--sp_helptext pr_migracao_altamira_transportadora
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela de Transportadora
--Data             : 15.03.2009
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_altamira_transportadora
as

--Delta os Registros da Tabela Destino

delete from transportadora_endereco
delete from transportadora_diversos
delete from transportadora_contato
delete from transportadora_veiculo
delete from transportadora


--select * from db_altamira.dbo.ve_transportadoras 

--Montagem da Tabela Temporária

select
  --Atributos da tabela origem com o nome da tabela destino
  vetr_Codigo                                    as cd_transportadora,
  cast(vetr_Nome as varchar(40))                 as nm_transportadora,
  case when isnull(vetr_abreviado,'')='' then
   cast(vetr_nome as varchar(15))
  else
  cast(vetr_Abreviado as varchar(15))   
  end                                            as nm_fantasia,
  null                                           as nm_dominio,
  'N'                                            as ic_frete_cobranca,
  'N'                                            as ic_sedex,
  'S'                                            as ic_minuta,
  'N'                                            as ic_altera_pedido,
  null                                           as ic_coleta,
  null                                           as ic_frete,
  1                                              as cd_tipo_pessoa,
  1                                              as cd_tipo_transporte,
  null                                           as ic_cobra_coleta,
  getdate()                                      as dt_cadastro,
  null                                           as nm_area_atuacao,
  --select * from tipo_pagamento_frete
  --select * from tipo_frete
  2                                              as cd_tipo_pagamento_frete,
  null                                           as cd_tipo_frete,
  4                                              as cd_usuario,
  getdate()                                      as dt_usuario,
  null                                           as nm_email_transportadora,
  --select top 10 * from cep
  
  ( select top 1 cd_identifica_cep from cep where cd_cep = vetr_CEP ) as cd_identifica_cep,
  vetr_CGC                                       as cd_cnpj_transportadora,
  vetr_CEP                                           as cd_cep,
  null                                           as cd_numero_endereco,
  vetr_endereco                                  as nm_endereco,
  vetr_bairro                                           as nm_bairro,
  vetr_fax                                           as cd_fax,
  vetr_telefone                                           as cd_telefone,
  vetr_ddd                                           as cd_ddd,
  1                                              as cd_pais,
  (select top 1 cd_estado from Estado where sg_estado = vetr_Estado)   as cd_estado,
  (select top 1 cd_cidade from Cidade where nm_cidade = vetr_Cidade)   as cd_cidade,
  null                                           as cd_insc_municipal,
  null                                           as nm_endereco_complemento,
  vetr_Inscricao                                           as cd_insc_estadual,
  'N'                                           as ic_wapnet_transportadora,
  'N'                                           as ic_comex_transportadora,
  null                                           as qt_peso_max_transp,
  null                                           as qt_peso_min_transp,
  null                                           as ic_padrao_importacao,
  null                                           as ic_padrao_exportacao,
  'S'                                            as ic_ativo_transportadora,
  1                                              as cd_tipo_mercado,
  cast(null as varchar)                          as ds_end_transportadora,
  null                                           as vl_km_rodado,
  null                                           as cd_empresa_diversa,
  null                                           as cd_tipo_conta_pagar,
  'S'                                            as ic_analise_transportadora,
  null                                           as cd_registro_transportadora
  
into
  #Transportadora
from
  --Tabela Origem
  db_altamira.dbo.ve_transportadoras
where
  vetr_abreviado <> '' and vetr_nome<>'' 

--Inserção dos registros da Tabela Temporária na Tabela Destino Padrão

insert into
  Transportadora
select
  *
from
  #Transportadora


--Deleção da Tabela Temporária

drop table #Transportadora

--Mostra os registros migrados

select * from Transportadora

