
-------------------------------------------------------------------------------
--pr_cliente_sem_vendedor
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de cliente sem Vendedor
--Data             : 19.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_cliente_sem_vendedor
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

select 
  c.dt_cadastro_cliente                           as DataCadastro,
  c.cd_cliente                                    as Codigo,
  c.nm_fantasia_cliente                           as Fantasia,       
  c.nm_endereco_cliente+' ,'+c.cd_numero_endereco as Endereco,
  c.nm_bairro                                     as Bairro,
  c.cd_cep                                        as Cep,
  cid.nm_cidade                                   as Cidade,
  est.nm_estado                                   as Estado,
  pa.nm_pais                                      as Pais,
  c.nm_divisao_area                               as Divisao,
  gc.nm_cliente_grupo                             as Grupo 
from 
  Cliente c
  left outer join Cidade cid       on cid.cd_cidade       = c.cd_cidade
  left outer join Estado est       on est.cd_estado       = c.cd_estado
  left outer join Pais pa          on pa.cd_pais          = c.cd_pais
  left outer join Cliente_Grupo gc on gc.cd_cliente_grupo = c.cd_cliente_grupo
where
  isnull(c.cd_vendedor,0) = 0
order by
  c.dt_cadastro_cliente desc

