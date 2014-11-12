
CREATE PROCEDURE pr_Consulta_Tabela (@NMTABELA varchar(50), @ALIAS varchar(50) )
AS
BEGIN

declare @x varchar(30)
declare @y varchar(30)
Declare @tabela varChar(500)

set @y = @NMTABELA
set @x = @ALIAS

set @tabela =  
'Select ' +
  @x + '.cd_ddd, ' +
  @x + '.cd_telefone, ' +
  @x + '.nm_razao_social, ' +
  'p.nm_pais, ' +
	'c.nm_cidade, ' +
	'e.nm_estado ' +
'From ' +
  @y + ' '+ @x + ' ' +
'Left outer join ' +
	'Pais p '+ 
'on '+
	@x + '.cd_pais = p.cd_pais ' +
'Left outer join ' +
	'Estado e ' +
'on ' +
	@x + '.cd_estado = e.cd_estado ' +
'Left outer join ' +
  'Cidade c ' +
'on ' +
	@x + '.cd_cidade = c.cd_cidade ' +    
'Where ' +
@x + '.nm_Fantasia like ''GBS%'' '+ 
'Order By '+
@x + '.nm_Fantasia'

print 'Comando'
print @tabela

exec( @tabela )

end
