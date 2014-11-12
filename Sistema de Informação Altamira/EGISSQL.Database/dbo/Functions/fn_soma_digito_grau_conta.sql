
CREATE FUNCTION fn_soma_digito_grau_conta
(@cd_grupo_conta int,
 @qt_grau_conta  int)
RETURNS int

as 

begin

  declare @qt_digito_grau_conta   int
  declare @cd_mascara_grupo_conta varchar(50)
  declare @qt_grau                int
  declare @qt_contador            int

  if @cd_grupo_conta>0
  begin

    select 
      @cd_mascara_grupo_conta = isnull(cd_mascara_grupo_conta,'')
    from 
      grupo_conta
    where
      cd_grupo_conta = @cd_grupo_conta

    set @qt_digito_grau_conta = 0
    set @qt_grau              = 0
    set @qt_contador          = 1

    while @qt_contador <= len( @cd_mascara_grupo_conta)
    begin

      if substring(@cd_mascara_grupo_conta,@qt_contador,1)='.'
      begin

        set @qt_grau = @qt_grau + 1
        
        if @qt_grau  = @qt_grau_conta
        begin
          break
        end

      end

      set @qt_contador          = @qt_contador          + 1
      set @qt_digito_grau_conta = @qt_digito_grau_conta + 1

    end

  end

  return(@qt_digito_grau_conta)

end

