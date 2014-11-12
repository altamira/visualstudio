

--------------------------------------------------------------------------------------
--GBS - GLobal Business Solution - 200@cd_fase_produto
--------------------------------------------------------------------------------------
--Stored Procedure : SQL Server Microsoft 7.0  
--Autor        : Fabio Cesar Magalhães
--Função para retornar se a consulta poderá ser visualizado pelo vendedor
--Data         : 05.15.2005
-- 15.12.2008 - Melhora de Performance - Carlos Fernandes
--------------------------------------------------------------------------------------
CREATE  FUNCTION fn_vendedor_consulta_internet(@cd_usuario int, @cd_consulta int)
RETURNS varchar(1)
AS
BEGIN

   declare @cd_vendedor  int
   declare @ic_resultado varchar(1) --Foi colocada a variável pois não compila sem result explicito

   select 
	@cd_vendedor = (isnull((select 
				 top 1 u.cd_vendedor
                                from 
				   EgisAdmin.dbo.Usuario_Internet u  with (nolock) 
				    	   where 
                                            u.cd_usuario_internet = @cd_usuario and 
				            IsNull(u.ic_vpn_usuario,'N') = 'S'),0))

	if @cd_vendedor = 0
		select @ic_resultado = 'S'
	else
	begin
		select @ic_resultado = ( IsNull( (  Select 
 						top 1 'S' 
						from 
						Consulta with (nolock) 
						where 
						cd_consulta = @cd_consulta
						and ( cd_vendedor = @cd_vendedor or
                                                      cd_vendedor_interno = @cd_vendedor) ) , 'N' ) )
	end

	RETURN @ic_resultado
END

