
-------------------------------------------------------------------------------
--sp_helptext pr_zera_registro_inventario
-------------------------------------------------------------------------------
--pr_zera_registro_inventario
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Zera o movimento de Lançamentos Manuais de Registros
--
--Data             : 01.01.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_zera_registro_inventario
@dt_inicial datetime = '',
@dt_final   datetime = ''

as

--select * from registro_inventario

delete from
  registro_inventario
where
  isnull(ic_tipo_lancamento,'A')='M'

