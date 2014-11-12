
CREATE  VIEW vw_destinatario_rapida
------------------------------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda
------------------------------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Eduardo Baião
--Banco de Dados  : EGISSQL
--Objetivo        : View para pesquisa de destinatários, busconado poucos
--                  dados para tornar as pesquisas mais ágeis
--Data            : 14/07/2003
-- 12/09/2006 - Incluído tabela de Agência Banco - Daniel C. Neto.
-- 21.10.2008 - Ajuste Diversos - Carlos Fernandes
-- 30.10.2009 - Verificação Ajustes p/ Sintegra - Carlos Fernandes
-- 16.12.2010 - Ajustes - Carlos Fernandes
------------------------------------------------------------------------------------------------------

AS 


select
  1                          as 'cd_tipo_destinatario',
  cd_cliente                 as 'cd_destinatario',
  nm_fantasia_cliente        as 'nm_fantasia',
  nm_razao_social_cliente    as 'nm_razao_social',
  nm_razao_social_cliente_c  as 'nm_razao_social_complemento',
  cd_tipo_pessoa,
  cd_cnpj_cliente            as 'cd_cnpj',
  cd_inscestadual 	     as 'cd_inscestadual',
  ic_isento_insc_cliente     as 'ic_isento_inscestadual',
  cd_inscmunicipal	     as 'cd_inscmunicipal',
  cd_tipo_mercado            as 'cd_tipo_mercado',
  nm_endereco_cliente        as 'nm_endereco',
  cast(cd_numero_endereco as varchar(6)) as 'cd_numero_endereco',
  nm_complemento_endereco,
  nm_bairro,
  cd_cep,
  cd_cidade,
  cd_estado,
  cd_pais,
  cd_ddd,
  cd_telefone,
  cd_fax,
  cd_conta

from
  Cliente with (nolock) 

union all

select
  2                         as 'cd_tipo_destinatario',
  cd_fornecedor             as 'cd_destinatario',
  nm_fantasia_fornecedor    as 'nm_fantasia',
  nm_razao_social           as 'nm_razao_social',
  nm_razao_social_comple    as 'nm_razao_social_complemento',
  cd_tipo_pessoa,
  cd_cnpj_fornecedor        as 'cd_cnpj',
  cd_inscestadual           as 'cd_inscestadual',
  ic_isento_insc_fornecedor as 'ic_isento_inscestadual',
  cd_inscmunicipal	        as 'cd_inscmunicipal',
  cd_tipo_mercado           as 'cd_tipo_mercado',
  nm_endereco_fornecedor    as 'nm_endereco',
  cast(cd_numero_endereco   as varchar(6)) as 'cd_numero_endereco',
  nm_complemento_endereco,
  nm_bairro,
  cd_cep,
  cd_cidade,
  cd_estado,
  cd_pais,
  cd_ddd,
  cd_telefone,
  cd_fax,
  cd_conta
from
  Fornecedor with (nolock) 

union all

select
  3                        as 'cd_tipo_destinatario',
  cd_vendedor              as 'cd_destinatario',
  nm_fantasia_vendedor     as 'nm_fantasia',
  nm_vendedor              as 'nm_razao_social',
  '' 			                 as 'nm_razao_social_complemento',
  cd_tipo_pessoa,
  cd_cnpj_vendedor         as 'cd_cnpj',
  cd_inscestadual_vendedor as 'cd_inscestadual',
  cast(null as char(1))    as 'ic_isento_inscestadual',
  cd_insmunicipal_vendedor as 'cd_inscmunicipal',
  null                     as 'cd_tipo_mercado',
  nm_endereco_vendedor     as 'nm_endereco',
  cast(cd_numero_endereco as varchar(6)) as 'cd_numero_endereco',
  nm_complemento_endereco,
  nm_bairro_vendedor       as 'nm_bairro',
  cd_cep,
  cd_cidade,
  cd_estado,
  cd_pais,
  cd_ddd_vendedor          as 'cd_ddd',
  cd_telefone_vendedor     as 'cd_telefone',
  cd_fax_vendedor          as 'cd_fax',
  0                        as cd_conta
from
  Vendedor with (nolock) 

union all

select
  4                       as 'cd_tipo_destinatario',
  cd_transportadora       as 'cd_destinatario',
  nm_fantasia             as 'nm_fantasia',
  nm_transportadora       as 'nm_razao_social',
  ''			                as 'nm_razao_social_complemento',
  cd_tipo_pessoa,
  cd_cnpj_transportadora  as 'cd_cnpj',
  cd_insc_estadual        as 'cd_inscestadual',
  cast(null as char(1))   as 'ic_isento_inscestadual',
  cd_insc_municipal       as 'cd_inscmunicipal',
  null                    as 'cd_tipo_mercado',
  nm_endereco             as 'nm_endereco',
  cast(cd_numero_endereco as varchar(6)) as 'cd_numero_endereco',
  nm_endereco_complemento,
  nm_bairro,
  cd_cep,
  cd_cidade,
  cd_estado,
  cd_pais,
  cd_fax,
  cd_telefone,
  cd_ddd,
  0 as 'cd_conta'

from
  Transportadora with (nolock) 

union all

select
  6                     as 'cd_tipo_destinatario',
  cd_funcionario        as 'cd_destinatario',
  nm_funcionario        as 'nm_fantasia',
  nm_funcionario        as 'nm_razao_social',
  ''		                as 'nm_razao_social_complemento',
  2                     as 'cd_tipo_pessoa',  -- Pessoa Física
  cd_cpf_funcionario    as 'cd_cnpj',
  cd_rg_funcionario     as 'cd_inscestadual',
  cast(null as char(1)) as 'ic_isento_inscestadual',
  null		              as 'cd_inscmunicipal',
  null                  as 'cd_tipo_mercado',
  null                  as 'nm_endereco',
  null                  as 'cd_numero_endereco',
  null                  as 'nm_complemento_endereco',
  null                  as 'nm_bairro',
  null                  as 'cd_cep',
  null                  as 'cd_cidade',
  null                  as 'cd_estado',
  null                  as 'cd_pais',
  null                  as 'cd_fax',
  null                  as 'cd_telefone',
  null                  as 'cd_ddd',
  0                     as 'cd_conta'
from
  Funcionario with (nolock) 

union all

select
  8                  	     as 'cd_tipo_destinatario',
  a.cd_agencia_banco   	     as 'cd_destinatario',
  b.nm_banco +' - '+ a.nm_agencia_banco           as 'nm_fantasia',
  a.nm_agencia_banco           as 'nm_razao_social',
  ''		                    as 'nm_razao_social_complemento',
   1                         as 'cd_tipo_pessoa',
  a.cd_cnpj_agencia_banco      as 'cd_cnpj',
  null    		              as 'cd_inscestadual',
  ''                         as 'ic_isento_inscestadual',
  null		                 as 'cd_inscmunicipal',
  null                       as 'cd_tipo_mercado',
  a.nm_endereco_agencia_banco  as 'nm_endereco',
  cast(cd_numero_endereco as varchar(6)) as 'cd_numero_endereco',
  a.nm_complemento_endereco    as 'nm_complemento_endereco',
  a.nm_bairro                  as 'nm_bairro',
  a.cd_cep_agencia_banco       as 'cd_cep',
  a.cd_cidade                  as 'cd_cidade',
  a.cd_estado                  as 'cd_estado',
  a.cd_pais                    as 'cd_pais',
  a.cd_fax_agencia_banco       as 'cd_fax',
  a.cd_telefone_agencia_banco  as 'cd_telefone',
  null                       as 'cd_ddd',
  0                          as 'cd_conta'

from
  Agencia_Banco a with (nolock)        
  left join Banco b on (a.cd_banco = b.cd_banco)


