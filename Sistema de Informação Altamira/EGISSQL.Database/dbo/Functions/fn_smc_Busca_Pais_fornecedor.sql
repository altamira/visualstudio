create function fn_smc_Busca_Pais_fornecedor
  (@empresa int)
  returns int
  as
  begin
      declare @cd_pais int 
      declare @pais varchar(30)

     select top 1 @pais = pais 
      from smc.dbo.endereco e 
     where exists (select * from smc.dbo.fornecedor f where f.empresa = f.empresa) 
       and e.empresa = @empresa

     select @cd_pais = dbo.fn_smc_migracao_Busca_Pais (@pais)
  
     set @cd_pais = isnull(@cd_pais, 0)
     return @cd_pais
  end
  