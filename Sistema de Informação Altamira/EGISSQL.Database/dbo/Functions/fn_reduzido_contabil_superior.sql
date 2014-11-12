
CREATE FUNCTION fn_reduzido_contabil_superior
(@cd_conta_reduzido int)
RETURNS int

as begin

declare @cd_mascara_conta varchar(20)
declare @cd_contador int

set     @cd_contador = 0


  select
    @cd_mascara_conta = cd_mascara_conta
  from
    Plano_Conta
  where
    cd_conta_reduzido = @cd_conta_reduzido and
    cd_empresa = dbo.fn_empresa()
          
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

        if not exists(select top 1 'x' from plano_conta
                      where cd_mascara_conta = @cd_mascara_conta and
                            cd_empresa = dbo.fn_empresa())
          return(null)
        else
          break

      end

      set @cd_contador = @cd_contador + 1

    end

  return(select
           cd_conta_reduzido
         from
           Plano_Conta
         where
           cd_mascara_conta = @cd_mascara_conta and
           cd_empresa = dbo.fn_empresa())


end

