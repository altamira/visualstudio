
CREATE PROCEDURE pr_repnet_proposta_aberto_cliente
  @ic_tipo_usuario as varchar(10),
  @cd_tipo_usuario as int,
  @nm_fantasia_cliente varchar(30)
AS

if @ic_tipo_usuario='Vendedor'
begin
select
   c.cd_consulta as 'Proposta',
   c.dt_consulta as 'Dataconsulta',
   i.cd_item_consulta as 'Item',
   isnull(i.qt_item_consulta,0) as 'Qtd',
   isnull(i.vl_unitario_item_consulta,0) as 'Preco',
   i.nm_fantasia_produto as 'Descricao',
   DATEDIFF(day, c.dt_consulta, getdate()) as 'Dias'
from
   Consulta c 
   left outer join Consulta_Itens i
   on c.cd_consulta = i.cd_consulta
   left outer join Cliente cli
   on c.cd_cliente = cli.cd_cliente
   where c.cd_vendedor=@cd_tipo_usuario and 
   cli.nm_fantasia_cliente like @nm_fantasia_cliente+'%'
   and
   (i.dt_fechamento_consulta is null)
   and 
   (i.dt_perda_consulta_itens is null)
   order by c.cd_consulta, i.cd_item_consulta
end

if @ic_tipo_usuario='Cliente'
begin
select
   c.cd_consulta as 'Proposta',
   c.dt_consulta as 'Dataconsulta',
   i.cd_item_consulta as 'Item',
   isnull(i.qt_item_consulta,0) as 'Qtd',
   isnull(i.vl_unitario_item_consulta,0) as 'Preco',
   i.nm_fantasia_produto as 'Descricao',
   DATEDIFF(day, c.dt_consulta, getdate()) as 'Dias'
from
   Consulta c 
   left outer join Consulta_Itens i
   on c.cd_consulta = i.cd_consulta
   left outer join Cliente cli
   on c.cd_cliente = cli.cd_cliente
   where c.cd_cliente=@cd_tipo_usuario and 
   cli.nm_fantasia_cliente like @nm_fantasia_cliente+'%'
   and 
   (i.dt_fechamento_consulta is null)
   and 
   (i.dt_perda_consulta_itens is null)
   order by c.cd_consulta, i.cd_item_consulta
end

if @ic_tipo_usuario='Supervisor'
begin
select
   c.cd_consulta as 'Proposta',
   c.dt_consulta as 'Dataconsulta',
   i.cd_item_consulta as 'Item',
   isnull(i.qt_item_consulta,0) as 'Qtd',
   isnull(i.vl_unitario_item_consulta,0) as 'Preco',
   i.nm_fantasia_produto as 'Descricao',
   DATEDIFF(day, c.dt_consulta, getdate()) as 'Dias'
from
   Consulta c 
   left outer join Consulta_Itens i
   on c.cd_consulta = i.cd_consulta
   left outer join Cliente cli
   on c.cd_cliente = cli.cd_cliente
   where cli.nm_fantasia_cliente like @nm_fantasia_cliente+'%' 
   and 
   (i.dt_fechamento_consulta is null)
   and 
   (i.dt_perda_consulta_itens is null)
   order by c.cd_consulta, i.cd_item_consulta
end





