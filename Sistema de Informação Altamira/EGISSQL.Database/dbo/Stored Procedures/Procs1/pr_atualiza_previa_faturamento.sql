
CREATE PROCEDURE pr_atualiza_previa_faturamento
@cd_nota_saida as int
AS
Begin

Begin transaction

	--Atualiza a composição da prévia de faturamento com o item faturado
	update Previa_Faturamento_Composicao
	set 
		ic_fatura_previa_faturam = 'S'
	from
		Previa_Faturamento_Composicao, Nota_Saida_Item
	where 
		Previa_Faturamento_Composicao.cd_pedido_venda = Nota_Saida_Item.cd_pedido_venda and
		Previa_Faturamento_Composicao.cd_item_pedido_venda = Nota_Saida_Item.cd_item_pedido_venda and
		Nota_Saida_Item.cd_nota_saida = @cd_nota_saida
	
	--Atuliza a Prévia de faturamento após a atualização da composição
	update Previa_Faturamento
	set
		ic_fatura_previa_faturam = 'S'
	from 
		Previa_Faturamento 
	where
	  --Filtra somente as Prévias de faturamento que ainda não foram baixadas
		ic_fatura_previa_faturam <> 'S'
		and 
		--Filtra somente as prévias de faturamento que não possui composição
		exists(Select 'x' from Previa_Faturamento_Composicao 
					 where Previa_Faturamento_Composicao.cd_previa_faturamento = Previa_Faturamento.cd_previa_faturamento)
		and
		--Filtra somente as composições que não tem mais nada a ser faturado
		not exists(select 'x' from previa_faturamento_composicao 
		where previa_faturamento_composicao.cd_previa_faturamento = previa_faturamento.cd_previa_faturamento
		and ic_fatura_previa_faturam = 'N')

if @@error = 0 
  Commit transaction
else
  Rollback transaction


End

