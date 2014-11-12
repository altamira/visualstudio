
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Formulário para geração Requisição/Pedido
--Data             : 21/06/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_formulario_geracao_pedido_produto
as 

Select 
  P.cd_produto, 
  P.nm_Produto, 
  P.nm_fantasia_produto, 
  GP.nm_grupo_produto, 
  PS.qt_saldo_atual_produto, 
  L.nm_loja, 
  UM.sg_Unidade_medida
From 
  Produto P
  left join Grupo_Produto GP on P.cd_grupo_produto = GP.cd_grupo_produto
  left join Produto_Saldo PS on P.cd_produto = PS.cd_Produto and PS.cd_fase_produto = 3
  left join Loja L on PS.cd_loja = L.cd_loja
  left join Unidade_medida UM on P.cd_Unidade_Medida = UM.cd_Unidade_Medida 
Order By 
  P.nm_fantasia_produto

