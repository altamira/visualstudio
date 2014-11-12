create function fn_smc_busca_incoterm
   (@Pedido int)
  returns varchar(10)
  as 
  begin
    declare @incoterm varchar(10)

    select top 1 @incoterm = di.incoterm
    from ((smc.dbo.itemdi idi join
         smc.dbo.ItemPedidoImportacao ipi
         on ipi.id = idi.ItemPedidoImportacao)
         join smc.dbo.Di di on idi.di = di.id)
    where ipi.PedidoImportacao = @pedido

    set @incoterm = isnull(@incoterm, '')

    return @incoterm
  end 
  