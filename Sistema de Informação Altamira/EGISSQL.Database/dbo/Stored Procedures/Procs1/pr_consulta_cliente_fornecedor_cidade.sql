
create procedure pr_consulta_cliente_fornecedor_cidade
@cd_pais   int,
@cd_estado int,
@cd_cidade int
as

select 
       f.nm_fantasia_cliente           as 'fantasia',
       f.nm_razao_social_cliente       as 'RazaoSocial',
       f.cd_ddd                        as 'ddd'  ,               
       cast(f.cd_telefone as varchar ) as 'Fone',
       f.nm_endereco_cliente           as 'Endereco',
       f.cd_numero_endereco            as 'numero',
       f.nm_bairro                     as 'bairro' ,
       c.nm_cidade                     as 'cidade',
       e.sg_estado                     as 'Estado' ,
       f.cd_cnpj_cliente               as 'CNPJ',
       f.cd_identifica_cep             as 'Cep',
       f.nm_email_cliente              as 'e-mail',
       f.nm_dominio_cliente            as 'Site'
into
  #Cliente

from Cliente f, 
     cidade c, 
     estado e
where
  f.cd_pais   = @cd_pais    and
  f.cd_estado = @cd_estado  and
  f.cd_cidade = @cd_cidade  and
  f.cd_cidade = c.cd_cidade and  f.cd_estado = c.cd_estado and
  f.cd_estado = e.cd_estado
order by
 e.sg_estado,
 c.nm_cidade,
 f.nm_fantasia_cliente


select f.nm_fantasia_fornecedor as 'fantasia',
       f.nm_razao_social        as 'RazaoSocial',
       f.cd_ddd                 as 'ddd'  ,               
       f.cd_telefone            as 'Fone',
       f.nm_endereco_fornecedor as 'Endereco',
       f.cd_numero_endereco     as 'numero',
       f.nm_bairro              as 'bairro' ,
       c.nm_cidade              as 'cidade',
       e.sg_estado              as 'Estado' ,
       f.cd_cnpj_fornecedor     as 'CNPJ',
       f.cd_identifica_cep      as 'Cep',
       f.nm_email_fornecedor    as 'e-mail',
       f.nm_dominio_fornecedor  as 'Site'
into #Fornecedor

from fornecedor f, 
       cidade c, 
       estado e

where
  f.cd_pais   = @cd_pais    and
  f.cd_estado = @cd_estado  and
  f.cd_cidade = @cd_cidade  and
  f.cd_cidade = c.cd_cidade and  f.cd_estado = c.cd_estado and
  f.cd_estado = e.cd_estado 
order by
 e.sg_estado,
 c.nm_cidade,
 f.nm_fantasia_fornecedor


select * from #Cliente
union all select * from #Fornecedor
order by 1

