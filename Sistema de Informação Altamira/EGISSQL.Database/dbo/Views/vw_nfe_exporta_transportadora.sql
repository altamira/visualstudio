
CREATE VIEW vw_nfe_exporta_transportadora
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_exporta_transportadora
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Geração do Arquivo Texto para Importar o Cadastro de Transportadora
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--Data                  : 04.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from egisadmin.dbo.empresa
--select * from tipo_pessoa

select
  'A' as Sessao,
  (select sg_versao_nfe from versao_nfe)                         as versao,
  tp.sg_tipo_pessoa                                             as Tipo_Documento,
  t.cd_transportadora,
  t.nm_fantasia,
  case when t.cd_tipo_pessoa = 1  then
    dbo.fn_Formata_Mascara('99999999999999',t.cd_cnpj_transportadora)
  else
    dbo.fn_Formata_Mascara('99999999999999',t.cd_cnpj_transportadora)
  end                                                           as cd_cnpj_transportadora,
  t.nm_transportadora,
  isnull(replace(replace(replace(t.cd_insc_estadual,'.',''),',',''),'-',''),'') as cd_insc_estadual,
  t.nm_endereco,
  isnull(rtrim(ltrim(t.nm_endereco)),'') + ' ' + ltrim(rtrim(isnull(cast(t.cd_numero_endereco as varchar(10)),''))) + ' ' + isnull(rtrim(ltrim(t.nm_bairro)),'') as endereco,
  dbo.fn_Formata_Mascara('99999999',t.cd_cep) as cd_cep,
  p.nm_pais,
  isnull(est.sg_estado,'SP') as sg_estado,
  cid.nm_cidade,
  case when substring(rtrim(ltrim(t.cd_ddd)) + rtrim(ltrim(replace(t.cd_telefone,'-',''))),1,1) = '0' then
    substring(rtrim(ltrim(t.cd_ddd)) + rtrim(ltrim(replace(t.cd_telefone,'-',''))),2,10)
  else
    rtrim(ltrim(isnull(t.cd_ddd,'11'))) + rtrim(ltrim(replace(isnull(t.cd_telefone,''),'-','')))
  end                                                                                       as cd_telefone
from
  Transportadora t
  inner join tipo_pessoa    tp with (nolock) on tp.cd_tipo_pessoa    = t.cd_tipo_pessoa
  left outer join Pais  p      with (nolock) on p.cd_pais            = t.cd_pais
  left outer join Estado est   with (nolock) on est.cd_estado        = t.cd_estado
  left outer join Cidade cid   with (nolock) on cid.cd_estado        = t.cd_estado and
                                                cid.cd_cidade        = t.cd_cidade and
                                                cid.cd_estado        = t.cd_pais
where
  isnull(t.ic_ativo_transportadora,'S') = 'S'

--select * from transportadora

