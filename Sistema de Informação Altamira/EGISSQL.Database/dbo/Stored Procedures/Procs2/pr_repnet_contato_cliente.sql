



--pr_repnet_contato_cliente
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                             2000                     
--Stored Procedure : SQL Server Microsoft 2000  
--Carlos Cardoso Fernandes 
--Consulta de Contatos do Clientes 
--Data          : 07.04.2002
--Atualizado    : 
---------------------------------------------------------------------------------------
CREATE   procedure pr_repnet_contato_cliente
@nm_fantasia_cliente varchar(15),
@cd_tipo_usuario      int,
@ic_tipo_usuario varchar(10)
as

if @ic_tipo_usuario = 'Vendedor'
begin
Select 
    a.nm_fantasia_cliente,
    a.cd_vendedor,
    a.cd_ddd,
    a.cd_telefone,
    a.nm_email_cliente,
    b.nm_contato_cliente,
    b.cd_telefone_contato,
    isnull(b.cd_email_contato_cliente,'') as cd_email_contato_cliente,
    isnull(d.nm_departamento_cliente,'') as nm_departamento_cliente,
    isnull(s.nm_setor_cliente,'') as nm_setor_cliente,
    isnull(c.nm_cargo,'') as nm_cargo,
    isnull(b.cd_ddd_contato_cliente,'') as cd_ddd_contato_cliente,
    isnull(b.cd_ramal,'') as cd_ramal
From 
    Cliente a
left outer join Cliente_Contato b
   on (b.cd_cliente  = a.cd_cliente)
left outer join Setor_Cliente s
   on (s.cd_setor_cliente = b.cd_setor_cliente)
left outer join Cargo c
   on (c.cd_cargo    = b.cd_cargo)
left outer join Departamento_Cliente d
   on (d.cd_departamento_cliente = b.cd_departamento_cliente)
Where 
    a.cd_vendedor = @cd_tipo_usuario            and
    a.nm_fantasia_cliente like @nm_fantasia_cliente+'%'
order by 
    a.nm_fantasia_cliente,b.cd_contato
end

if @ic_tipo_usuario = 'Cliente'
begin
Select 
    a.nm_fantasia_cliente,
    a.cd_vendedor,
    a.cd_ddd,
    a.cd_telefone,
    a.nm_email_cliente,
    b.nm_contato_cliente,
    b.cd_telefone_contato,
    isnull(b.cd_email_contato_cliente,'') as cd_email_contato_cliente,
    isnull(d.nm_departamento_cliente,'') as nm_departamento_cliente,
    isnull(s.nm_setor_cliente,'') as nm_setor_cliente,
    isnull(c.nm_cargo,'') as nm_cargo,
    isnull(b.cd_ddd_contato_cliente,'') as cd_ddd_contato_cliente,
    isnull(b.cd_ramal,'') as cd_ramal
From 
    Cliente a
left outer join Cliente_Contato b
   on (b.cd_cliente  = a.cd_cliente)
left outer join Setor_Cliente s
   on (s.cd_setor_cliente = b.cd_setor_cliente)
left outer join Cargo c
   on (c.cd_cargo    = b.cd_cargo)
left outer join Departamento_Cliente d
   on (d.cd_departamento_cliente = b.cd_departamento_cliente)
Where 
    a.cd_cliente = @cd_tipo_usuario            and
    a.nm_fantasia_cliente like @nm_fantasia_cliente+'%'
order by 
    a.nm_fantasia_cliente,b.cd_contato
end


if @ic_tipo_usuario = 'Supervisor'
begin
Select 
    a.nm_fantasia_cliente,
    a.cd_vendedor,
    a.cd_ddd,
    a.cd_telefone,
    a.nm_email_cliente,
    b.nm_contato_cliente,
    b.cd_telefone_contato,
    isnull(b.cd_email_contato_cliente,'') as cd_email_contato_cliente,
    isnull(d.nm_departamento_cliente,'') as nm_departamento_cliente,
    isnull(s.nm_setor_cliente,'') as nm_setor_cliente,
    isnull(c.nm_cargo,'') as nm_cargo,
    isnull(b.cd_ddd_contato_cliente,'') as cd_ddd_contato_cliente,
    isnull(b.cd_ramal,'') as cd_ramal
From 
    Cliente a
left outer join Cliente_Contato b
   on (b.cd_cliente  = a.cd_cliente)
left outer join Setor_Cliente s
   on (s.cd_setor_cliente = b.cd_setor_cliente)
left outer join Cargo c
   on (c.cd_cargo    = b.cd_cargo)
left outer join Departamento_Cliente d
   on (d.cd_departamento_cliente = b.cd_departamento_cliente)
Where 
    a.nm_fantasia_cliente like @nm_fantasia_cliente+'%'
order by 
    a.nm_fantasia_cliente,b.cd_contato
end




