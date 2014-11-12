
CREATE FUNCTION fn_formata_mascara
(@cd_mascara varchar(50),
 @cd_literal varchar(50))
RETURNS varchar(50)

AS
BEGIN

declare @cd_literal_formatado varchar(50)
declare @i int

set @i = 1

while @i < len(@cd_mascara)
  begin

    if substring(@cd_mascara, @i,1) in ('-','.', '/', '\', '_', '=', '(', ')')
      begin

        set @cd_literal_formatado = substring(@cd_literal, 1, @i-1)+
                                    substring(@cd_mascara, @i,1)+
                                    substring(@cd_literal, @i, len(@cd_literal))
        set @cd_literal = @cd_literal_formatado

      end
    else
      begin

        set @cd_literal_formatado = @cd_literal
        set @cd_literal = @cd_literal_formatado

      end

    set @i = @i + 1

  end

return (@cd_literal_formatado)

end

