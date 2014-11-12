
-------------------------------------------------------------------------------
--pr_numeracao_nota_saida
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda               2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Márcio Rodrigues
--Banco de Dados   :  Egissql
--Objetivo         : Mudar o código da nota fiscal.. colocando o ano na frente
--Data             : 22/08/2006
--Alteração        : 18.02.2010 - Revisão
------------------------------------------------------------------------------
create procedure pr_numeracao_nota_saida
 	@dt_inicio Datetime = Null,
 	@dt_fim    DateTime = Null
as

	Declare @cd_range_nota_saida int
 
------------------------------------------------------------------------------
--Colocar a Numeração de Nota
------------------------------------------------------------------------------
--Alterar o número aqui manualmente

	Set @cd_range_nota_saida = 09000000  --> Todos os números serão modificados

	Declare @cd_nota_saida int

   Print 'Seleção'
	
-- 	Select
--           ns.cd_nota_saida
-- 	Into #Nota_Saida
-- 	From Nota_Saida ns with (nolock) 
--         where
--           dt_nota_saida between @dt_inicio and @dt_fim

-- 	Where 1 = (case	when isnull(@dt_inicio,'') ='' then
-- 								1
-- 						  	when (dt_nota_saida >= @dt_inicio) and (dt_nota_saida <= @dt_fim) then
-- 								1
-- 						  	else 
-- 								0	 
-- 				end)


	Select
          ns.cd_nota_saida
	Into #Nota_Saida
	From Nota_Saida ns with (nolock) 
        where
          dt_nota_saida between @dt_inicio and @dt_fim and
          len(cast(cd_nota_saida as varchar(7)) ) <7



   select * from #Nota_saida order by cd_nota_saida

   Print 'Retira Fk'

	ALTER TABLE [Nota_Saida_Imposto]		NOCHECK CONSTRAINT [FK_Nota_Saida_Imposto_Nota_Saida]
	ALTER TABLE [Centro_Receita_Nota_Saida] 	NOCHECK CONSTRAINT [FK_Centro_Receita_Nota_Saida_Departamento]
	--ALTER TABLE [Nota_Saida_Item_Lote]		NOCHECK CONSTRAINT [FK_Nota_Saida_Item_Lote_Laudo]
	ALTER TABLE [Centro_Receita_Nota_Saida] 	NOCHECK CONSTRAINT [FK_Centro_Receita_Nota_Saida_Centro_Receita]
	ALTER TABLE [Entregador_Nota_Saida] 		NOCHECK CONSTRAINT [FK_Entregador_Nota_Saida_Entregador]
	ALTER TABLE [Nota_Saida_Entrega] 		NOCHECK CONSTRAINT [FK_Nota_Saida_Entrega_Nota_Saida]
	ALTER TABLE [Nota_Saida_Recibo] 		NOCHECK CONSTRAINT [FK_Nota_Saida_Recibo_Nota_Saida]

   Print 'Inicio While' 

	while exists(Select top 1 * from #nota_saida)
	begin
          select top 1 @cd_nota_saida = cd_nota_saida from #Nota_Saida	

          if @cd_range_nota_saida > @cd_nota_saida
         begin
					Begin Tran

               Print 'UpDate cd_nota_saida =' + Isnull(Cast(@cd_range_nota_saida + @cd_nota_saida as varchar(20)), '')

               update Nota_Saida set
                       cd_nota_saida   		        = @cd_range_nota_saida + cd_nota_saida,
                       cd_identificacao_nota_saida 	= @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               Print 'Itens'
               update Nota_Saida_Item set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               Print 'Recibo NFE'
               update Nota_Saida_Recibo set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Saida_Complemento set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Saida_Cond_Pagto set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Saida_Contabil set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Saida_Credito set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Saida_Devolucao set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Saida_Endereco_Entrega set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Saida_Entrega set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Saida_Imposto set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Saida_Item_Devolucao set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Saida_Item_Lote set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Saida_Item_Registro set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Credito_Item set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Saida_Parcela set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nota_Saida_Registro set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Nt_Duplicata set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update NTSaidaDuplicata set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Numero_Serie_Equipamento set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Ocorrencia  set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Saida_Nota_Saida_Item set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Documento_Receber set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida,
							  cd_identificacao = @cd_range_nota_saida + cd_nota_saida	
               where cd_nota_saida = @cd_nota_saida

--                update Nota_Promissoria set
--                        cd_identificacao_nota = @cd_range_nota_saida + cd_identificacao_nota
--                where cd_identificacao_nota = @cd_nota_saida

               update Nota_Saida set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Boletim_Analise_Nota_Saida set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Carta_Correcao set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Centro_Receita_Nota_Saida set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Comissao set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Contrato_Servico_Composicao set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Documento_Pagar set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Lote_Produto_Saida set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Movimento_Caixa set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

               update Movimento_Produto_Terceiro set
                       cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
               where cd_nota_saida = @cd_nota_saida

--                update Movimento_Venda set
--                        cd_nota_saida = @cd_range_nota_saida + cd_nota_saida
--                where cd_nota_saida = @cd_nota_saida

               if @@ERROR <> 0
					begin
                  	Rollback Tran							
							RAISERROR ('Ocorreu erros no procedimento', 16, 1)
					end
               else
					begin	
                     Commit Tran
							RAISERROR ('Concluído com sucesso', 16, 1)
					end
         end
         Delete from #Nota_Saida where cd_nota_saida = @cd_nota_saida
	end   

	ALTER TABLE [Nota_Saida_Imposto] 		CHECK CONSTRAINT [FK_Nota_Saida_Imposto_Nota_Saida]
	ALTER TABLE [Centro_Receita_Nota_Saida] 	CHECK CONSTRAINT [FK_Centro_Receita_Nota_Saida_Departamento]
--	ALTER TABLE [Nota_Saida_Item_Lote] 		CHECK CONSTRAINT [FK_Nota_Saida_Item_Lote_Laudo]
	ALTER TABLE [Centro_Receita_Nota_Saida] 	CHECK CONSTRAINT [FK_Centro_Receita_Nota_Saida_Centro_Receita]
	ALTER TABLE [Entregador_Nota_Saida] 		CHECK CONSTRAINT [FK_Entregador_Nota_Saida_Entregador]
	ALTER TABLE [Nota_Saida_Entrega] 		CHECK CONSTRAINT [FK_Nota_Saida_Entrega_Nota_Saida]
	ALTER TABLE [Nota_Saida_Recibo] 		CHECK CONSTRAINT [FK_Nota_Saida_Recibo_Nota_Saida]

drop table #nota_saida

--FK_Nota_Saida_Recibo_Nota_Saida
	
