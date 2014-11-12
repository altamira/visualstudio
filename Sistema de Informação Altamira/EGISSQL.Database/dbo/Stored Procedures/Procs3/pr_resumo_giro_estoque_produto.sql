
create procedure pr_resumo_giro_estoque_produto

@ic_parametro int,
@cd_parametro_giro_estoque int

as

-----------------------------------------------------------
if @ic_parametro = 1 -- Resumo
-----------------------------------------------------------
begin
  declare @vl_total float

-- Verificação da tabela de Parâmetro de Análise do SCE
  select
    qt_dia_inicial_estoque,
    qt_dia_final_estoque,
    cd_parametro_giro_estoque,    
    nm_parametro_giro_estoque,
    qt_ordem_giro_estoque
  into
    #Periodo
  from
    Parametro_Giro_Estoque

--Montagem do Arquivo com os Valores por Dia
  select
    me.cd_produto,
    me.cd_fase_produto,
    me.cd_unidade_medida,
    cast(( convert(datetime,convert( varchar(10),getdate(),101),101) - max(me.dt_movimento_estoque) ) as int) as 'DiasAtraso',
    isnull(sum(pc.vl_custo_produto),0) as 'Valor_Custo',
    isnull(sum(me.qt_movimento_estoque),0) as 'Qtd'
  into #Movimento
  from
    Movimento_estoque me
  left outer join Produto_Custo pc on
    me.cd_produto=pc.cd_produto
  where
    me.qt_movimento_estoque > 0  and
    isnull(me.dt_movimento_estoque,'') <> ''
  group by 
    me.cd_produto,
    me.cd_fase_produto,
    me.cd_unidade_medida
  order by
    1

  select
    p.cd_parametro_giro_estoque,
    sum(d.Valor_Custo) as 'Valor_Custo',
    sum(d.Qtd) as 'Qtd',
    count('x') as 'QtdProduto'
  into #Temp
  from
    #Periodo p 
  inner join #Movimento d on 
    d.DiasAtraso between p.qt_dia_inicial_estoque and p.qt_dia_final_estoque
  group by
    p.cd_parametro_giro_estoque

  set @vl_total = (select sum(Qtd) from #Temp)

  select 
    t.*,
    p.nm_parametro_giro_estoque,
    ((t.Qtd * 100) / @vl_total ) as 'perc'
  from
    #Temp t
  left outer join #Periodo p on 
    p.cd_parametro_giro_estoque = t.cd_parametro_giro_estoque
  order by
    p.qt_ordem_giro_estoque

end

----------------------------------------------
else -- Produto referentes ao Resumo selecionado
----------------------------------------------
begin
  declare @vl_totals float

-- Verificação da tabela de Parâmetro de Análise do SCE
  select
    qt_dia_inicial_estoque,
    qt_dia_final_estoque,
    cd_parametro_giro_estoque,    
    nm_parametro_giro_estoque,
    qt_ordem_giro_estoque
  into
    #Periodo_1
  from
    Parametro_Giro_Estoque 
  where
    cd_parametro_giro_estoque = @cd_parametro_giro_estoque

--Montagem do Arquivo com os Valores por Dia
  select
    me.cd_produto,
    me.cd_unidade_medida,
    me.cd_fase_produto,
    cast(( convert(datetime,convert( varchar(10),getdate(),101),101) - max(me.dt_movimento_estoque) ) as int) as 'DiasAtraso',
    isnull(sum(me.qt_movimento_estoque),0) as 'Qtd'
  into #Movimento_1
  from
    Movimento_estoque me
  where
    me.qt_movimento_estoque > 0  and
    isnull(me.dt_movimento_estoque,'') <> ''
  group by 
     me.cd_produto, 
     me.cd_unidade_medida,
     me.cd_fase_produto
  order by
    1

  select
    d.cd_produto,
    d.cd_fase_produto,
    d.cd_unidade_medida,
    sum(d.Qtd) as 'Qtd'
  into #Temp_1
  from
    #Periodo_1 p 
  inner join #Movimento_1 d on 
    d.DiasAtraso between p.qt_dia_inicial_estoque and p.qt_dia_final_estoque
  group by
    d.cd_produto,
    d.cd_fase_produto,
    d.cd_unidade_medida

  select
    t1.cd_produto,
    t1.cd_fase_produto, 
    t1.cd_unidade_medida,
    (select max(x.dt_movimento_estoque) 
     from
       Movimento_estoque x 
     inner join Tipo_Movimento_Estoque tme on 
       tme.cd_tipo_movimento_estoque = x.cd_tipo_movimento_estoque 
     where
       x.cd_produto = t1.cd_produto and
       tme.ic_mov_tipo_movimento = 'E') as dt_ultima_entrada,
    (select max(x.dt_movimento_estoque) 
     from
       Movimento_estoque x 
     inner join Tipo_Movimento_Estoque tme on 
       tme.cd_tipo_movimento_estoque = x.cd_tipo_movimento_estoque 
     where
       x.cd_produto = t1.cd_produto and
       tme.ic_mov_tipo_movimento = 'S') as dt_ultima_venda,
    sum(t1.Qtd) as 'Qtd',
    cast(( GetDate() - (select max(x.dt_movimento_estoque) 
                        from
                          Movimento_estoque x 
                        inner join Tipo_Movimento_Estoque tme on 
                          tme.cd_tipo_movimento_estoque = x.cd_tipo_movimento_estoque 
                        where
                          x.cd_produto = t1.cd_produto and
                          tme.ic_mov_tipo_movimento = 'S')) as integer) as 'Giro'
  into #Temp_2
  from
    #Temp_1 t1
  group by
    t1.cd_produto,
    t1.cd_fase_produto, 
    t1.cd_unidade_medida


  select 
    *,
    fp.nm_fase_produto, 
    p.cd_mascara_produto, 
    p.nm_fantasia_produto, 
    p.nm_produto, 
    um.sg_unidade_medida
  from #Temp_2 t2
  left outer join Fase_Produto fp on 
    t2.cd_fase_produto = fp.cd_fase_produto 
  left outer join Produto p on 
    t2.cd_produto = p.cd_produto 
  left outer join Unidade_Medida um on
    t2.cd_unidade_medida = um.cd_unidade_medida 
end

