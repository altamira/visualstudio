
CREATE PROCEDURE pr_consulta_cliente_setor
@cd_vendedor int, --Vendedor Externo/Setor(Representante)
@ic_parametro int = 1, --1 Consulta / 2 - Atualiza
@cd_vendedor_interno int = 0
as
Begin
  if @ic_parametro is null
    set @ic_parametro = 1

  if @ic_parametro = 1
    Select 
      c.nm_fantasia_cliente,
      c.nm_razao_social_cliente,
      v.nm_fantasia_vendedor as nm_vendedor_interno,
      c.cd_cep,
      c.nm_endereco_cliente,
      c.nm_bairro,
      ci.nm_cidade,
      e.sg_estado,
      c.cd_telefone
    from
      Cliente c
      left outer join Cidade ci
      on c.cd_cidade = ci.cd_cidade and
         c.cd_estado = ci.cd_estado
      left outer join Estado e
      on c.cd_estado = e.cd_estado
      left outer join Vendedor v
      on c.cd_vendedor_interno = v.cd_vendedor
    where
      ( IsNull(c.cd_vendedor,0) = @cd_vendedor ) 
    order by nm_fantasia_cliente
  else if @ic_parametro = 2
  begin

    --Atualiza a tabela Cliente
    update cliente 
      set cd_vendedor_interno = @cd_vendedor_interno
    where
      ( IsNull(cd_vendedor,0) = @cd_vendedor ) 

    --Atualiza a tabela Cliente_Vendedor
    update 
      cliente_vendedor 
    set 
      cliente_vendedor.cd_vendedor = Cliente.cd_vendedor_interno
    from cliente_vendedor 
    inner join cliente 
      on cliente_vendedor.cd_cliente = cliente.cd_cliente and
         ( cliente.cd_vendedor = @cd_vendedor ) 
    inner join Vendedor v
      on ( cliente_vendedor.cd_vendedor = v.cd_vendedor ) and
         ( v.cd_tipo_vendedor = 1 )
    where
         ( IsNull(cliente.cd_vendedor,0) = @cd_vendedor ) 

    --Inclui o vinculo do cliente com o vendedor caso não exista nenhum vendedor interno
    insert into cliente_vendedor 
      ( cd_cliente,
       cd_vendedor,
       cd_cliente_vendedor )      
    Select
      c.cd_cliente,
      c.cd_vendedor_interno,
      (Select IsNull(max(cd_cliente_vendedor),0) + 1 from cliente_vendedor where cd_cliente = c.cd_cliente )
    from 
      cliente c
    where
      ( IsNull(c.cd_vendedor,0) = @cd_vendedor ) and
      not exists (Select 'x' from Cliente_Vendedor 
                             inner join Vendedor v
                             on ( Cliente_Vendedor.cd_cliente = c.cd_cliente ) and
                                ( cliente_vendedor.cd_vendedor = v.cd_vendedor ) and
                                ( v.cd_tipo_vendedor = 1 ))

  end
end
