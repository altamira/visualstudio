
-------------------------------------------------------------------------------
--pr_calculo_hora_real_projeto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : 
--Data             : 18/02/2005
--Atualizado       : 18/02/2005
--------------------------------------------------------------------------------------------------
create procedure pr_calculo_hora_real_projeto
@cd_projeto int

as

declare @qt_hora_projeto float

set @qt_hora_projeto = 0

--Soma das horas de Projeto

select 
  @qt_hora_projeto = sum( isnull(qt_hora_projeto,0) )
from
  Projeto_Apontamento
where
  cd_projeto = @cd_projeto

--Atualização das Horas

update
  Projeto
set
  qt_hora_real_projeto = @qt_hora_projeto
where
  cd_projeto = @cd_projeto



--select * from projeto
--select * from projeto_apontamento
  


