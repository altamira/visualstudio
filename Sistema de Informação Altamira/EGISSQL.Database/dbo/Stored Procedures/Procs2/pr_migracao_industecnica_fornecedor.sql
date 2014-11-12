
-------------------------------------------------------------------------------
--pr_migracao_industecnica_cliente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes 
--                   Wilder Mendes
--Banco de Dados   : Egissql
--Objetivo         : Migração da Tabela de Clientes
--Data             : 01.06.06
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_migracao_industecnica_fornecedor
as

--select CEP from KIN.DBO.inemp_certa WHERE TIPO='F'
--select * from egissql.dbo.cliente
--select * from egissql.dbo.fornecedor
--select * from egissql_industecnica.dbo.fornecedor

select
  identity(int,1,1)       as cd_fornecedor,
  apel                    as nm_fantasia_fornecedor,
  razao                   as nm_razao_social,
  INTERNET                as nm_dominio_fornecedor,
  EMAIL                   as nm_email_fornecedor,
  suframa                 as cd_suframa_fornecedor,
  pessoa                  as cd_tipo_pessoa,
  cast(transp as integer) as cd_transportadora,   
  cast(CGC   as decimal)  as cd_cnpj_fornecedor,
  IEST                    as cd_inscestadual,
  ENDERECO                as nm_endereco_fornecedor,
  BAIRRO                  as nm_bairro,
  FONE1                   as cd_telefone,
  FAX                     as cd_fax,
  ddd                     as cd_ddd,
  getdate()               as dt_cadastro_fornecedor,
  cast(CEP as int)        as cd_cep,
  --'S'                   as ic_liberado_pesq_credito, 
  1                       as cd_status_fornecedor, 
  cidade                  as cd_cidade,
  estado                  as cd_estado,
  1                       as cd_idioma,  
  1                       as cd_condicao_pagamento,
  1                       as cd_pais,
  1                       as cd_tipo_mercado,  
  1                       as cd_destinacao_produto
        
into
  #cliente_fornecedor
from
  inemp_certa
where
  tipo='F'

select * from #cliente_fornecedor
order by cd_fornecedor

--delete from cliente_endereco
--delete from fornecedor


insert into
  egissql_industecnica.dbo.fornecedor
  ( 
    cd_fornecedor,
    nm_fantasia_fornecedor,
    nm_razao_social,
    nm_dominio_fornecedor,
    nm_email_fornecedor,
    cd_suframa_fornecedor,
    cd_tipo_pessoa,
    cd_transportadora,   
    cd_cnpj_fornecedor,
    cd_inscestadual,
    nm_endereco_fornecedor,
    nm_bairro,
    cd_telefone,
    cd_fax,
    cd_ddd,
    dt_cadastro_fornecedor,
    cd_cep,
    --ic_liberado_pesq_credito,
    cd_status_fornecedor,
    cd_cidade,
    cd_estado,
    cd_idioma,  
    cd_condicao_pagamento,
    cd_pais,
    cd_tipo_mercado,  
    cd_destinacao_produto 

 
   )

select
    cd_fornecedor,
    nm_fantasia_fornecedor,
    nm_razao_social,
    nm_dominio_fornecedor,
    nm_email_fornecedor,
    cd_suframa_fornecedor,
    cd_tipo_pessoa,
    cd_transportadora,   
    cd_cnpj_fornecedor,
    cd_inscestadual,
    nm_endereco_fornecedor,
    nm_bairro,
    cd_telefone,
    cd_fax,
    cd_ddd,
    dt_cadastro_fornecedor,
    cd_cep,
    --ic_liberado_pesq_credito,
    cd_status_fornecedor,
    cd_cidade,
    cd_estado,
    cd_idioma,  
    cd_condicao_pagamento,
    cd_pais,
    cd_tipo_mercado,  
    cd_destinacao_produto 


from
  #cliente_fornecedor 


