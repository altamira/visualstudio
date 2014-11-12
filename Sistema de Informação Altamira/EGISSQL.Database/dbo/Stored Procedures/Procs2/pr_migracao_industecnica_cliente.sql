
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
create procedure pr_migracao_industecnica_cliente
as

--select * from KIN.dbo.inemp_certa
--select * from egissql.dbo.fornecedor_endereco
--select * from egissql.dbo.cliente
--select * from egissql_industecnica.dbo.cliente

select
  identity(int,1,1) as cd_cliente,
  apel              as nm_fantasia_cliente,
  razao             as nm_razao_social_cliente
into
  #cliente
from
  inemp_certa
where
  tipo='A' or tipo='C'

select * from #cliente
order by cd_cliente

--delete from cliente_endereco
--delete from cliente

insert into
  egissql_industecnica.dbo.cliente
  ( 
  cd_cliente,
  nm_fantasia_cliente,
  nm_razao_social_cliente )

select
  cd_cliente,
  nm_fantasia_cliente,
  nm_razao_social_cliente
from
  #cliente 


