
CREATE   PROCEDURE pr_excluir_movimento_estoque_nf
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)      : Fabio Cesar 
--Banco de Dados : Egissql
--Objetivo       : Exclui os movimentos de estoque da nota fiscal definida
--Data           : 18.06.2003
--Atualizacao    : 25.06/2003 - Exclusão da Composição dos Produtos Especiais
-------------------------------------------------------------

@cd_nota_saida int = 0,
@cd_item_nota_saida int = 0

AS

-- ============================================================
-- Seleciona todos os itens da nota fiscal em questão
-- ============================================================
  select ns.cd_identificacao_nota_saida,
         nsi.*
  into #ItemNota 
  from Nota_Saida ns             with (nolock) 
  inner join Nota_Saida_Item nsi with (nolock) on ns.cd_nota_saida = nsi.cd_nota_saida
  inner join Operacao_Fiscal op  with (nolock) on ns.cd_operacao_fiscal = op.cd_operacao_fiscal
  where
    ns.cd_nota_saida = @cd_nota_saida and
    (
    ((nsi.cd_item_nota_saida = @cd_item_nota_saida) and (@cd_item_nota_saida > 0))
    or
    (@cd_item_nota_saida = 0)
    )

  --Exclui o item do movimento

  Delete Movimento_Estoque from movimento_estoque, #ItemNota 
  where 
    cast(movimento_estoque.cd_documento_movimento as varchar(30)) = #ItemNota.cd_identificacao_nota_saida
    and movimento_estoque.cd_item_documento = #ItemNota.cd_item_nota_saida
    and cd_tipo_documento_estoque = 4
    and cd_tipo_movimento_estoque in (10, 11, 12, 13)

  drop table #ItemNota

