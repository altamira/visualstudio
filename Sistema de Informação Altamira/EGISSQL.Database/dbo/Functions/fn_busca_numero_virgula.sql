
---------------------------------------------------------------------------------------
--fn_busca_numero_virgula
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

create FUNCTION fn_busca_numero_virgula
(@string varchar(100))

RETURNS varchar(100)

as

begin

declare @i int 
set @i = 1


while @i <= len(ltrim(rtrim(@string))) 
begin

  if substring(ltrim(rtrim(@string)),@i,1) in (',','0','1','2','3','4','5','6','7','8','9')
  begin

    if substring(ltrim(rtrim(@string)),@i,1) = ',' 
    begin
      set @string = rtrim(ltrim(substring(ltrim(rtrim(@string)),@i+1,len(ltrim(rtrim(@string))))))
      goto Sair           
    end

    set @string = substring(ltrim(rtrim(@string)),@i,len(ltrim(rtrim(@string))))
    goto Sair     
  end

set @i = @i + 1
end

Sair:

return(rtrim(ltrim(@string)))

end

---------------------------------------------------------------------------------------
-- Example to execute function
---------------------------------------------------------------------------------------
--SELECT dbo.fn_busca_numero_virgula('Rua Jonio, 546')
---------------------------------------------------------------------------------------

