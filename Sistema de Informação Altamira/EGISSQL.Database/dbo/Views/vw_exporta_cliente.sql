

CREATE  VIEW vw_exporta_cliente
--vw_exporta_cliente  
---------------------------------------------------------  
--GBS - Global Business Solution              2003  
--Stored Procedure : Microsoft SQL Server       2003  
--Autor(es)  : Alexandre Del Soldato  
--Banco de Dados : EGISSQL  
--Objetivo  : Exportação do Cadastro de Cliente para Arquivo Magnético  
--Data   : 10/12/2003  
---------------------------------------------------  
as  
  
select  
  
  isnull(dbo.fn_data_maior_atual_cliente( c.dt_exportacao_registro, c.dt_usuario, ce.dt_usuario, cc.dt_usuario, ci.dt_usuario,  
           e.dt_usuario ), getdate()) as 'DT_ATUAL',      
  
  c.cd_cliente + 50000         as 'CODIGO_CLIENTE',  
  replace(replace(replace(c.nm_fantasia_cliente,'.',' '),',',' '), '"',' ')        as 'NOME',  
  replace(replace(replace(c.nm_razao_social_cliente,'.',' '),',',' '), '"',' ')    as 'RAZAO',  
  replace(replace(replace(cc.nm_contato_cliente,'.',' '),',',' '), '"',' ')        as 'PESSOA_CONTATO',  
  Case  
    When  c.cd_tipo_pessoa = 2 then 'F'  
    else 'J'  
  end as 'TIPO_EMPRESA',  
  
  Case  
    When isnull(c.cd_pais,1) = 1 then  
      case when c.cd_tipo_pessoa = 1 then  
        cast(dbo.fn_formata_mascara('00.000.000/0000-00',c.cd_cnpj_cliente) as varchar(18))  
      else  
        cast(dbo.fn_formata_mascara('000.000.000-00',c.cd_cnpj_cliente) as varchar(18))  
      end       
    else cast( c.cd_cliente + 50000 as varchar(18) )  
  end  as 'NUMERO',  
  
  replace(replace(c.nm_email_cliente,',',' '),'"',' ')           as 'EMAIL',  
  ''           as 'CNAE',  
  ''            as 'CAE',  
  c.dt_cadastro_cliente        as 'DATA',  
  replace(replace(replace(c.nm_endereco_cliente,'.',' '),',',' '), '"',' ')        as 'ENDERECO',  
  cast(c.cd_numero_endereco as varchar(6)) as 'NUMERO_END',  
  replace(replace(replace(c.nm_bairro,'.',' '),',',' '), '"',' ')         as 'BAIRRO',  
  replace(replace(replace(c.nm_complemento_endereco,'.',' '),',',' '), '"',' ')    as 'COMPLEMENTO',  
  Case  
    When isnull(c.cd_pais,1) = 1 then e.sg_estado  
    else 'EX'  
  end                          as 'ESTADO',  
  c.cd_inscmunicipal        as 'CODIGO_FISCAL',  
  c.cd_cep         as 'CEP',  
  c.cd_ddd         as 'NUMERO_DDD',  
  c.cd_telefone         as 'NUMERO_TELEFONE',  
  c.cd_fax         as 'NUMERO_FAX',  
  ''          as 'NUMERO_CAIXA_POSTAL',  
  c.nm_email_cliente           as 'ENDERECO_ELETRONICO',  
  c.nm_dominio_cliente         as 'HOME_PAGE',  
  ce.cd_ddd_cliente            as 'DDD',  
  ce.cd_telefone_cliente       as 'TELEFONE',    
  c.cd_inscestadual         as 'NUMERO_INSCRICAO_ESTADUAL',  
  c.cd_inscmunicipal        as 'NUMERO_INSCRICAO_MUNICIPAL',  
  c.ic_contrib_icms_cliente    as 'CONTRIBUINTE',  
  Case  
    When  c.cd_tipo_mercado = 2 then 'S'  
    else 'N'  
  end          as 'COMERCIAL',  
  ''          as 'EMPRESA_PUBLICO',  
  ''          as 'CLIENTE_SUBSTITUTO',  
  Case  
    When  c.cd_status_cliente = 1 then 'A'  
    else 'I'  
  end          as 'CLIENTE_ATIVO',  
  c.dt_cadastro_cliente        as 'DATA_ATIVO',  
  c.ic_habilitado_suframa      as 'UTILIZA_SUFRAMA',  
  c.cd_suframa_cliente        as 'NUMERO_SUFRAMA',  
  ''          as 'CODIGO_REPRESENTANTE',  
  ci.vl_limite_credito_cliente  as 'LIMITE_CREDITO',  
  
  replace(replace(replace(IsNull(ce.nm_endereco_cliente,  
         c.nm_endereco_cliente),'.',' '),',',' '), '"',' ') as 'ENDERECO_COB',  
  IsNull(cast(ce.cd_numero_endereco as varchar(6)),  
         cast(c.cd_numero_endereco as varchar(6))) as 'NUMERO_COB',  
  replace(replace(replace(IsNull(ce.nm_complemento_endereco,  
         c.nm_complemento_endereco),'.',' '),',',' '), '"',' ') as 'COMPLEMENTO_COB',  
  replace(replace(replace(IsNull(ce.nm_bairro_cliente,  
         c.nm_bairro),'.',' '),',',' '), '"',' ') as 'BAIRRO_COB',  
  IsNull(ce.cd_cidade,  
         c.cd_cidade) as 'MUNICIPIO_COB',  
  IsNull(ce.cd_cep_cliente, c.cd_cep) as 'CEP_COB',  
  IsNull(ce.cd_ddd_cliente,  
         c.cd_ddd) as 'DDD_COB',  
  IsNull(ce.cd_telefone_cliente,  
c.cd_telefone) as 'TELEFONE_COB'  
from  
  Cliente c  
  
  left outer join Cliente_Endereco ce  
  on ( ce.cd_tipo_endereco = 3 ) and  
     ( ce.cd_cliente = c.cd_cliente )  
  
  left outer join Cliente_Contato cc  
  on ( cc.cd_cliente = c.cd_cliente ) and  
     ( cc.cd_cliente = dbo.fn_fase_produto( c.cd_cliente, 0 )) and  
     ( cc.cd_contato = 1)  
  
  left outer join Cliente_Informacao_Credito ci  
  on ( ci.cd_cliente = c.cd_cliente )  
  
  left outer join Estado E  
  on ( e.cd_estado = c.cd_estado )  
  
  
--  where c.nm_fantasia_cliente like 'GM%'  
  
