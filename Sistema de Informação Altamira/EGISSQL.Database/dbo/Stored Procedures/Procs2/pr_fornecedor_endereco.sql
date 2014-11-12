
-------------------------------------------------------------------------------
--pr_fornecedor_endereco
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 27/07/2010
--Atualizado       : 27/07/2010
-- 
--------------------------------------------------------------------------------------------------
create procedure pr_fornecedor_endereco
@dt_inicial datetime,
@dt_final   datetime
as

--select * from fornecedor

--select * from fornecedor_contato

select 
  a.nm_razao_social          as Fornecedor,
  a.nm_fantasia_fornecedor   as Fantasia,
  a.nm_endereco_fornecedor   as Endereco,
  a.cd_numero_endereco       as Numero,
  a.nm_bairro                as Bairro,
  b.nm_cidade                as Cidade,
  c.sg_estado                as Estado,
  d.nm_pais                  as Pais,
  a.cd_cep                   as Cep,
  a.cd_ddd                   as ddd,
  a.cd_telefone              as Fone,

  case when isnull(a.nm_email_fornecedor,'')<>''
  then a.nm_email_fornecedor
  else
    (Select Top 1 cd_email_contato_forneced from fornecedor_contato where cd_fornecedor = a.cd_fornecedor)
  end as Email,

  (Select Top 1 nm_fantasia_contato_forne   from fornecedor_contato where cd_fornecedor = a.cd_fornecedor) as Contato,

  ra.nm_ramo_atividade                                                                    as Segmento,
  isnull(co.nm_fantasia_comprador,'')                                                     as Comprador

from 
  fornecedor a 
  left outer join cidade b            on a.cd_cidade          = b.cd_cidade
  left outer join estado c            on a.cd_estado          = c.cd_estado
  left outer join pais d              on a.cd_pais            = d.cd_pais
  left outer join ramo_atividade ra   on ra.cd_ramo_atividade = a.cd_ramo_atividade
  left outer join comprador co        on co.cd_comprador      = a.cd_comprador

where
  a.nm_razao_social is not null

order by 
  a.nm_razao_social

