
-------------------------------------------------------------------------------
--sp_helptext pr_exclusao_bordero_desconto
-------------------------------------------------------------------------------
--pr_exclusao_bordero_desconto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--
--Objetivo         : Exclusão Total de Borderô de Desconto
--
--Data             : 10.11.2009
--Alteração        : 10.11.2009 - Ajustes Diversos - Carlos Fernandes
--
--
------------------------------------------------------------------------------
create procedure pr_exclusao_bordero_desconto
@cd_bordero_desconto int      = 0

as

if @cd_bordero_desconto>0 
begin

  --Volta o Portador para 999 --> CARTEIRA

  update
    documento_receber
  set
    cd_portador = 999  
  from
    documento_receber d
    inner join documento_receber_desconto dd on dd.cd_documento_receber = d.cd_documento_receber 

  where 
    dd.cd_bordero_desconto = @cd_bordero_desconto  

  --Delete a Tabela Auxiliar

  delete from documento_receber_selecao
  where
    cd_documento_receber in ( select cd_documento_receber from documento_receber_desconto
                              where
                                cd_bordero_desconto = @cd_bordero_desconto )

  --Deleta os documentos de Desconto

  delete from documento_receber_desconto where cd_bordero_desconto = @cd_bordero_desconto

  --select * from documento_receber_selecao

  --Deleta o Bordero

  delete from bordero_desconto where cd_bordero_desconto = @cd_bordero_desconto

 
end

