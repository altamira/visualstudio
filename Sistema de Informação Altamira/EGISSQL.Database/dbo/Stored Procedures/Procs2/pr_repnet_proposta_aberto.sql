
CREATE PROCEDURE pr_repnet_proposta_aberto
  @ic_tipo_usuario as char(10),
  @cd_tipo_usuario as int,
  @ic_parametro char(1),
  @dt_inicial datetime,       --Data inicial para consulta
  @dt_final datetime         --Data final para consulta
AS


if @ic_tipo_usuario='Vendedor'
begin

if @ic_parametro='1'
begin
select
                c.cd_consulta as 'Proposta',
                c.dt_consulta as 'Dataconsulta',
                c.cd_cliente as 'Cod_cli',
                cli.nm_fantasia_cliente as 'Cliente',
                clic.nm_contato_cliente as 'Contato',
                i.cd_item_consulta as 'Item',
                isnull(i.qt_item_consulta,0) as 'Qtd',
                i.nm_fantasia_produto as 'Descricao',
                isnull(i.vl_unitario_item_consulta,0) as 'Preco'
              from
                Consulta c 
                left outer join Consulta_Itens i
                  on c.cd_consulta = i.cd_consulta
                left outer join Cliente cli
                  on c.cd_cliente = cli.cd_cliente
                left outer join Cliente_Contato clic
                  on (clic.cd_cliente  = c.cd_cliente and clic.cd_contato = c.cd_contato)
                where c.cd_vendedor=@cd_tipo_usuario
							   and
							   (i.dt_fechamento_consulta is null)
							   and 
							   (i.dt_perda_consulta_itens is null)
                order by c.cd_consulta, i.cd_item_consulta
end
if @ic_parametro='2'
begin
select
                c.cd_consulta as 'Proposta',
                c.dt_consulta as 'Dataconsulta',
                c.cd_cliente as 'Cod_cli',
                cli.nm_fantasia_cliente as 'Cliente',
                clic.nm_contato_cliente as 'Contato',
                i.cd_item_consulta as 'Item',
                isnull(i.qt_item_consulta,0) as 'Qtd',
                i.nm_fantasia_produto as 'Descricao',
                isnull(i.vl_unitario_item_consulta,0) as 'Preco'
              from
                Consulta c 
                left outer join Consulta_Itens i
                  on c.cd_consulta = i.cd_consulta
                left outer join Cliente cli
                  on c.cd_cliente = cli.cd_cliente
                left outer join Cliente_Contato clic
                  on (clic.cd_cliente  = c.cd_cliente and clic.cd_contato = c.cd_contato)
                where c.dt_consulta between @dt_inicial and @dt_final and
                c.cd_vendedor=@cd_tipo_usuario
							   and
							   (i.dt_fechamento_consulta is null)
							   and 
							   (i.dt_perda_consulta_itens is null)
                order by c.cd_consulta, i.cd_item_consulta
end

end

if @ic_tipo_usuario='Cliente'
begin

if @ic_parametro='1'
begin
select
                c.cd_consulta as 'Proposta',
                c.dt_consulta as 'Dataconsulta',
                c.cd_cliente as 'Cod_cli',
                cli.nm_fantasia_cliente as 'Cliente',
                clic.nm_contato_cliente as 'Contato',
                i.cd_item_consulta as 'Item',
                isnull(i.qt_item_consulta,0) as 'Qtd',
                i.nm_fantasia_produto as 'Descricao',
                isnull(i.vl_unitario_item_consulta,0) as 'Preco'
              from
                Consulta c 
                left outer join Consulta_Itens i
                  on c.cd_consulta = i.cd_consulta
                left outer join Cliente cli
                  on c.cd_cliente = cli.cd_cliente
                left outer join Cliente_Contato clic
                  on (clic.cd_cliente  = c.cd_cliente and clic.cd_contato = c.cd_contato)
                where c.cd_cliente=@cd_tipo_usuario
							   and
							   (i.dt_fechamento_consulta is null)
							   and 
							   (i.dt_perda_consulta_itens is null)
                order by c.cd_consulta, i.cd_item_consulta
end
if @ic_parametro='2'
begin
select
                c.cd_consulta as 'Proposta',
                c.dt_consulta as 'Dataconsulta',
                c.cd_cliente as 'Cod_cli',
                cli.nm_fantasia_cliente as 'Cliente',
                clic.nm_contato_cliente as 'Contato',
                i.cd_item_consulta as 'Item',
                isnull(i.qt_item_consulta,0) as 'Qtd',
                i.nm_fantasia_produto as 'Descricao',
                isnull(i.vl_unitario_item_consulta,0) as 'Preco'
            from
                Consulta c 
                left outer join Consulta_Itens i
                  on c.cd_consulta = i.cd_consulta
                left outer join Cliente cli
                  on c.cd_cliente = cli.cd_cliente
                left outer join Cliente_Contato clic
                  on (clic.cd_cliente  = c.cd_cliente and clic.cd_contato = c.cd_contato)
                where c.dt_consulta between @dt_inicial and @dt_final and
                c.cd_cliente=@cd_tipo_usuario
							   and
							   (i.dt_fechamento_consulta is null)
							   and 
							   (i.dt_perda_consulta_itens is null)
                order by c.cd_consulta, i.cd_item_consulta
end

end

if @ic_tipo_usuario='Supervisor'
begin

if @ic_parametro='1'
begin
select
                c.cd_consulta as 'Proposta',
                c.dt_consulta as 'Dataconsulta',
                c.cd_cliente as 'Cod_cli',
                cli.nm_fantasia_cliente as 'Cliente',
                clic.nm_contato_cliente as 'Contato',
                i.cd_item_consulta as 'Item',
                isnull(i.qt_item_consulta,0) as 'Qtd',
                i.nm_fantasia_produto as 'Descricao',
                isnull(i.vl_unitario_item_consulta,0) as 'Preco'
              from
                Consulta c 
                left outer join Consulta_Itens i
                  on c.cd_consulta = i.cd_consulta
                left outer join Cliente cli
                  on c.cd_cliente = cli.cd_cliente
                left outer join Cliente_Contato clic
                  on (clic.cd_cliente  = c.cd_cliente and clic.cd_contato = c.cd_contato)
							where
							   (i.dt_fechamento_consulta is null)
							   and 
							   (i.dt_perda_consulta_itens is null)
                order by c.cd_consulta, i.cd_item_consulta
end
if @ic_parametro='2'
begin
select
                c.cd_consulta as 'Proposta',
                c.dt_consulta as 'Dataconsulta',
                c.cd_cliente as 'Cod_cli',
                cli.nm_fantasia_cliente as 'Cliente',
                clic.nm_contato_cliente as 'Contato',
                i.cd_item_consulta as 'Item',
                isnull(i.qt_item_consulta,0) as 'Qtd',
                i.nm_fantasia_produto as 'Descricao',
                isnull(i.vl_unitario_item_consulta,0) as 'Preco'
              from
                Consulta c 
                left outer join Consulta_Itens i
                  on c.cd_consulta = i.cd_consulta
                left outer join Cliente cli
                  on c.cd_cliente = cli.cd_cliente
                left outer join Cliente_Contato clic
                  on (clic.cd_cliente  = c.cd_cliente and clic.cd_contato = c.cd_contato)
                where c.dt_consulta between @dt_inicial and @dt_final
							   and
							   (i.dt_fechamento_consulta is null)
							   and 
							   (i.dt_perda_consulta_itens is null)
                order by c.cd_consulta, i.cd_item_consulta
end

end

