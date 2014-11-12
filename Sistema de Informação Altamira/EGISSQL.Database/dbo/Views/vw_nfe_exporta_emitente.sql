
CREATE VIEW vw_nfe_exporta_emitente
------------------------------------------------------------------------------------
--sp_helptext vw_nfe_exporta_emitente
------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                       2004
------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)             : Carlos Cardoso Fernandes
--Banco de Dados	: EGISSQL 
--Objetivo	        : Geração do Arquivo Texto para Importar o Cadastro da Empresa
--                        para o sistema de emissão da Nota Fiscal Eletrônica
--Data                  : 04.11.2008
--Atualização           : 
------------------------------------------------------------------------------------
as

--select * from egisadmin.dbo.empresa

    select 
      'A' as Sessao,
      (select sg_versao_nfe from versao_nfe)                         as versao,                                              
      ltrim(rtrim(cast(isnull(dbo.fn_Formata_Mascara('00000000000000',e.cd_cgc_empresa),'') as varchar(14)))) as cd_cnpj_empresa,  
      cast(isnull(ltrim(rtrim(e.nm_empresa)),'') as varchar(60)) as nm_empresa,   
      cast(isnull(ltrim(rtrim(e.nm_fantasia_empresa)),'') as varchar(60)) as nm_fantasia_empresa,  
      ltrim(rtrim(cast(replace(replace(replace(isnull(e.cd_iest_empresa,''),'.',''),'-',''),'/','') as varchar(14)))) as cd_iest_empresa,  
      ltrim(rtrim(cast(replace(replace(replace(isnull(e.nm_inscricao_municipal,''),'.',''),'-',''),'/','') as varchar(15)))) as cd_inscricao_municipal,   
      ltrim(rtrim(cast(isnull(e.cd_cnae,'') as varchar(7)))) as cd_cnae,  
      ltrim(rtrim(cast(replace(replace(replace(isnull(e.cd_iest_st_empresa,''),'.',''),'-',''),'/','') as varchar(14)))) as cd_iest_st_empresa,  
      isnull(cast(rtrim(ltrim(e.nm_endereco_empresa)) as varchar(60)), '') as nm_endereco_empresa,  
      cast(isnull(e.cd_numero,'') as varchar(60)) as cd_numero,  
      cast(isnull(e.nm_complemento_endereco,'') as varchar(60)) as nm_complemento_endereco,  
      cast(isnull(e.nm_bairro_empresa,'') as varchar(60)) as nm_bairro_empresa,  
      cast(isnull(cid.cd_cidade_ibge,'') as varchar(8)) as cd_cidade_ibge,  
      cast(isnull(cid.nm_cidade,'') as varchar(60)) as nm_cidade,   
      cast(isnull(est.sg_estado,'') as varchar(2)) as sg_estado,  
      dbo.fn_Formata_Mascara('99999999',replicate('0',8 - len(cast(e.cd_cep_empresa as varchar(8)))) + cast(e.cd_cep_empresa as varchar(8))) as cd_cep_empresa,  
      cast(isnull(p.cd_bacen_pais,'1058') as varchar(4)) as cd_bacen_pais,  
      cast(isnull(p.nm_pais,'BRASIL') as varchar(20)) as nm_pais,  
      case when substring(cast(replace(replace(replace(replace(isnull(e.cd_telefone_empresa,''),'-',''),'(',''),')',''),' ','') as varchar(12)),1,1) = '0' then  
        substring(cast(replace(replace(replace(replace(isnull(e.cd_telefone_empresa,''),'-',''),'(',''),')',''),' ','') as varchar(12)),2,len(cast(replace(replace(replace(replace(isnull(e.cd_telefone_empresa,'0000000000'),'-',''),'(',''),')',''),' ','') as varchar(12))))  
      else  
        cast(replace(replace(replace(replace(isnull(e.cd_telefone_empresa,''),'-',''),'(',''),')',''),' ','') as varchar(12))  
      end         as cd_telefone_empresa 
from
  egisadmin.dbo.empresa e    with (nolock) 
  left outer join cnae  c    with (nolock) on c.cd_cnae = e.cd_cnae
  left outer join Pais  p    with (nolock) on p.cd_pais = e.cd_pais
  left outer join Estado est with (nolock) on est.cd_estado = e.cd_estado
  left outer join Cidade cid with (nolock) on cid.cd_estado = e.cd_estado and
                                              cid.cd_cidade = e.cd_cidade
where
  e.cd_empresa = dbo.fn_empresa() 

--select * from cnae

