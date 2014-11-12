
-------------------------------------------------------------------------------
--pr_consulta_cliente_sem_definicao_conceito
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta dos Clientes sem Definição de Conceito
--Data             : 05.06.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_consulta_cliente_sem_definicao_conceito
@dt_inicial datetime,
@dt_final   datetime
as
   --select * from estado
   --select * from cliente

   select
     c.nm_fantasia_cliente      as Fantasia,
     c.nm_razao_social_cliente  as Cliente,
    sc.nm_status_cliente        as Status,
     c.dt_cadastro_cliente      as DataCadastro,
     v.nm_fantasia_vendedor     as Vendedor,  
    tp.nm_tipo_pessoa           as Pessoa,
    tm.nm_tipo_mercado          as Mercado,
     p.nm_pais                  as Pais,
     e.sg_estado                as UF
   from
     cliente c
     left outer join status_cliente sc on sc.cd_status_cliente = c.cd_status_cliente
     left outer join vendedor       v  on v.cd_vendedor        = c.cd_vendedor
     left outer join tipo_pessoa    tp on tp.cd_tipo_pessoa    = c.cd_tipo_pessoa
     left outer join tipo_mercado   tm on tm.cd_tipo_mercado   = c.cd_tipo_mercado
     left outer join Pais           p  on p.cd_pais            = c.cd_pais
     left outer join Estado         e  on e.cd_estado          = c.cd_estado and
                                          e.cd_pais            = c.cd_pais
   where
     isnull(c.cd_conceito_cliente,0) = 0

   order by
     c.nm_fantasia_cliente
