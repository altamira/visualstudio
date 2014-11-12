
create FUNCTION fn_limpa_mascara
(@cd_literal varchar(50))
RETURNS varchar(50)

--fn_limpa_mascara
-----------------------------------------------------------------------------------------
--GBS - Global Business Solution                                                    2002
--Stored Procedure: Microsoft SQL Server 2000
--Autor(es): Eduardo Baião
--Banco de Dados: EgisSql
--Objetivo: Tirar formatação de uma string
--Data: 15/01/2004
-----------------------------------------------------------------------------------------

AS
BEGIN

declare @cd_literal_limpo varchar(50)
declare @i int

set @cd_literal_limpo = ''
set @i = 1

while @i <= len(@cd_literal)
  begin

    if substring(@cd_literal,@i,1) not in ('-','.', '/', '\', '_', '=', '(', ')')
      begin

        set @cd_literal_limpo = @cd_literal_limpo + substring(@cd_literal,@i,1)

      end

    set @i = @i + 1

  end

return (@cd_literal_limpo)

end
