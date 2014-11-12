
create function fn_limpa_mascara_ie
(@cnpj varchar(8000))

returns varchar(8000)

as

begin
 
declare @i int 
set @i = 1

while @i <= len(rtrim(ltrim(@cnpj))) 
begin
   if (substring(rtrim(ltrim(@cnpj)), @i, 1)) not in ('0','1','2','3','4','5','6','7','8','9')
   begin
     set @cnpj = replace(@cnpj,substring(rtrim(ltrim(@cnpj)), @i, 1),' ') -- Se o caracter não estiver contido no conjunto acima, substitui o mesmo por <Espaço>
   end

   set @i = @i + 1   
end 	

set @cnpj = rtrim(ltrim(Replace(replace(@cnpj,' ',''),'S','')))     -- Limpa caractere <espaço>

set @cnpj = cast(@cnpj as varchar(12))              -- Depois de limpar a mascara, reduz o numero de caracteres para 14

set @cnpj = replicate('0',12 - len(@cnpj)) + @cnpj  -- se o numero de caracteres for menor que 14, adiciona zeros a esquerda

return(@cnpj)

end

