

--------------------------------------------------------------------------------------
--GBS - GLobal Business Solution - 200@cd_fase_produto
--Stored Procedure : SQL Server Microsoft 7.0  
--Autor: Fabio Cesar Magalhães
--Função para retornar se o pedido poderá ser visualizado pelo vendedor
--Data         : 05.15.2005
--------------------------------------------------------------------------------------
CREATE  FUNCTION fn_vendedor_pedido_internet(@cd_usuario int, @cd_pedido_venda int)
RETURNS varchar(1)
AS
BEGIN
   declare @cd_vendedor int
   declare @ic_resultado varchar(1) --Foi colocada a variável pois não compila sem result explicito

   select 
	@cd_vendedor = (isnull((select 
							 top 1 u.cd_vendedor
				   		   from 
							 EgisAdmin.dbo.Usuario_Internet u 
				    	   where 
							 u.cd_usuario_internet = @cd_usuario and 
				             IsNull(u.ic_vpn_usuario,'N') = 'S'),0))

	if ( @cd_vendedor = 0 ) or ( IsNull(@cd_pedido_venda,0) = 0)
		select @ic_resultado = 'S'
	else
	begin
		select @ic_resultado = ( IsNull( (  Select 
												top 1 'S' 
											from 
												Pedido_Venda with (nolock) 
											where 
												cd_pedido_venda = @cd_pedido_venda
												and ( cd_vendedor = @cd_vendedor or cd_vendedor_interno = @cd_vendedor) ) , 'N' ) )
	end

	RETURN @ic_resultado
END
