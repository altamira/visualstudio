CREATE  FUNCTION fn_vl_moeda (@cd_moeda int)
RETURNS Float
AS
BEGIN

declare @vl_moeda float
set @vl_moeda = ISNull(( select top 1 vl_moeda from Valor_Moeda where cd_moeda = @cd_moeda order by dt_moeda desc),1)

  RETURN(@vl_moeda)
END

