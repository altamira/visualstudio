
CREATE PROCEDURE pr_exclusao_total_orcamento

@cd_consulta           int,
@cd_item_consulta      int,
@cd_parametro          int  -- 1=Exclusão dos Serviços / 2=Exclusão Total (Serviços+Placas)

as

  delete from Consulta_Item_Orcamento_Bucha_Coluna
  where cd_consulta = @cd_consulta and
        cd_item_consulta = @cd_item_consulta

  delete from Consulta_Item_Orcamento_Cat
  where cd_consulta = @cd_consulta and
        cd_item_consulta = @cd_item_consulta

  delete from Consulta_Item_Orcamento_Refrigeracao
  where cd_consulta = @cd_consulta and
        cd_item_consulta = @cd_item_consulta

  delete from Consulta_Item_Orcamento_Alojamento
  where cd_consulta = @cd_consulta and
        cd_item_consulta = @cd_item_consulta

  delete from Consulta_Item_Servico_Externo
  where cd_consulta = @cd_consulta and
        cd_item_consulta = @cd_item_consulta

  delete from Consulta_Item_Orcamento_Servico_Manual
  where cd_consulta = @cd_consulta and
        cd_item_consulta = @cd_item_consulta

  delete from Consulta_Item_Orcamento_Furo_Adicional
  where cd_consulta = @cd_consulta and
        cd_item_consulta = @cd_item_consulta

  delete from Consulta_Item_Orcamento_Furo
  where cd_consulta = @cd_consulta and
        cd_item_consulta = @cd_item_consulta

  if @cd_parametro = 2 
  begin

     delete from Consulta_Item_Componente
     where cd_consulta = @cd_consulta and
           cd_item_consulta = @cd_item_consulta

     delete from Consulta_Item_Orcamento
     where cd_consulta = @cd_consulta and
           cd_item_consulta = @cd_item_consulta

  end
       
