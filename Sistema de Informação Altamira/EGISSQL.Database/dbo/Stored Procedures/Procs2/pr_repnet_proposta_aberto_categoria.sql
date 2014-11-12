
CREATE PROCEDURE pr_repnet_proposta_aberto_categoria
  @ic_tipo_usuario as char(10),
  @cd_tipo_usuario as int,
  @cd_categoria_produto int,
  @dt_inicial datetime,       --Data inicial para consulta
  @dt_final datetime         --Data final para consulta
AS

--GBS - Global Business Solution	       2002
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es): ?
--Banco de Dados: Egissql
--Objetivo: Listar as propostas em aberto por categoria de produto
--Data: ?
--Alteração: Foi alterada a filtragem para trazer de uma categoria de 
--           produto específica e não mais tudo parecido.


if @ic_tipo_usuario='Vendedor'
begin
select
   cli.nm_fantasia_cliente as 'Cliente',
   sum(c.vl_total_consulta) as 'Consultas',
   count(c.cd_consulta) as 'QtdConsultas',
   max(c.dt_consulta) as 'DataUltimaconsulta'
   from
      Consulta c 
   left outer join Consulta_Itens i
      on c.cd_consulta = i.cd_consulta
   left outer join Cliente cli
      on c.cd_cliente = cli.cd_cliente
   where i.cd_categoria_produto = @cd_categoria_produto and
         c.dt_consulta between @dt_inicial and @dt_final and
         c.cd_vendedor=@cd_tipo_usuario 
   Group by cli.nm_fantasia_cliente
   order by cli.nm_fantasia_cliente
end

if @ic_tipo_usuario='Cliente'
begin
select
   cli.nm_fantasia_cliente as 'Cliente',
   sum(c.vl_total_consulta) as 'Consultas',
   count(c.cd_consulta) as 'QtdConsultas',
   max(c.dt_consulta) as 'DataUltimaconsulta'
   from
      Consulta c 
   left outer join Consulta_Itens i
      on c.cd_consulta = i.cd_consulta
   left outer join Cliente cli
      on c.cd_cliente = cli.cd_cliente
   where i.cd_categoria_produto = @cd_categoria_produto and
         c.dt_consulta between @dt_inicial and @dt_final and
         c.cd_cliente=@cd_tipo_usuario 
   Group by cli.nm_fantasia_cliente
   order by cli.nm_fantasia_cliente
end

if @ic_tipo_usuario='Supervisor'
begin
select
   isnull(cli.nm_fantasia_cliente,'') as 'Cliente',
   isnull(sum(c.vl_total_consulta),0) as 'Consultas',
   isnull(count(c.cd_consulta),0) as 'QtdConsultas',
   max(c.dt_consulta) as 'DataUltimaconsulta'
   from
      Consulta c 
   left outer join Consulta_Itens i
      on c.cd_consulta = i.cd_consulta
   left outer join Cliente cli
      on c.cd_cliente = cli.cd_cliente
   where i.cd_categoria_produto = @cd_categoria_produto and
         c.dt_consulta between @dt_inicial and @dt_final 
   Group by cli.nm_fantasia_cliente
   order by cli.nm_fantasia_cliente
end

