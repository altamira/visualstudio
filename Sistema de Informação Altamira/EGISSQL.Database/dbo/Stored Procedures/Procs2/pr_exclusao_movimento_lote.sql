
-------------------------------------------------------------------------------
--pr_exclusao_lote
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : rafael Santiago
--Banco de Dados   : Egissql
--Objetivo         : Excluir o movimento do Lote no momento de se escluir uma nota de entrada.
--Data             : 08/09/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_exclusao_movimento_lote

@nm_lote_produto as varchar(40)

as

declare 
  @cd_lote_produto integer

select @cd_lote_produto = cd_lote_produto from Lote_Produto where nm_lote_produto = @nm_lote_produto

delete from 
  Lote_Produto_item 
where 
  cd_lote_produto = @cd_lote_produto

delete from 
  lote_produto_saldo 
where 
  cd_lote_produto = @cd_lote_produto

delete from
  lote_produto 
where 
  cd_lote_produto = @cd_lote_produto


