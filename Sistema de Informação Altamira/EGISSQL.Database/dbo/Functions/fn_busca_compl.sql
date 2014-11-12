﻿create function fn_busca_compl(@str varchar(8000))
  returns varchar(8000)
as
begin
   
  declare @i int   
  set @i = 1  

  while @i <= len(rtrim(ltrim(@str)))   
  begin  
   if (substring(rtrim(ltrim(@str)), @i, 1)) in (',', '0','1','2','3','4','5','6','7','8','9') 
   begin  
     set @str = substring(rtrim(ltrim(@str)), @i, len(rtrim(ltrim(@str))))  
     goto sair
   end  
  
   set @i = @i + 1     
  
  end

  sair:

  set @str = rtrim(ltrim(replace(@str,',','')))

  set @i = 1
  
  while @i <= len(rtrim(ltrim(@str)))   
  begin  
   if (substring(rtrim(ltrim(@str)), @i, 1)) in (' ', 'A','B','C','D','E','F','G','H','I','J','K','L','M','N','O','P','Q','R','S','T','U','V','X','Y','W','Z')  
   begin  
     set @str = substring(rtrim(ltrim(@str)), @i, len(rtrim(ltrim(@str))))  
     goto sair2
   end  
  
   set @i = @i + 1     
  
  end

  sair2:
  
  set @str = (select case 
           when substring(rtrim(ltrim(replace(@str,',',''))),1,1) = '-' then 
             substring(rtrim(ltrim(replace(@str,',',''))),2,len(rtrim(ltrim(replace(@str,',','')))))
           else
             rtrim(ltrim(replace(@str,',','')))
           end as ddd)
    
  return(rtrim(ltrim(replace(@str,',',''))))

end
--------------------------------------------------
--select dbo.fn_busca_compl('4200 BLOCO 2 SALA 501 DUPLEX')
-------------------------------------------------- 
