
-------------------------------------------------------------------------------
--GBS-Global Business Solution Ltda            2005
-------------------------------------------------------------------------------
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Elias Pereira da Silva
--Banco de Dados  : EgisSql
--Objetivo        : Acerto de Diferenças no Fechamento de Estoque, com a geração
--                  dos registros na Produto_Fechamento se for o caso.
--Data            : ???
--Atualizado      : 03/08/2005 - Inclusão do parâmetro de Fase, para ajuste somente de uma fase - ELIAS
--                : 10/08/2005 - Inclusão dos Cálculos de Peso - ELIAS
--                : 11/08/2005 - Acerto na Seleção dos Movimentos que estava filtrando indevidamente - ELIAS
--                : 30.10.2007 - Acertos Diversos - Carlos Fernandes
-- 11.11.2010 - Ajustes Diversos - Carlos Fernandes
-------------------------------------------------------------------------------

create PROCEDURE pr_diferenca_fechamento_produto
@cd_fase_produto    int,
@cd_mes             int     = 0,
@cd_ano             int     = 0,
@ic_processa_acerto char(1) = 'N',
@dt_base            datetime

as

if @dt_base is not null
begin
  set @cd_mes = month(@dt_base)
  set @cd_ano = year(@cd_ano)
end


  declare @dt_inicial       datetime
  declare @dt_final         datetime
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
    cast(sum(case when m.ic_mov_tipo_movimento = 'E'
      then (isnull(m.qt_peso_movimento_estoque,0)) 
      else 0 
    end) as decimal(15,3)) as 'PesoEntrada',
    cast(sum(case 
      when m.ic_mov_tipo_movimento = 'S' 
      then (isnull(m.qt_movimento_estoque,0)) 
      else 0 
    end) as decimal(15,3)) as 'Saida',
    cast(sum(case 
      when m.ic_mov_tipo_movimento = 'S' 
      then (isnull(m.qt_peso_movimento_estoque,0)) 
      else 0 
    end) as decimal(15,3)) as 'PesoSaida'
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
            me.qt_peso_movimento_estoque, 
            tme.ic_mov_tipo_movimento
     from Movimento_Estoque me,
          Tipo_Movimento_Estoque tme
     where me.dt_movimento_estoque between @dt_inicial and @dt_final and
           tme.nm_atributo_produto_saldo='qt_saldo_atual_produto' and
           me.cd_tipo_movimento_estoque = tme.cd_tipo_movimento_estoque) m on 
    p.cd_fase_produto = m.cd_fase_produto and
    p.cd_produto = m.cd_produto
  where
    ((@cd_fase_produto = 0) or (p.cd_fase_produto = @cd_fase_produto))
  group by
    p.cd_fase_produto,
    p.cd_produto,
    p.nm_fantasia_produto,
    p.cd_mascara_produto,
    p.cd_grupo_produto

select cd_produto, cd_fase_produto,
  cast(isnull(qt_atual_prod_fechamento,0) as decimal(15,3)) as Inicial,
  cast(isnull(qt_peso_prod_fechamento,0) as decimal(15,6)) as PesoInicial
into
  #Saldo_Inicial
from Produto_Fechamento with (nolock)
where
  dt_produto_fechamento = @dt_saldo_inicial and
  ((@cd_fase_produto = 0) or (cd_fase_produto = @cd_fase_produto))

select cd_produto,cd_fase_produto,
  cast(isnull(qt_atual_prod_fechamento,0) as decimal(15,3)) as Final,
  cast(isnull(qt_peso_prod_fechamento,0) as decimal(15,6)) as PesoFinal
into
  #Saldo_Final
from Produto_Fechamento with (nolock)
where
  dt_produto_fechamento = @dt_final and
  ((@cd_fase_produto = 0) or (cd_fase_produto = @cd_fase_produto))

select
  m.cd_fase_produto as Fase,
  dbo.fn_formata_mascara(gp.cd_mascara_grupo_produto, m.cd_mascara_produto) as Codigo,
  m.cd_produto as CodSistema,
  m.nm_fantasia_produto as Fantasia,
  i.Inicial   as Inicial,
  isnull(m.Entrada,0)   as Entrada,
  isnull(m.Saida,0)     as Saida,
  f.Final     as Final,

  (isnull(i.Inicial,0) + isnull(m.Entrada,0) - isnull(m.Saida,0)) as Correto,
  ((isnull(i.Inicial,0) + isnull(m.Entrada,0) - isnull(m.Saida,0)) - isnull(f.Final,0)) as Diferenca,

  i.PesoInicial   as PesoInicial,
  isnull(m.PesoEntrada,0)   as PesoEntrada,
  isnull(m.PesoSaida,0)     as PesoSaida,
  f.PesoFinal     as PesoFinal,

  (isnull(i.PesoInicial,0) + isnull(m.PesoEntrada,0) - isnull(m.PesoSaida,0)) as PesoCorreto,
  ((isnull(i.PesoInicial,0) + isnull(m.PesoEntrada,0) - isnull(m.PesoSaida,0)) - isnull(f.PesoFinal,0)) as PesoDiferenca

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
-- where
--   (((i.Inicial + m.Entrada - m.Saida) - f.Final) <> 0) or
--   (((i.PesoInicial + m.PesoEntrada - m.PesoSaida) - f.PesoFinal) <> 0)

if (@ic_processa_acerto = 'S')
begin

  update Produto_Fechamento
  set qt_atual_prod_fechamento = Correto,
      qt_entra_prod_fechamento = Entrada,
      qt_saida_prod_fechamento = Saida,
      qt_peso_entra_fechamento = PesoEntrada,
      qt_peso_saida_fechamento = PesoSaida,
      qt_peso_prod_fechamento = PesoCorreto
  from #Diferenca_Fechamento, Produto_Fechamento
  where cd_produto            = CodSistema and
        cd_fase_produto       = Fase and 
        dt_produto_fechamento = @dt_final

  insert into Produto_Fechamento 
    (cd_produto,
     cd_fase_produto,
     dt_produto_fechamento,
     qt_atual_prod_fechamento,
     qt_entra_prod_fechamento,
     qt_saida_prod_fechamento,
     qt_consig_prod_fechamento,
     qt_terc_prod_fechamento,
     qt_peso_entra_fechamento,
     qt_peso_saida_fechamento,
     qt_peso_prod_fechamento,
     qt_peso_terc_fechamento,
     cd_usuario,
     dt_usuario)
  select
     df.CodSistema,
     df.Fase,
     @dt_final,
     df.Correto,
     df.Entrada,
     df.Saida,     
     0,0,
     df.PesoEntrada,
     df.PesoSaida, 
     df.PesoCorreto,
     0,0, getDate()
  from #Diferenca_Fechamento df
  where not exists(select 'x' from Produto_Fechamento pf 
                   where pf.cd_produto = df.CodSistema and
                         pf.cd_fase_produto = df.Fase and
                         pf.dt_produto_fechamento = @dt_final)
end
else
begin
  select * from #Diferenca_Fechamento order by 4,1

  select df.*
  from #Diferenca_Fechamento df
  where not exists(select 'x' from Produto_Fechamento pf 
                   where pf.cd_produto = df.CodSistema and
                         pf.cd_fase_produto = df.Fase and
                         pf.dt_produto_fechamento = @dt_final)
  order by 4,1
end


drop table #Movimento_Estoque
drop table #Saldo_Inicial
drop table #Saldo_Final

