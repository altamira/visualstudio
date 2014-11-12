
-------------------------------------------------------------------------------
--pr_clientes_contribuintes_icms
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta dos Clientes Contribuintes do ICMS
--Data             : 14.04.2006
--Alteração        : 05.05.2006 - Acertos Diversos - Carlos Fernandes
------------------------------------------------------------------------------
create procedure pr_clientes_contribuintes_icms
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

 --select * from cliente

 select
   c.nm_fantasia_cliente                 as Cliente,
   isnull(c.ic_contrib_icms_cliente,'N') as Contribuinte,
   c.dt_cadastro_cliente                 as DataCadastro,
   dp.nm_destinacao_produto              as Destinacao,
   tp.nm_tipo_pessoa                     as TipoPessoa,
   tm.nm_tipo_mercado                    as TipoMercado,
   gc.nm_cliente_grupo                   as GrupoCliente
 from
   cliente c
   left outer join Destinacao_Produto dp on dp.cd_destinacao_produto = c.cd_destinacao_produto
   left outer join Tipo_Pessoa        tp on tp.cd_tipo_pessoa        = c.cd_tipo_pessoa
   left outer join Tipo_Mercado       tm on tm.cd_tipo_mercado       = c.cd_tipo_mercado
   left outer join Cliente_Grupo      gc on gc.cd_cliente_grupo      = c.cd_cliente_grupo
order by
  c.ic_contrib_icms_cliente,
  c.nm_fantasia_cliente

