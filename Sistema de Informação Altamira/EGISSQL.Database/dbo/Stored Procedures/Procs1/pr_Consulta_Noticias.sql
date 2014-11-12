

/****** Object:  Stored Procedure dbo.pr_Consulta_Noticias    Script Date: 13/12/2002 15:08:09 ******/

--pr_Consulta_Noticias
---------------------------------------------------
--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): Adriano Levy Barbosa
--Banco de Dados: EgisSql
--Objetivo: Realizar uma consulta das Notícias 
--Data: 17/05/2002
---------------------------------------------------

CREATE  PROCEDURE pr_Consulta_Noticias

  @dt_inicial datetime,
  @dt_final   datetime

AS

  SELECT
    nt.dt_noticia,
    nt.nm_noticia,
    nt.ds_noticia
  FROM
    Noticia nt
  WHERE
    nt.ic_ativa_noticia='S' and 
    nt.dt_noticia between @dt_inicial and @dt_final 
  ORDER BY
    nt.dt_noticia



