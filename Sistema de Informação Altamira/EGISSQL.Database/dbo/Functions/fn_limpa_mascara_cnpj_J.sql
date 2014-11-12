
create function fn_limpa_mascara_cnpj_J  
(@cnpj varchar(8000))  
  
returns varchar(8000)  
  
as  
  
begin  
   
declare @i int   
set @i = 1  
  
if @cnpj is null  
begin  
  set @cnpj = '00000000000000'  
  goto Sair  
end  
   
while @i <= len(rtrim(ltrim(@cnpj)))   
begin  
   if (substring(rtrim(ltrim(@cnpj)), @i, 1)) not in ('0','1','2','3','4','5','6','7','8','9')  
   begin  
     set @cnpj = replace(@cnpj,substring(rtrim(ltrim(@cnpj)), @i, 1),' ') -- Se o caracter não estiver contido no conjunto acima, substitui o mesmo por <Espaço>  
   end  
  
   set @i = @i + 1     
end    
  
set @cnpj = rtrim(ltrim(replace(@cnpj,' ','')))     -- Limpa caracteres de <espaço>  
  
set @cnpj = cast(@cnpj as varchar(14))              -- Depois de limpar a mascara, reduz o numero de caracteres para 14  
  
set @cnpj = replicate('0',14 - len(@cnpj)) + @cnpj  -- se o numero de caracteres for menor que 14, adiciona zeros a esquerda  
  
Sair:  
  
return(@cnpj)  
  
end  
  
  
-- select dbo.fn_limpa_mascara_cnpj_J(null)  
