
CREATE PROCEDURE pr_consulta_cliente_contato_email
@ic_parametro as int, --1 Clientes, outro número contatos
@nm_cliente as varchar(50),
@cd_cliente as int -- para que eu possa somente retornar um cliente quando pesquisar por contato

AS
--------------------------------------------------------------------------------------------
  If @ic_parametro = 1 -- Clientes
--------------------------------------------------------------------------------------------

begin


select distinct
  c.cd_cliente              as 'Codigo',
  c.nm_razao_social_cliente as 'RazaoSocial',
  c.nm_fantasia_cliente     as 'NomeFantasia',
  '(' +IsNull(c.cd_ddd,'') + ') ' + IsNull(c.cd_telefone,'')     	  as 
'DDDTelefone',
  vi.nm_fantasia_vendedor    as 'VendedorInterno',
  '(' + IsNull(vi.cd_ddd_vendedor,'') +') '+ 
  IsNull(vi.cd_telefone_vendedor,'') as 'TelefoneVendInterno',
  ve.nm_fantasia_vendedor    as 'VendedorExterno',
  '(' + IsNull(ve.cd_ddd_vendedor,'') + ') ' + 
  IsNull(ve.cd_telefone_vendedor,'') as 'TelefoneVendExterno'
--  ( case when exists ( select 'x'
--                       from Cliente_Contato co 
--                       where co.cd_cliente = c.cd_cliente )
--    then ( select top 1 co.cd_email_contato_cliente)
--           from Cliente_Contato co 
--           where co.cd_cliente = c.cd_cliente and 
--                 IsNull(co.cd_email_contato_cliente,'') <> '' ) 
--    else null end as cd_email_contato
--into #SelectCliente 

from
   Cliente c 
left outer join Cliente_Contato co on 
  co.cd_cliente = c.cd_cliente
left outer join Vendedor vi on 
  c.cd_vendedor_interno = vi.cd_vendedor 
left outer join Vendedor ve on 
  c.cd_vendedor         = ve.cd_vendedor 
where
   c.nm_fantasia_cliente like @nm_cliente + '%' and
   ( (IsNull(c.nm_email_cliente,'') = '') or 
     (IsNull(co.cd_email_contato_cliente,'') = ''))


order by NomeFantasia

--select * from #SelectCliente where 

end
------------------------------------------
else  -- Pesquisar por contato
------------------------------------------
begin

select
  ci.nm_razao_social_cliente as 'RazaoSocial',
  ci.nm_fantasia_cliente     as 'NomeFantasia',
  '(' + IsNull(ci.cd_ddd,'') + ') ' + IsNull(ci.cd_telefone,'')  	  as 
'DDDTelefone',
  vi.nm_fantasia_vendedor    as 'VendedorInterno',
  '(' + IsNull(vi.cd_ddd_vendedor,'') + ') ' + 
IsNull(vi.cd_telefone_vendedor,'') as 'TelefoneVendInterno',
  ve.nm_fantasia_vendedor    as 'VendedorExterno',
  '(' + IsNull(ve.cd_ddd_vendedor,'') + ') ' + 
IsNull(vi.cd_telefone_vendedor,'') as 'TelefoneVendExterno',
  c.cd_contato          as 'Codigo',
  c.nm_contato_cliente  as 'RazaoSocialContato',
  c.nm_fantasia_contato as 'NomeFantasiaContato',
  '(' + IsNull(c.cd_ddd_contato_cliente,'') + ') ' + 
IsNull(c.cd_telefone_contato,'') as 'DDDTelefoneContato',
  c.cd_ramal            as 'RamalContato',
  c.cd_celular          as 'CelularContato'

from
   Cliente_Contato c inner join
   Cliente ci on ci.cd_cliente = c.cd_cliente left outer join
   Vendedor vi on ci.cd_vendedor_interno = vi.cd_vendedor left outer join
   Vendedor ve on ci.cd_vendedor         = ve.cd_vendedor

where
   c.cd_cliente = @cd_cliente and
   IsNull(c.cd_email_contato_cliente,'') = ''

order by NomeFantasia

end


