

CREATE  VIEW vw_exporta_fornecedor
--vw_exporta_fornecedor
---------------------------------------------------------
--GBS - Global Business Solution	             2003
--Stored Procedure	: Microsoft SQL Server       2003
--Autor(es)		: Alexandre Del Soldato
--Banco de Dados	: EGISSQL
--Objetivo		: Exportação do Cadastro de Fornecedores para Arquivo Magnético
--Data			: 22/12/2003
---------------------------------------------------
as

select

  isnull(dbo.fn_data_maior_atual_fornecedor( f.dt_exportacao_registro, f.dt_usuario, fe.dt_usuario, fc.dt_usuario, 
           e.dt_usuario ), getdate()) as 'DT_ATUAL',    

  f.cd_fornecedor + 40000 as 'CODIGO_FORNECEDOR',
  replace(replace(replace(f.nm_fantasia_fornecedor,'.',' '),',',' '), '"',' ')      as 'NOME',
  replace(replace(replace(f.nm_razao_social,'.',' '),',',' '), '"',' ')    		as 'RAZAO',
  replace(replace(replace(fc.nm_contato_fornecedor,'.',' '),',',' '), '"',' ')      as 'PESSOA_CONTATO',

  Case
    When f.cd_tipo_pessoa = 2 then 'F'
    else 'J'
  end	as 'TIPO_EMPRESA',

  Case
    When isnull(f.cd_pais,1) = 1 then 
      cast(dbo.fn_formata_mascara('00.000.000/0000-00',f.cd_cnpj_fornecedor) as varchar(18))
    else
      cast(f.cd_fornecedor + 40000 as varchar(18))
  end as 'NUMERO',

  f.nm_email_fornecedor        as 'EMAIL',
  '' 			       as 'CNAE',
  ''  			       as 'CAE',
  f.dt_cadastro_fornecedor     as 'DATA',
  replace(replace(replace(f.nm_endereco_fornecedor,'.',' '),',',' '), '"',' ')     as 'ENDERECO',
  cast(f.cd_numero_endereco as varchar(6)) as 'NUMERO_END',
  replace(replace(replace(f.nm_bairro,'.',' '),',',' '), '"',' ')		       as 'BAIRRO',
  replace(replace(replace(f.nm_complemento_endereco,'.',' '),',',' '), '"',' ')    as 'COMPLEMENTO',
  Case
    When isnull(f.cd_pais,1) = 1 then e.sg_estado
    else 'EX'
  end                          as 'ESTADO',
  f.cd_inscmunicipal	       as 'CODIGO_FISCAL',
  f.cd_cep		       as 'CEP',
  f.cd_ddd		       as 'NUMERO_DDD',
  f.cd_telefone		       as 'NUMERO_TELEFONE',
  f.cd_fax		       as 'NUMERO_FAX',
  ''			       as 'NUMERO_CAIXA_POSTAL',
  f.nm_email_fornecedor        as 'ENDERECO_ELETRONICO',
  f.nm_dominio_fornecedor      as 'HOME_PAGE',
  fe.cd_ddd_fornecedor         as 'DDD',
  fe.cd_telefone_fornecedor    as 'TELEFONE',  
  f.cd_inscestadual 	       as 'NUMERO_INSCRICAO_ESTADUAL',
  f.cd_inscmunicipal	       as 'NUMERO_INSCRICAO_MUNICIPAL',
  null			       as 'CONTRIBUINTE',
  Case
    When  f.cd_tipo_mercado = 2 then 'S'
    else 'N'
  end			       as 'COMERCIAL',
  ''			       as 'EMPRESA_PUBLICO',
  ''			       as 'CLIENTE_SUBSTITUTO',
/*  Case
    When  f.cd_status_fornecedor = 1 then 'A'
    else 'I'
  end	*/null		       as 'CLIENTE_ATIVO',
  f.dt_cadastro_fornecedor     as 'DATA_ATIVO',
  null			       as 'UTILIZA_SUFRAMA',
  f.cd_suframa_fornecedor      as 'NUMERO_SUFRAMA',
  null			       as 'CODIGO_REPRESENTANTE',
  null  		       as 'LIMITE_CREDITO',
  replace(replace(replace(IsNull(fe.nm_endereco_fornecedor,
         f.nm_endereco_fornecedor),'.',' '),',',' '), '"',' ') 	as 'ENDERECO_COB',
  IsNull(cast(fe.cd_numero_endereco 	as varchar(6)),
         cast(f.cd_numero_endereco 	as varchar(6))) as 'NUMERO_COB',
  replace(replace(replace(IsNull(fe.nm_complemento_endereco,
         f.nm_complemento_endereco),'.',' '),',',' '), '"',' ') 	as 'COMPLEMENTO_COB',
  replace(replace(replace(IsNull(fe.nm_bairro_fornecedor,
         f.nm_bairro),'.',' '),',',' '), '"',' ') 			as 'BAIRRO_COB',
  IsNull(fe.cd_cidade,
         f.cd_cidade) 			as 'MUNICIPIO_COB',
  IsNull(fe.cd_cep_fornecedor, f.cd_cep)as 'CEP_COB',
  IsNull(fe.cd_ddd_fornecedor,
         f.cd_ddd) 			as 'DDD_COB',
  IsNull(fe.cd_telefone_fornecedor,
         f.cd_telefone) 		as 'TELEFONE_COB'
from
  Fornecedor F

  left outer join Fornecedor_Endereco fe
  on ( fe.cd_tipo_endereco = 3 ) and
     ( fe.cd_fornecedor = f.cd_fornecedor )

  left outer join Fornecedor_Contato fc
  on ( fc.cd_fornecedor = f.cd_fornecedor ) and
     ( fc.cd_fornecedor = dbo.fn_fase_produto( f.cd_fornecedor, 0 )) and
     ( fc.cd_contato_fornecedor = 1 )

  left outer join Estado E
  on ( e.cd_estado = f.cd_estado )


--  where c.nm_fantasia_cliente like 'GM%'

