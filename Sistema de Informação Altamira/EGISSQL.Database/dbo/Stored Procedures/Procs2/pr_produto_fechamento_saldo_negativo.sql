Create procedure pr_produto_fechamento_saldo_negativo
--pr_produto_fechamento_saldo_negativo
---------------------------------------------------
--GBS-Global Business Solution Ltda
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Fabio
--Banco de Dados  : EGISSQL
--Objetivo        : Realiza a verificação dos produto que irão ficar com 
--                  saldo negativo no fechamento
--Data            : 05/05/2004 - Acerto para trazer somente
-- as movimentações referentes ao estoque real. - Daniel C. Neto.
-- 05/05/2004 - Pegar o último fechamento antes da data base informada. - Daniel C. Neto.
-- 09/02/2005 - Acertos Gerais de Problemas encontrados na SMC - ELIAS
---------------------------------------------------
  @cd_mes integer,
  @cd_ano integer,
  @dt_base Datetime
as
begin


  declare @dt_inicial datetime
  declare @dt_final datetime
  declare @dt_saldo_inicial datetime

  select @dt_inicial = cast(cast(@cd_mes as varchar)+'/01/'+
                         cast(@cd_ano as varchar) as datetime)

  select @dt_final = dateadd(d,-1,dateadd(m,1,@dt_inicial))

  select @dt_saldo_inicial = dateadd(d,-1,cast(cast(@cd_mes as varchar)+'/01/'+
                         cast(@cd_ano as varchar) as datetime))


  select 
    me.cd_produto,    
    me.cd_fase_produto,
    cast(sum(case when tme.ic_mov_tipo_movimento = 'E'
      then (me.qt_movimento_estoque) 
      else 0 
    end) as decimal(15,3)) as 'Entrada',
    cast(sum(case 
      when tme.ic_mov_tipo_movimento = 'S' 
      then (me.qt_movimento_estoque) 
      else 0 
    end) as decimal(15,3)) as 'Saida'
  into
    #Movimento_Estoque
  from 
    Movimento_Estoque me 
      left outer join 
    Tipo_Movimento_Estoque tme  
      on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
  where 
    me.dt_movimento_estoque between @dt_inicial and @dt_final and
    tme.nm_atributo_produto_saldo='qt_saldo_atual_produto'
  group by
    me.cd_produto,
    me.cd_fase_produto

select cd_produto, cd_fase_produto,
  cast(qt_atual_prod_fechamento as decimal(15,3)) as Inicial
into
  #Saldo_Inicial
from Produto_Fechamento
where
  dt_produto_fechamento = @dt_saldo_inicial
order by dt_produto_fechamento desc

select
  p.cd_produto,
  dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, p.cd_mascara_produto) as cd_mascara_produto,
  p.nm_produto,
  p.nm_fantasia_produto,
  un.sg_unidade_medida,
  (isnull(i.Inicial,0) + isnull(m.Entrada,0) - isnull(m.Saida,0)) as qt_saldo_atual_produto,
  dbo.fn_produto_localizacao(m.cd_produto, m.cd_fase_produto) as nm_localizacao,
  fp.nm_fase_produto
from
  #Movimento_Estoque m 
  left outer join #Saldo_Inicial i on 
    m.cd_produto = i.cd_produto and m.cd_fase_produto = i.cd_fase_produto 
  left outer join Produto p on 
    m.cd_produto = p.cd_produto
  left outer join Grupo_Produto gp on
    gp.cd_grupo_produto = p.cd_grupo_produto
  left outer join Unidade_Medida un on
    un.cd_unidade_medida = p.cd_unidade_medida
  left outer join Fase_Produto fp on
    fp.cd_fase_produto = m.cd_fase_produto
  left outer join Produto_Custo pc on
    m.cd_produto = pc.cd_produto
where
  (isnull(i.Inicial,0) + (isnull(m.Entrada,0) - isnull(m.Saida,0)) < 0)
  and pc.ic_fechamento_mensal_produto = 'S'
  and ic_venda_saldo_negativo         = 'N'
  and ic_estoque_produto	      = 'S'
order by
  4

drop table #Movimento_Estoque
drop table #Saldo_Inicial
end

