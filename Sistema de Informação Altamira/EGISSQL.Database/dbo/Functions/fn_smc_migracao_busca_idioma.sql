create function fn_smc_migracao_busca_idioma 
  (@NM_pais varchar(30))
  returns int
  AS
  begin
    declare @cd_idioma int
    select top 1 @cd_idioma = i.cd_idioma
    from egissql.dbo.idioma i , egissql.dbo.pais p
    where i.cd_idioma = p.cd_idioma
      and p.nm_pais = @nm_pais

    set @cd_idioma = isnull(@cd_idioma, 0)

    return @cd_idioma
  end
 