
CREATE PROCEDURE pr_cliente_data_cadastro
@dt_inicial datetime

AS

select 
  c.cd_cliente,
  c.nm_fantasia_cliente		as 'Fantasia',
  c.dt_cadastro_cliente		as 'Cadastro',
  (select 
     v.nm_fantasia_vendedor 
   from 
     Vendedor v
   where
     v.cd_vendedor=c.cd_vendedor_interno) as 'VendInterno',
  (select 
     v.nm_fantasia_vendedor 
   from 
     Vendedor v
   where
     v.cd_vendedor=c.cd_vendedor) as 'VendExterno',
  case when isnull(c.cd_ddd,'') <> '' then
    '('+rtrim(cast(c.cd_ddd as varchar))+') '+c.cd_telefone
  else
    c.cd_telefone end		as 'Telefone',
  e.sg_estado			as 'UF',
  f.nm_fonte_informacao		as 'FonteInformacao',
  sc.nm_status_cliente          as 'Status'
from
  Cliente c
left outer join
  Estado e
on
  c.cd_estado = e.cd_estado and
  c.cd_pais = e.cd_pais
left outer join
  Fonte_Informacao f
on
  c.cd_fonte_informacao = f.cd_fonte_informacao
left outer join Status_Cliente sc on sc.cd_status_cliente = c.cd_status_cliente
where
  c.dt_cadastro_cliente between @dt_inicial and getdate()
order by
  c.dt_cadastro_cliente,
  c.nm_fantasia_cliente  

