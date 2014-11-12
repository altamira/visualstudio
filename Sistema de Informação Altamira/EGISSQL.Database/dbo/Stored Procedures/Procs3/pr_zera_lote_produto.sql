
create procedure pr_zera_lote_produto
-----------------------------------------------------------------------------------
--Global Business Solution Ltda                                                2003                     
-----------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  / 2000
--Autor (es)       : Carlos Cardoso Fernandes
--Banco Dados      : EGISSQL
--Objetivo         : Zera as Tabelas Completamente referente a Lote de Produto
--                 : 
--Data             : 11.11.2005 
--Atualizado       : 05.09.2007 - Acerto do Lote do Produto
--                 : 
-----------------------------------------------------------------------------------
--@ic_parametro int = 0,
--@dt_base      datetime = ''

--Parâmetros
--0 -> Zera a Tabela Completa
--1 -> Data Base -> Zera os registros de uma determinada Data Base

as

begin tran

  delete from lote_produto_saldo
  delete from lote_produto_item
  delete from lote_produto

  update
    consulta_itens
  set
    cd_lote_item_consulta = null

  update
    movimento_estoque
  set
    cd_lote_produto = null

  update
    pedido_venda_item
  set
    cd_lote_item_pedido = null

  update
    nota_saida_item
  set
   cd_lote_item_nota_saida = null

  delete from pedido_venda_item_lote

if @@error = 0 
   begin
     commit tran
   end
else
   begin
     raiserror ('Atenção... Não foi possível zerar as tabelas de Lote de Produto, pois ocorreram erros !',16,1)
     rollback tran
   end

