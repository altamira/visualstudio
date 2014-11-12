
CREATE procedure pr_consulta_vendedor

@cd_parametro int -- 1 = Vendedores Externos, 2 = Representantes, 
                  -- 3 = Vendedores e Representantes, 4 = Todos
                  -- 5 = Todos Vendedores Comissionados

as

if @cd_parametro = 1 or @cd_parametro = 2
begin
  select 
     cd_vendedor,
     nm_fantasia_vendedor,
     nm_vendedor,
     coalesce(nm_email_vendedor,nm_email_particular) as Email
  from vendedor
  where ic_ativo = 'S' and
        cd_tipo_vendedor = @cd_parametro
  order by nm_fantasia_vendedor
  return
end

if @cd_parametro = 3
begin
  select 
     cd_vendedor,
     nm_fantasia_vendedor,
     nm_vendedor,
     coalesce(nm_email_vendedor,nm_email_particular) as Email
  from vendedor
  where ic_ativo = 'S' and
        cd_tipo_vendedor between 2 and 3
  order by nm_fantasia_vendedor
  return
end

if @cd_parametro = 4
begin
  select 
     cd_vendedor,
     nm_fantasia_vendedor,
     nm_vendedor,
     coalesce(nm_email_vendedor,nm_email_particular) as Email
  from vendedor
  where ic_ativo = 'S'
  order by nm_fantasia_vendedor
  return
end

if @cd_parametro = 5
begin
  select 
     v.cd_vendedor,
     v.nm_fantasia_vendedor,
     v.nm_vendedor,
     coalesce(nm_email_vendedor,nm_email_particular) as Email
  from 
     Vendedor v
     inner join Tipo_Vendedor tv
     on v.cd_tipo_vendedor = tv.cd_tipo_vendedor
  where 
     v.ic_ativo = 'S' 
     and IsNull(tv.ic_comissao_tipo_vendedor,'N') = 'S'
  order by 
     nm_fantasia_vendedor
  return
end


