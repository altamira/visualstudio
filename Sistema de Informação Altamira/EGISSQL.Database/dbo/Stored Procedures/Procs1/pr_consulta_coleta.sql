

/****** Object:  Stored Procedure dbo.pr_consulta_coleta    Script Date: 13/12/2002 15:08:17 ******/


CREATE  PROCEDURE pr_consulta_coleta
---------------------------------------------------------
--GBS - Global Business Solution	             2001
--Stored Procedure	: Microsoft SQL Server       2000
--Autor(es)		: Adriano Levy Barbosa
--Banco de Dados	: EGISSQL
--Objetivo		: Consultar as Coletas
--Data			: 03/07/2002
---------------------------------------------------
  @dt_inicial 			DateTime,
  @dt_final 			DateTime
AS

SELECT 
   co.*,
   red.nm_rede_loja as Rede,
   ban.nm_bandeira_loja as Bandeira,
   est.nm_estado as Estado
from Coleta co
Left Outer Join loja_coleta loj
on loj.cd_loja_coleta = co.cd_loja_coleta
Left Outer Join bandeira_loja ban
on Ban.cd_bandeira_loja = loj.cd_bandeira_loja
Left Outer Join rede_loja red
on red.cd_rede_loja = ban.cd_rede_loja
Left Outer Join regiao_coleta rc
on rc.cd_regiao_coleta = co.cd_regiao_coleta
Left Outer Join Estado est
on est.cd_estado = rc.cd_estado
where
   dt_coleta between @dt_inicial and @dt_final   



