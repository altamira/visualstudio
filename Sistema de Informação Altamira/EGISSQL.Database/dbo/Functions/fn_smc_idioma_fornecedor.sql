create function fn_smc_idioma_fornecedor
  (@empresa int)
  returns int
  as
   begin
    declare @idioma int 
    declare @pais varchar(30)

    select top 1 @pais = pais 
      from smc.dbo.endereco e 
     where exists (select * from smc.dbo.fornecedor f where f.empresa = f.empresa) 
       and e.empresa = @empresa
   
    select @idioma = dbo.fn_smc_migracao_busca_idioma(@pais)
  
    set @idioma = isnull(@idioma, 0)
   return @idioma
   end

