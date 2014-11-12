
-------------------------------------------------------------------------------
--pr_gera_ciap_automaticamente
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 27/01/2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_gera_ciap_automaticamente
  @dt_data datetime
AS

DECLARE @cd_bem int
DECLARE Bem_Cursor CURSOR FOR

Select
  cd_bem 
From
  Bem
where
  cd_bem not in (
    select cd_bem from ciap
  )

OPEN Bem_Cursor

FETCH NEXT FROM Bem_cursor
INTO @cd_bem

-- Check @@FETCH_STATUS to see if there are any more rows to fetch.
WHILE @@FETCH_STATUS = 0
BEGIN

   exec pr_gera_ciap_bem @cd_bem, @dt_data

   -- This is executed as long as the previous fetch succeeds.
   FETCH NEXT FROM Bem_Cursor
   INTO @cd_bem
END

CLOSE Bem_Cursor

DEALLOCATE Bem_Cursor

