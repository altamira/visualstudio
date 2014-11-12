
CREATE VIEW vw_nfe_exporta_cliente
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_exporta_cliente
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Geração do Arquivo Texto para Importar o Cadastro de Clientes
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--Data                  : 04.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from egisadmin.dbo.empresa
--select * from cliente
--select * from tipo_pessoa

select
  'A' as Sessao,
  (select sg_versao_nfe from versao_nfe)                         as versao,
  tp.sg_tipo_pessoa                                              as Tipo_Documento,
  c.cd_cliente,
  c.nm_fantasia_cliente,
  case when c.cd_tipo_pessoa = 1  then
    dbo.fn_Formata_Mascara('00000000000000',isnull(c.cd_cnpj_cliente,0))
  else
    cast(dbo.fn_Formata_Mascara('00000000000000',isnull(c.cd_cnpj_cliente,0)) as varchar(14))
  end                                                           as cd_cnpj_cliente,
  c.nm_razao_social_cliente,
  isnull(replace(replace(replace(c.cd_inscestadual,'.',''),',',''),'-',''),'') as cd_inscestadual,
  isnull(c.cd_suframa_cliente,'') as cd_suframa_cliente,
  c.nm_endereco_cliente,
  c.cd_numero_endereco,
  c.nm_complemento_endereco,
  c.nm_bairro,
  replace(replace(cast(c.cd_cep as varchar(8)),'-',''),' ','') as cd_cep,
  p.nm_pais,
  est.sg_estado,
  cid.nm_cidade,
  replace(replace(replace(rtrim(ltrim(isnull(cid.cd_ddd_cidade,'11'))) + rtrim(ltrim(replace(isnull(c.cd_telefone,''),'-',''))),' ',''),')',''),'(','')  as cd_telefone_cliente,
  cast(isnull(p.cd_bacen_pais,'1058') as varchar(4)) as cd_bacen_pais,
  cast(isnull(cid.cd_cidade_ibge,'') as varchar(8)) as cd_cidade_ibge,
  c.cd_cidade   

from
  cliente c 
  inner join status_cliente sc  with (nolock) on sc.cd_status_cliente = c.cd_status_cliente
  inner join tipo_pessoa    tp  with (nolock) on tp.cd_tipo_pessoa    = c.cd_tipo_pessoa
  left outer join Pais      p   with (nolock) on p.cd_pais            = c.cd_pais
  left outer join Estado    est with (nolock) on est.cd_estado        = c.cd_estado
  left outer join Cidade    cid with (nolock) on cid.cd_cidade        = c.cd_cidade-- and
                                           --     cid.cd_estado        = c.cd_estado and
                                           --     cid.cd_estado        = c.cd_pais -- Não retornava o código da cidade do IBGE.
where
  isnull(sc.ic_operacao_status_cliente,'N') = 'S'

--select * from status_cliente


--select cd_status_cliente,* from cliente
--update status_cliente set ic_operacao_status_cliente = 'S'
--select * from cidade
