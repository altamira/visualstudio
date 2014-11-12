  
CREATE FUNCTION fn_serie_docto_customizada
(@cd_pedido_venda int,
 @ic_tipo_pesquisa char(1)) -- 'N' Nota_Saida_Parcela , 'P' Pedido_Venda_Parcela
RETURNS varchar(25)


AS
BEGIN 


  declare @qt_parcela           int
  declare @cd_identificacao     varchar(25) 
  declare @cd_nota_saida        int

  select
    @cd_identificacao = isnull(cd_identificacao_empresa,cast(@cd_pedido_venda as varchar) )
  from
    Pedido_Venda with (nolock)
  where
    cd_pedido_venda = @cd_pedido_venda

  if @ic_tipo_pesquisa = 'P'
    select
      @qt_parcela = IsNull(count(cd_pedido_venda),0) + 1
    from
      Pedido_Venda_Parcela with (nolock)
    where
      cd_pedido_venda = @cd_pedido_venda 
  else
  begin
    set @cd_nota_saida = ( select top 1 cd_nota_saida
                           from Nota_Saida_Item with (nolock) 
                           where cd_pedido_venda = @cd_pedido_venda )
    select
      @qt_parcela = IsNull(count(cd_nota_saida),0) + 1
    from
      Nota_Saida_Parcela with (nolock) 
    where
      cd_nota_saida = @cd_nota_saida
  end

  set @cd_identificacao = @cd_identificacao + '-' + cast(@qt_parcela as varchar(20))
   
  return(@cd_identificacao)

end
   
  
