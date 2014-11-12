
CREATE PROCEDURE pr_atualiza_documento_receber_caixa
@cd_movimento_caixa int

as

Declare @cd_pedido_venda int
Declare @cd_nota_saida int
Declare @cd_ident_parc_nota_saida VarChar(25)
Declare @cd_parcela_caixa int
Declare @pc_adm_cartao_credito Float
Declare @dt_vencto_parcela_caixa DateTime

--Set @cd_movimento_caixa = 177

select mcp.cd_parcela_caixa,
       mcp.dt_vencto_parcela_caixa, 
       tpc.pc_adm_cartao_credito,
       mce.cd_pedido_venda
Into #MovimentoCaixaParcela
from movimento_caixa_parcela mcp
     left outer join tipo_pagamento_caixa tpc on tpc.cd_tipo_pagamento = mcp.cd_tipo_pagamento
     left outer join movimento_caixa_pedido mce on mce.cd_contador_pedido = mcp.cd_contador_pedido and
                                                   mce.cd_movimento_caixa = mcp.cd_movimento_caixa
where mcp.cd_movimento_caixa = @cd_movimento_caixa

While Exists(Select cd_parcela_caixa from #MovimentoCaixaParcela)
Begin
  Select Top 1 @cd_pedido_venda = cd_pedido_venda,
               @cd_parcela_caixa = cd_parcela_caixa,
               @pc_adm_cartao_credito = pc_adm_cartao_credito,
               @dt_vencto_parcela_caixa = dt_vencto_parcela_caixa
  From #MovimentoCaixaParcela

  select Top 1 @cd_nota_saida = cd_nota_saida
  from nota_saida_item
  where cd_pedido_venda = @cd_pedido_venda

  select @cd_ident_parc_nota_saida = cd_ident_parc_nota_saida
  from nota_saida_parcela
  where cd_nota_saida = @cd_nota_saida and
        cd_parcela_nota_saida = @cd_parcela_caixa

  Update Nota_Saida_Parcela set dt_parcela_nota_saida = @dt_vencto_parcela_caixa
  where cd_nota_saida = @cd_nota_saida and
        cd_parcela_nota_saida = @cd_parcela_caixa

  Update Documento_Receber set dt_vencimento_documento = @dt_vencto_parcela_caixa,
                               dt_vencimento_original = @dt_vencto_parcela_caixa,
                               vl_abatimento_documento = (vl_documento_receber * @pc_adm_cartao_credito) / 100
  where cd_identificacao = @cd_ident_parc_nota_saida

  Delete From #MovimentoCaixaParcela
  Where cd_pedido_venda = @cd_pedido_venda and 
        cd_parcela_caixa = @cd_parcela_caixa
End

