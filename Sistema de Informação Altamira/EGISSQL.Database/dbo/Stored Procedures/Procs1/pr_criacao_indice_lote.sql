
-------------------------------------------------------------------------------
--sp_helptext pr_criacao_indice_lote
-------------------------------------------------------------------------------
--pr_criacao_indice_lote
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Criação de Índice
--Data             : 27.12.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_criacao_indice_lote
as

DROP INDEX lote_produto.ix_lote_produto

CREATE INDEX ix_lote_produto
   ON lote_produto (nm_ref_lote_produto)

