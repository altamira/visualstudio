
create function fn_mascara_cep
(@limpa_mascara varchar(8000))

returns varchar(8000)

as

begin

declare @v varchar(8000)
set @v = upper(@limpa_mascara)
set @v = @v
 
declare @i int 
set @i = 1

while @i <= len(rtrim(ltrim(@v))) 
begin
   if (substring(rtrim(ltrim(@v)), @i, 1)) not in ('0','1','2','3','4','5','6','7','8','9')
   begin
     set @v = replace(@v,substring(rtrim(ltrim(@v)), @i, 1),' ')
   end

   set @i = @i + 1   
end 	

set @v = rtrim(ltrim(replace(@v,' ',''))) 

set @v = cast(@v as varchar(8))

set @v = replicate('0',8 - len(@v)) + @v 

return(@v)

end

