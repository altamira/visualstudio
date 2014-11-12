
CREATE FUNCTION fn_formata_telefone
(@telefone varchar(10))        
RETURNS varchar(11)

AS
BEGIN

  declare @prefixo varchar(5)
  declare @numero  varchar(5)
  declare @separador char(1)
  declare @tamnumero int

  set @separador = '-'
  set @tamnumero = 4

  set @prefixo = substring(@telefone,1,len(@telefone)-@tamnumero)
  set @numero = substring(@telefone,len(@telefone)-@tamnumero+1,@tamnumero)
  return(@prefixo+@separador+@numero)  

END
