

CREATE PROCEDURE pr_Select_Tabela (@NMTABELA varchar(50) )
AS
BEGIN

declare @y varchar(30)
Declare @tabela varChar(500)

set @y = @NMTABELA

set @tabela =
'Select ' +
  '*  ' +
'from  '+
@y + '   '

print @tabela
exec( @tabela )


end
