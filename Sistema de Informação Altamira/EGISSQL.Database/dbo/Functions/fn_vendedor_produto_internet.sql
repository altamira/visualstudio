

--------------------------------------------------------------------------------------
--GBS - GLobal Business Solution - 200@cd_fase_produto
--Stored Procedure : SQL Server Microsoft 7.0  
--Autor: Fabio Cesar Magalhães
--Função para retornar se o produto poderá ser visualizado pelo vendedor
--Data         : 05.15.2005
--------------------------------------------------------------------------------------
CREATE  FUNCTION fn_vendedor_produto_internet(@cd_usuario int, @cd_produto int)
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

	if ( @cd_vendedor = 0 ) or ( IsNull(@cd_produto,0) = 0 )
		select @ic_resultado = 'S'
	else
	begin
		select @ic_resultado = ( IsNull( (  Select 
												top 1 'S' 
											from 
												Produto_Custo with (nolock) 
											where 
												cd_produto = @cd_produto
												and IsNull(ic_lista_rep_produto,'N') = 'S'), 'N' ) )
	end

	RETURN @ic_resultado
END
