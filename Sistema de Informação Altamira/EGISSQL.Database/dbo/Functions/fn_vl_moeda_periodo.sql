Create FUNCTION fn_vl_moeda_periodo (@cd_moeda int, @dt_moeda datetime)
---------------------------------------------------
--GBS - Global Business Sollution              2004
--Stored Procedure: Microsoft SQL Server       2004
--Banco de Dados: Sql Server 2000
--Autor: Igor Augusto C. Gama
--Data: 08.03.2004
--Objetivo: Listar dados necessários para efetuar a análise de preços
---------------------------------------------------
RETURNS Float
AS
BEGIN

  declare @vl_moeda float
  set @vl_moeda = ISNull(( select top 1 vl_moeda from Valor_Moeda where cd_moeda = @cd_moeda and dt_moeda <= @dt_moeda order by dt_moeda desc),1)

  RETURN(@vl_moeda)
END
