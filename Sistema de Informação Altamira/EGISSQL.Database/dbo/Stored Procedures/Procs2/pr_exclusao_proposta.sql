
CREATE PROCEDURE pr_exclusao_proposta

@ic_parametro integer,
@cd_consulta Integer


AS

 if @ic_parametro = 1
   delete from Consulta_Caract_Tecnica_Cq where cd_consulta = @cd_consulta

 else if @ic_parametro = 2
  delete from Consulta_Cond_Pagto where cd_consulta = @cd_consulta

 else if @ic_parametro = 3
  delete from Consulta_Item_Observacao where cd_consulta = @cd_consulta

 else if @ic_parametro = 4
  delete from Consulta_Item_Orcamento where cd_consulta = @cd_consulta

 else if @ic_parametro = 5
  delete from Consulta_Item_Orcamento_Cat where cd_consulta = @cd_consulta

 else if @ic_parametro = 6
  delete from Consulta_Item_Perda where cd_consulta = @cd_consulta

 else if @ic_parametro = 7
  delete from Consulta_Itens_Acessorio where cd_consulta = @cd_consulta

 else if @ic_parametro = 8
  delete from Consulta_Itens_Desconto where cd_consulta = @cd_consulta

 else if @ic_parametro = 9
  delete from Consulta_Itens_Grade where cd_consulta = @cd_consulta

 else if @ic_parametro = 10
  delete from Consulta_Itens where cd_consulta = @cd_consulta

 else if @ic_parametro = 11
  delete from Consulta where cd_consulta = @cd_consulta

 else if @ic_parametro = 12
  delete from Consulta_Documento where cd_consulta = @cd_consulta

 else if @ic_parametro = 13
  delete from Consulta_Item_Orcamento_Servico_Manual where cd_consulta = @cd_consulta

 else if @ic_parametro = 14
  delete from Consulta_Item_Orcamento_Refrigeracao where cd_consulta = @cd_consulta

 else if @ic_parametro = 15
  delete from Consulta_Negociacao where cd_consulta = @cd_consulta

 else if @ic_parametro = 16
  delete from Consulta_Item_Componente where cd_consulta = @cd_consulta

 else if @ic_parametro = 17
  delete from Consulta_Parcela where cd_consulta = @cd_consulta
  
 else if @ic_parametro = 18
  delete from Consulta_Item_Orcamento_Furo where cd_consulta = @cd_consulta

 else if @ic_parametro = 19
  delete from Consulta_Item_Orcamento_Furo_Adicional where cd_consulta = @cd_consulta

 else if @ic_parametro = 20
  delete from Consulta_Item_Composicao where cd_consulta = @cd_consulta

 else if @ic_parametro = 21
  delete from Consulta_Item_Orcamento_Alojamento where cd_consulta = @cd_consulta

 else if @ic_parametro = 22
  delete from Consulta_Item_Servico_Externo where cd_consulta = @cd_consulta

 else if @ic_parametro = 23
  delete from Consulta_Item_Orcamento_Bucha where cd_consulta = @cd_consulta

 else if @ic_parametro = 24
  delete from Consulta_Item_Embalagem where cd_consulta = @cd_consulta

 else if @ic_parametro = 25
  delete from Consulta_Itens_Acessorio where cd_consulta = @cd_consulta

 else if @ic_parametro = 26
  delete from Consulta_Item_Orcamento_Bucha_Coluna where cd_consulta = @cd_consulta

 else if @ic_parametro = 27
  delete from Consulta_Item_Texto where cd_consulta = @cd_consulta

 else if @ic_parametro = 28
  delete from Consulta_Contato where cd_consulta = @cd_consulta

