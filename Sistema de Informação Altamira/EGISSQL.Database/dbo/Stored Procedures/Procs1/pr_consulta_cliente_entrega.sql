
CREATE PROCEDURE pr_consulta_cliente_entrega
  @ic_somente_pessoa_juridica char(1) = 'N',
  @cd_usuario                 int = 0

as

begin

	declare @cd_vendedor int

	--Define o vendedor para o cliente

	Select
          @cd_vendedor = dbo.fn_vendedor_internet(@cd_usuario)


	--Caso não estiver vinculado continua o procedimento normal
	if ( @cd_vendedor > 0 )
		Select 
		  c.cd_cliente,
		  c.nm_fantasia_cliente,
		  c.cd_estado, 
		  c.cd_pais,
		  ep.pc_aliquota_icms_estado
		From
		  Cliente c with(nolock) 
		  inner join Status_Cliente sc 
		    on c.cd_status_cliente = sc.cd_status_cliente and
		    IsNull(sc.ic_dado_obrigatorio,'N') = 'S' and
		    --Já realiza o filtro tipo de pessoa
		    IsNull(c.cd_tipo_pessoa,1) = ( case @ic_somente_pessoa_juridica
		                                     when 'S' then 1
		                                     else IsNull(c.cd_tipo_pessoa,1) 
		                                   end )
		  left outer join Estado_Parametro ep with(nolock)
		    on c.cd_pais = ep.cd_pais and c.cd_estado = ep.cd_estado
		  left outer join Estado e with(nolock)
		    on c.cd_pais = e.cd_pais and c.cd_estado = e.cd_estado
		where
		  c.cd_vendedor = @cd_vendedor
		Order by    
		  c.nm_fantasia_cliente
	else 


--Caso possua um vendedor definido filtra somente os clientes do vendedor

		Select 
		  c.cd_cliente,
		  c.nm_fantasia_cliente,
		  c.cd_estado, 
		  c.cd_pais,
		  ep.pc_aliquota_icms_estado
		From
		  Cliente c with(nolock) 
		  inner join Status_Cliente sc 
		    on c.cd_status_cliente = sc.cd_status_cliente and
		    IsNull(sc.ic_dado_obrigatorio,'N') = 'S' and
		    --Já realiza o filtro tipo de pessoa
		    IsNull(c.cd_tipo_pessoa,1) = ( case @ic_somente_pessoa_juridica
		                                     when 'S' then 1
		                                     else IsNull(c.cd_tipo_pessoa,1) 
		                                   end )
		  left outer join Estado_Parametro ep with(nolock)
		    on c.cd_pais = ep.cd_pais and c.cd_estado = ep.cd_estado
		  left outer join Estado e with(nolock)
		    on c.cd_pais = e.cd_pais and c.cd_estado = e.cd_estado
		Order by    
		  c.nm_fantasia_cliente


end

