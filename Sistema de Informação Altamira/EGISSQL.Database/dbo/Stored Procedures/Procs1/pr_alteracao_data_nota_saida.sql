
-------------------------------------------------------------------------------
--pr_alteracao_data_nota_saida
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Alteração da Data de Saída da Nota Fiscal
--Data             : 10.01.2005
--Atualizado       
--------------------------------------------------------------------------------------------------
create procedure pr_alteracao_data_nota_saida
@cd_nota_saida int,
@dt_nota_saida datetime,
@cd_usuario    int

as


--select * from nota_saida
--select * from nota_saida_item
--select * from nota_saida_registro
--select * from nota_saida_item_registro

-- Nota Saída

update
  Nota_Saida
set
  dt_nota_saida = @dt_nota_saida,
  cd_usuario    = @cd_usuario,
  dt_usuario    = getdate()
where
  @cd_nota_saida = cd_nota_saida

--Item da Nota de Saída
 
update
  Nota_Saida_Item
set
  dt_nota_saida = @dt_nota_saida,
  cd_usuario    = @cd_usuario,
  dt_usuario    = getdate()
where
  @cd_nota_saida = cd_nota_saida

--Item da Nota de Registro Fiscal da Nota de Saída

update
  Nota_Saida_Item_Registro
set
  dt_nota_saida = @dt_nota_saida,
  cd_usuario    = @cd_usuario,
  dt_usuario    = getdate()
where
  @cd_nota_saida = cd_nota_saida

