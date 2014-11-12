
-------------------------------------------------------------------------------
--pr_consulta_pesquisa_credito_vencida
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Pesquisa de Crédito Vencida
--Data             : 13.07.2006
--Alteração        : 13.07.2006
------------------------------------------------------------------------------
create procedure pr_consulta_pesquisa_credito_vencida
@dt_inicial datetime = '',
@dt_final   datetime = ''
as

--select * from cliente

select
  c.nm_fantasia_cliente        as Cliente,
  c.cd_ddd+'-'+c.cd_telefone   as Fone,
  ci.dt_orgao_credito          as DataPesquisa,
  oc.nm_orgao_credito          as Orgao,
  ci.dt_validade_orgao_credito as Validade,
  dias = datediff(day,ci.dt_validade_orgao_credito,getdate() ),
  c.dt_cadastro_cliente        as DataCadastro,
  v.nm_fantasia_vendedor       as Vendedor
from
  Cliente c
  inner join Cliente_Informacao_Credito ci on ci.cd_cliente         = c.cd_cliente
  left outer join Orgao_Credito oc         on oc.cd_orgao_credito   = ci.cd_orgao_credito
  left outer join Vendedor v               on v.cd_vendedor         = c.cd_vendedor 
where
  ci.dt_validade_orgao_credito is not null and
  ci.dt_validade_orgao_credito < getdate()
order by
  ci.dt_validade_orgao_credito,
  c.nm_fantasia_cliente

--select * from cliente_informacao_credito

