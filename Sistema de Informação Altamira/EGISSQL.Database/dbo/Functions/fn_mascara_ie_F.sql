
CREATE function fn_mascara_ie_F 
(@limpa_mascara varchar(8000))  
  
returns varchar(8000)  
  
as  
  
begin  
  
declare @v varchar(8000)  
set @v = upper(@limpa_mascara)  
set @v = @v  
  
if @v is null   
begin  
  set @v = '0000000000000000'  
  goto Sair  
end  
   
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
  
set @v = replace(rtrim(ltrim(replace(@v,' ',''))),'S','')   
  
set @v = cast(@v as varchar(16))  
  
set @v = replicate('0',16 - len(@v)) + @v   
  
Sair:  
  
return(select @v)  
  
end  
  
  
--select dbo.fn_mascara_ie_F(null),  
