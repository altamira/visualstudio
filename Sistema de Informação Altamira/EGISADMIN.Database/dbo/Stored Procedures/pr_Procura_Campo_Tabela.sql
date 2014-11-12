CREATE PROCEDURE pr_Procura_Campo_Tabela (@NMVARIAVEL varchar(50) )
AS
BEGIN

declare @Variavel varchar(30)
Declare @tabela varChar(500)

set @Variavel = @NMVARIAVEL
set @tabela = 
'select'+
 '''Select ' + @Variavel + ' from '' ' + 
 ' + t.name from sysobjects t inner join  ' +
'syscolumns c  '+
'on t.id = c.id ' +
'where c.name = '  +
' '''+ @Variavel + ' '' ' +
'and t.xtype = ''U'''

print @tabela
exec( @tabela )

end







