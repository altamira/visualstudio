
-------------------------------------------------------------------------------
--pr_contagem_produtos_loja
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : André Seolin Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : Dados para tela de Contagem de Produtos
--Data             : 20/06/2005
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_contagem_produtos_loja
@cd_loja int,
@cd_grupo_produto int

as 
Select 
  gp.cd_grupo_produto,
  l.cd_loja,
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
Where 
  IsNull(l.cd_loja,0) = 
  case 
   When isnull(@cd_loja,0) = 0 then 
    IsNull(l.cd_loja,0) 
   else 
    @cd_loja 
   end

   and

  IsNull(gp.cd_grupo_produto,0) = 
  case 
   When isnull(@cd_grupo_produto,0) = 0 then 
    IsNull(gp.cd_grupo_produto,0) 
   else 
    @cd_grupo_produto
   end
Order By 
  P.nm_fantasia_produto

