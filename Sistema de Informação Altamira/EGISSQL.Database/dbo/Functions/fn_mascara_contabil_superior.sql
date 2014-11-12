
CREATE FUNCTION fn_mascara_contabil_superior
(@cd_mascara_conta varchar(20))
RETURNS varchar(20)

as begin

declare @cd_contador int
set     @cd_contador = 0

          
  -- se a máscara é igual a 1 quer dizer que é do grupo superior   
  if (len(@cd_mascara_conta) = 1)
    return(null)
  else
    while (@cd_contador <= len(@cd_mascara_conta))
    begin

      -- se encontrou um ponto, então carrega a nova máscara com o grupo superior
      if (substring(@cd_mascara_conta, (len(@cd_mascara_conta)-@cd_contador),1) = '.')
      begin
        set @cd_mascara_conta = (substring(@cd_mascara_conta, 1, (len(@cd_mascara_conta) - (@cd_contador + 1))))
        break
      end

      set @cd_contador = @cd_contador + 1

    end

  return(@cd_mascara_conta)

end

