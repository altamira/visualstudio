CREATE FUNCTION fn_formata_cnpj
(@cnpj varchar(18))        
RETURNS varchar(18)


AS
BEGIN

  declare @cnpj_formatado varchar(18)
  declare @len int

  -- limpa a máscara do cnpj caso houver
  set @cnpj_formatado = replace(replace(replace(@cnpj,'.',''),'/',''),'-','')
  set @len = 14-len(@cnpj_formatado)

  set @cnpj_formatado = replicate('0',@len)+rtrim(@cnpj_formatado)

  set @cnpj_formatado = (substring(@cnpj_formatado,1,2)+'.'+
                         substring(@cnpj_formatado,3,3)+'.'+
	   		 substring(@cnpj_formatado,6,3)+'/'+
                         substring(@cnpj_formatado,9,4)+'-'+
                         substring(@cnpj_formatado,13,2))

  return(@cnpj_formatado)  

END


