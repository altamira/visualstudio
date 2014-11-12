create PROCEDURE pr_diferenca_saldo_produto

--@cd_fase_produto as int,
@cd_mes int,
@cd_ano int,
@ic_processa_acerto char(1) = 'N'

as


  declare @dt_inicial datetime
  declare @dt_final datetime
  declare @dt_saldo_inicial datetime

  select @dt_inicial = cast(cast(@cd_mes as varchar)+'/01/'+
                         cast(@cd_ano as varchar) as datetime)

  select @dt_final = dateadd(d,-1,dateadd(m,1,@dt_inicial))

  select @dt_saldo_inicial = dateadd(d,-1,cast(cast(@cd_mes as varchar)+'/01/'+
                         cast(@cd_ano as varchar) as datetime))

  select 
    p.cd_fase_produto,
    p.cd_mascara_produto,
    p.nm_fantasia_produto,
    p.cd_grupo_produto,
    p.cd_produto,    
    cast(sum(case when m.ic_mov_tipo_movimento = 'E'
      then (isnull(m.qt_movimento_estoque,0)) 
      else 0 
    end) as decimal(15,3)) as 'Entrada',
    cast(sum(case 
      when m.ic_mov_tipo_movimento = 'S' 
      then (isnull(m.qt_movimento_estoque,0)) 
      else 0 
    end) as decimal(15,3)) as 'Saida'
  into
    #Movimento_Estoque
  from 
    (select p.cd_produto, p.cd_mascara_produto,
            p.nm_fantasia_produto, p.cd_grupo_produto,
            fp.cd_fase_produto 
     from produto p, fase_produto fp) p
  left outer join
    (select me.cd_produto,
            me.cd_fase_produto,
            me.qt_movimento_estoque,
            tme.ic_mov_tipo_movimento
     from Movimento_Estoque me,
          Tipo_Movimento_Estoque tme
     where me.dt_movimento_estoque between @dt_inicial and @dt_final and
           tme.nm_atributo_produto_saldo='qt_saldo_atual_produto' and
           me.cd_tipo_movimento_estoque = tme.cd_tipo_movimento_estoque) m on 
    p.cd_fase_produto = m.cd_fase_produto and
    p.cd_produto = m.cd_produto
  group by
    p.cd_fase_produto,
    p.cd_produto,
    p.nm_fantasia_produto,
    p.cd_mascara_produto,
    p.cd_grupo_produto

select cd_produto, cd_fase_produto,
  cast(qt_atual_prod_fechamento as decimal(15,3)) as Inicial
into
  #Saldo_Inicial
from Produto_Fechamento
where
  dt_produto_fechamento = @dt_saldo_inicial 


select cd_produto,cd_fase_produto,
  cast(qt_saldo_atual_produto as decimal(15,3)) as Final
into
  #Saldo_Final
from Produto_Saldo
-- where
--   dt_produto_fechamento = @dt_final 

select
  m.cd_fase_produto as Fase,
  dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, m.cd_mascara_produto) as Codigo,
  m.cd_produto as CodSistema,
  m.nm_fantasia_produto as Fantasia,
  isnull(i.Inicial,0)   as Inicial,
  isnull(m.Entrada,0)   as Entrada,
  isnull(m.Saida,0)     as Saida,
  isnull(f.Final,0)     as Final,
  (isnull(i.Inicial,0) + isnull(m.Entrada,0) - isnull(m.Saida,0)) as Correto,
  ((isnull(i.Inicial,0) + isnull(m.Entrada,0) - isnull(m.Saida,0)) - isnull(f.Final,0)) as Diferenca
into
  #Diferenca_Fechamento
from
  #Movimento_Estoque m 
  left outer join #Saldo_Inicial i on 
    m.cd_produto = i.cd_produto and m.cd_fase_produto = i.cd_fase_produto
  left outer join #Saldo_Final f on 
    m.cd_produto = f.cd_produto and m.cd_fase_produto = f.cd_fase_produto
  left outer join Grupo_Produto gp on
    gp.cd_grupo_produto = m.cd_grupo_produto
--select * from grupo_produto  
where
  (isnull(i.Inicial,0) + (isnull(m.Entrada,0) - isnull(m.Saida,0))) - isnull(f.Final,0) <> 0

if (@ic_processa_acerto = 'S')
begin

  update Produto_Saldo
  set qt_saldo_atual_produto = Correto,
      qt_entrada_produto = Entrada,
      qt_saida_produto = Saida
  from #Diferenca_Fechamento, Produto_Saldo
  where cd_produto = CodSistema and
        cd_fase_produto = Fase 

end
else
begin

  select * from #Diferenca_Fechamento order by 4,1

end


drop table #Movimento_Estoque
drop table #Saldo_Inicial
drop table #Saldo_Final

