
---------------------------------------------------------------------------------------
--fn_limpa_acentos_caracteres
---------------------------------------------------------------------------------------
--GBS - Global Business Solution	                                          2009
---------------------------------------------------------------------------------------
--Stored Procedure	: Microsoft SQL Server 2000
--Autor(es)		: Douglas de Paula Lopes
--Banco de Dados	: EGISSQL
--Objetivo		: 
--
--Data			: 09.04.2009
--Atualização           : 
---------------------------------------------------------------------------------------

create FUNCTION fn_limpa_acentos_caracteres
(@tira_acento varchar(100))

RETURNS varchar(100)

as

begin

  Declare @v varchar(20), @vv varchar(20)
  set @v = @tira_acento
  set @v = @v

--Remove Acentos ----------------------------------------- 	

  set @v = replace(@v,'Á','A') 
  set @v = replace(@v,'À','A') 
  set @v = replace(@v,'Ã','A') 
  set @v = replace(@v,'Â','A') 
  set @v = replace(@v,'Ä','A') 	
  set @v = replace(@v,'É','E')
  set @v = replace(@v,'È','E')
  set @v = replace(@v,'Ê','E')
  set @v = replace(@v,'Ë','E')	
  set @v = replace(@v,'Í','I')
  set @v = replace(@v,'Ì','I') 
  set @v = replace(@v,'Î','I')
  set @v = replace(@v,'Ï','I')	
  set @v = replace(@v,'Ó','O')
  set @v = replace(@v,'Ò','O')
  set @v = replace(@v,'Õ','O')
  set @v = replace(@v,'Ô','O')
  set @v = replace(@v,'Ö','O')	
  set @v = replace(@v,'Ú','U')
  set @v = replace(@v,'Ù','U')
  set @v = replace(@v,'Û','U')
  set @v = replace(@v,'Ü','U')		
  set @v = replace(@v,'Ç','C')
  set @v = replace(@v,'Ñ','N')

  set @v = replace(@v,'á','a') 
  set @v = replace(@v,'à','a') 
  set @v = replace(@v,'ã','a') 
  set @v = replace(@v,'â','a') 
  set @v = replace(@v,'ä','a') 	
  set @v = replace(@v,'é','e')
  set @v = replace(@v,'è','e')
  set @v = replace(@v,'ê','e')
  set @v = replace(@v,'ë','e')	
  set @v = replace(@v,'í','i')
  set @v = replace(@v,'ì','i') 
  set @v = replace(@v,'î','i')
  set @v = replace(@v,'ï','i')	
  set @v = replace(@v,'ó','o')
  set @v = replace(@v,'ò','o')
  set @v = replace(@v,'õ','o')
  set @v = replace(@v,'ô','o')
  set @v = replace(@v,'ö','o')	
  set @v = replace(@v,'ú','u')
  set @v = replace(@v,'ù','u')
  set @v = replace(@v,'û','u')
  set @v = replace(@v,'ü','u')		
  set @v = replace(@v,'ç','c')
  set @v = replace(@v,'ñ','n')

--Limpa Caracteres Especiais ----------------------------
 
declare @i int 
set @i = 1

while @i <= len(rtrim(ltrim(@v))) 
begin
   if (substring(rtrim(ltrim(@v)), @i, 1)) not in ('/','\','<','>','-','.','|','A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','X','Y','W','Z','0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h','i','j','k','l','m','n','o','p','q','r','s','t','u','v','x','y','w','z')
   begin
     set @v = replace(@v,substring(rtrim(ltrim(@v)), @i, 1),' ')
   end

   set @i = @i + 1   
end 	

return(rtrim(ltrim(@v)))

end

---------------------------------------------------------------------------------------
-- Example to execute function
---------------------------------------------------------------------------------------
--SELECT dbo.fn_limpa_acentos_caracteres('Andrêa')
---------------------------------------------------------------------------------------

