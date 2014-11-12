
CREATE VIEW vw_in86_pessoa_fisica_juridica
--vw_in86_pessoa_fisica_juridica
-------------------------------------------------------------
--GBS - Global Business Solution	                       2004
--Stored Procedure	: Microsoft SQL Server               2004
--Autor(es)		      : André de Oliveira Godoi
--Banco de Dados   	: EGISSQL
--Objetivo		      : Arquivo de Pessoas Fisicas e Juridicas.
--                    4.9.1
--Data			        : 23/03/2004
-------------------------------------------------------------
as

select
  f.dt_usuario                                                       as 'DATAATUALIZACAO',
  'Fo' + cast(f.cd_fornecedor as char(12))                           as 'CODIGO',
  f.cd_cnpj_fornecedor                                               as 'CNPJ_CPF',
  f.cd_inscestadual                                                  as 'INSCRICAO_ESTADUAL',
  f.cd_inscmunicipal                                                 as 'INSCRICAO_MUNICIPAL',
  f.nm_razao_social                                                  as 'RAZAO_SOCIAL',
  IsNull(fe.nm_endereco_fornecedor, f.nm_endereco_fornecedor) + 
  IsNull(fe.nm_complemento_endereco, f.nm_complemento_endereco)      as 'ENDERECO',
  IsNull(fe.nm_bairro_fornecedor, f.nm_bairro)                	     as 'BAIRRO',
  ci.nm_cidade                                                       as 'MUNICIPIO',
  uf.nm_estado                                                       as 'UF',
  pa.nm_pais                                                         as 'PAIS'

from

  fornecedor f

  left outer join Fornecedor_Endereco fe  on 
     ( fe.cd_tipo_endereco = 3 ) and
     ( fe.cd_fornecedor = f.cd_fornecedor )

  left outer join cidade ci on
     (ci.cd_cidade = isnull(fe.cd_cidade, f.cd_cidade))

  left outer join estado uf on
     (uf.cd_estado = isnull(fe.cd_estado, f.cd_estado))   

  left outer join pais pa  on 
     ( pa.cd_pais = isnull(fe.cd_pais, f.cd_pais))

union all

select    
  c.dt_usuario                                                           as 'DATAATUALIZACAO',
  'Cl' + cast(c.cd_cliente as char(12))                                  as 'CODIGO',
  c.cd_cnpj_cliente                                                      as 'CNPJ_CPF',
  c.cd_inscestadual                                                      as 'INSCRICAO_ESTADUAL',
  c.cd_inscmunicipal                                                     as 'INSCRICAO_MUNICIPAL',
  c.nm_razao_social_cliente                                              as 'RAZAO_SOCIAL',

  IsNull(ce.nm_endereco_cliente, c.nm_endereco_cliente) + 
  IsNull(ce.nm_complemento_endereco, c.nm_complemento_endereco)          as 'ENDERECO',
  IsNull(ce.nm_bairro_cliente, c.nm_bairro)                	             as 'BAIRRO',
  cd.nm_cidade                                                           as 'MUNICIPIO',
  uf.nm_estado                                                           as 'UF',
  pa.nm_pais                                                             as 'PAIS'

from

  cliente  c

  left outer join cliente_endereco ce  on 
     ( ce.cd_tipo_endereco = 3 ) and
     ( ce.cd_cliente = c.cd_cliente )

  left outer join cidade cd on
     ( cd.cd_cidade = isnull(ce.cd_cidade, c.cd_cidade))

  left outer join Estado uf on
     ( uf.cd_estado = isnull(ce.cd_estado, c.cd_estado))

  left outer join Pais pa on
     ( pa.cd_pais = isnull( ce.cd_pais, c.cd_pais))

union all

select 

  v.dt_usuario                                                   as 'DATAATUALIZACAO',
  'Ve' + cast(v.cd_vendedor as char(12))                         as 'CODIGO',
  v.cd_cnpj_vendedor                                             as 'CNPJ_CPF',
  v.cd_inscestadual_vendedor                                     as 'INSCRICAO_ESTADUAL',
  v.cd_insmunicipal_vendedor                                     as 'INSCRICAO_MUNICIPAL',
  v.nm_vendedor                                                  as 'RAZAO_SOCIAL',
  v.nm_endereco_vendedor + v.nm_complemento_endereco             as 'ENDERECO',
  v.nm_bairro_vendedor                                         	 as 'BAIRRO',
  cd.nm_cidade                                                   as 'MUNICIPIO',
  uf.nm_estado                                                   as 'UF',
  pa.nm_pais                                                     as 'PAIS'


from 
  vendedor v

  left outer join cidade cd on
     ( cd.cd_cidade = v.cd_cidade)

  left outer join Estado uf on
     ( uf.cd_estado = v.cd_estado)

  left outer join Pais pa on
     ( pa.cd_pais = v.cd_pais)

union all

select 
  t.dt_usuario                                                          as 'DATAATUALIZACAO',
  'Tr' + cast(t.cd_transportadora as char(12))                          as 'CODIGO',
  t.cd_cnpj_transportadora                                              as 'CNPJ_CPF',
  t.cd_insc_estadual                                                    as 'INSCRICAO_ESTADUAL',
  t.cd_insc_municipal                                                   as 'INSCRICAO_MUNICIPAL',
  t.nm_transportadora                                                   as 'RAZAO_SOCIAL',
  isnull(te.nm_endereco, t.nm_endereco) + 
        isnull(te.nm_complemento_endereco, t.nm_endereco_complemento)   as 'ENDERECO',
  isnull(te.nm_bairro, t.nm_bairro)                                  	  as 'BAIRRO',
  cd.nm_cidade                                                          as 'MUNICIPIO',
  uf.nm_estado                                                          as 'UF',
  pa.nm_pais                                                            as 'PAIS'

from

  transportadora t

  left outer join transportadora_endereco te on
    ( te.cd_tipo_endereco = 3 ) and
    ( te.cd_transportadora = t.cd_transportadora )

  left outer join cidade cd on
    ( cd.cd_cidade = isnull(te.cd_cidade, t.cd_cidade))
  
  left outer join Estado uf on
     ( uf.cd_estado = isnull(te.cd_estado, t.cd_estado))

  left outer join Pais pa on
     ( pa.cd_pais = isnull(te.cd_pais, t.cd_pais))

union all


select 
  f.dt_usuario                                                     as 'DATAATUALIZACAO',
  'Fu' + cast(f.cd_funcionario as char(12))                        as 'CODIGO',
  f.cd_cpf_funcionario                                             as 'CNPJ_CPF',
  f.cd_rg_funcionario                                              as 'INSCRICAO_ESTADUAL',
  null                                                             as 'INSCRICAO_MUNICIPAL',
  f.nm_funcionario                                                 as 'RAZAO_SOCIAL',
  null                                                             as 'ENDERECO',
  null                                                          	 as 'BAIRRO',
  null                                                             as 'MUNICIPIO',
  null                                                             as 'UF',
  null                                                             as 'PAIS'

from 

Funcionario f

