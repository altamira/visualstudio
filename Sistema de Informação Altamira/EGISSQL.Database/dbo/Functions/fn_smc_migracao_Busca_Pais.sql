create function fn_smc_migracao_Busca_Pais
  (@nm_pais varchar(20))
  returns int
  as
  begin
    declare @Cod_Pais int 

    select @Cod_pais = Cd_Pais  from
    (select p.cd_pais, p.nm_pais, e.pais
    from egissql.dbo.pais p left join
         smc.dbo.endereco e
         on upper(p.nm_pais) = upper(e.pais)
    union 
    select p.cd_pais, p.nm_pais, e.pais
      from egissql.dbo.pais p right join
           smc.dbo.endereco e
           on upper(p.nm_pais) = upper(e.pais)
    ) as tudo
    where nm_pais is not null
      and pais is not null
      and pais = @nm_pais 

    set @Cod_pais = isnull(@Cod_pais, 0)

    return  @Cod_pais
  end
  