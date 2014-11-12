
-------------------------------------------------------------------------------
--pr_modificao_automatica_categoria_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Modificação automática de Categoria de Produto
--                   Quando houver necessidade do usuário modificar em :
--                   Grupo Produto / Produto / Pedido de Venda e Nota Fiscal
--
--Data             : 15.04.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_modificao_automatica_categoria_produto
@cd_categoria_produto_anterior int = 0,
@cd_categoria_produto_atual    int = 0

as

if @cd_categoria_produto_anterior > 0 and
   @cd_categoria_produto_atual > 0

begin

--Grupo de Produto

update
  grupo_produto
set
  cd_categoria_produto = @cd_categoria_produto_atual
where
  cd_categoria_produto = @cd_categoria_produto_anterior

--Produto

update
  produto
set
  cd_categoria_produto = @cd_categoria_produto_atual
where
  cd_categoria_produto = @cd_categoria_produto_anterior

--Serviço

update
  Servico
set
  cd_categoria_produto = @cd_categoria_produto_atual
where
  cd_categoria_produto = @cd_categoria_produto_anterior

--Plano de Compras

update
  plano_compra
set
  cd_categoria_produto = @cd_categoria_produto_atual
where
  cd_categoria_produto = @cd_categoria_produto_anterior


--Itens da Consulta

update
  consulta_itens
set
  cd_categoria_produto = @cd_categoria_produto_atual
where
  cd_categoria_produto = @cd_categoria_produto_anterior


--Itens do Pedido de Venda
  
update
  pedido_venda_item
set
  cd_categoria_produto = @cd_categoria_produto_atual
where
  cd_categoria_produto = @cd_categoria_produto_anterior

--Itens da Nota Fiscal

update
  nota_saida_item
set
  cd_categoria_produto = @cd_categoria_produto_atual
where
  cd_categoria_produto = @cd_categoria_produto_anterior


--Itens da Requisição de Faturamento

update
  requisicao_faturamento_item
set
  cd_categoria_produto = @cd_categoria_produto_atual
where
  cd_categoria_produto = @cd_categoria_produto_anterior

--Itens da Requisição de Compra

update
  requisicao_compra_item
set
  cd_categoria_produto = @cd_categoria_produto_atual
where
  cd_categoria_produto = @cd_categoria_produto_anterior


--Itens do Pedido de Compra

update
  pedido_compra_item
set
  cd_categoria_produto = @cd_categoria_produto_atual
where
  cd_categoria_produto = @cd_categoria_produto_anterior

--Previsao de Vendas

update
  previsao_venda
set
  cd_categoria_produto = @cd_categoria_produto_atual
where
  cd_categoria_produto = @cd_categoria_produto_anterior


end

