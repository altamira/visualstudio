

/****** Object:  Stored Procedure dbo.pr_nivel_plano_conta    Script Date: 13/12/2002 15:08:36 ******/
create procedure pr_nivel_plano_conta
@cd_mascara_conta varchar(30),
@nivel int output
as
begin
  
  declare @counter int
  declare @qt_ponto int
  set @counter = 0
  set @qt_ponto = 0
  
  while (@counter <= len(@cd_mascara_conta))
    begin
      if (substring(@cd_mascara_conta, @counter, 1) = '.')
        set @qt_ponto = @qt_ponto + 1
      
      set @counter = @counter + 1
    end
end;


