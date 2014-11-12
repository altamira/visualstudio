
CREATE PROCEDURE pr_consulta_proposta

  @dt_inicial datetime,       --Data inicial para consulta
  @dt_final datetime,         --Data final para consulta
  @cd_cliente int,            --Cliente para pesquisa
  @cd_vendedor int,           --Vendedor para pesquisa
  @nm_banco_admin varchar(30),--Nome do Banco de Dados Admin que está sendo utilizado
  @ic_abertas varchar(1)      --Define se será filtrado apenas os itens que ainda não tornaram-se pedido ou foram cancelados
AS 

  declare @SQL   varchar(8000)

  --Definição do Comando SQL  
  set @SQL = 'select
                c.cd_consulta,
                i.cd_item_consulta,
                cli.nm_fantasia_cliente,
                c.dt_consulta,
                i.nm_fantasia_produto,
                i.nm_produto_consulta,
                Coalesce(v.nm_fantasia_vendedor,v.nm_vendedor,''Sem Vendedor'') as nm_vendedor,
                i.qt_item_consulta,
                i.pc_desconto_item_consulta,
                i.vl_lista_item_consulta,
                i.vl_unitario_item_consulta,
                i.pc_ipi,
                i.pc_icms,
                i.qt_dia_entrega_consulta,
		i.dt_entrega_consulta,
                c.ic_fatsmo_consulta,
                c.cd_destinacao_produto,
                u.nm_usuario
                --Campo de ICMS
              from
                Consulta c left outer join Consulta_Itens i
                  on c.cd_consulta = i.cd_consulta
                left outer join Cliente cli
                  on c.cd_cliente = cli.cd_cliente
                left outer join Vendedor v
                  on c.cd_vendedor = v.cd_vendedor
                left outer join ' + @nm_banco_admin + '.dbo.Usuario u
                  on i.cd_usuario = u.cd_usuario '

  --Verificando se foi informado o período
  set @SQL = @SQL + ' where c.dt_consulta between ' + QUOTENAME(cast(@dt_inicial as varchar), '''') + ' and ' + QUOTENAME(cast(@dt_final as varchar), '''')
  
  --Verificando se Cliente foi informado
  if (@cd_cliente > 0) and (not (@cd_cliente is null))
    set @SQL = @SQL + ' and c.cd_cliente = ' + cast(@cd_cliente as varchar)

  --Verificando se Cliente foi informado
  if (@cd_vendedor > 0) and (not (@cd_vendedor is null))
    set @SQL = @SQL + ' and c.cd_vendedor = ' + cast(@cd_vendedor as varchar)

  if @ic_abertas = 'S'
    set @SQL = @SQL + ' and (i.dt_perda_consulta_itens is null) and (i.dt_fechamento_consulta is null)'

  --Ordena os dados pelo código da consulta
  set @SQL = @SQL + ' order by c.cd_consulta, i.cd_item_consulta'
  
  print @SQL 

  --Executando a procedure
  exec (@SQL)

