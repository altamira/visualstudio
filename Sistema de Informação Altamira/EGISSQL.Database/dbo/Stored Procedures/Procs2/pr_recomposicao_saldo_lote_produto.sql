
-------------------------------------------------------------------------------
--pr_recomposicao_saldo_lote_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Recomposição dos Saldos de Lote do Produto
--Data             : 24.10.2005
--Atualizado       : 28/10/2005 - Acertos Diversos - Carlos Fernandes
--                 : 30.10.2005 
--
--                 : 18.03.2006 - Verificação - Carlos Fernandes
--                 : 22.05.2006 - Atualização e Verificação da Procedure - Carlos Fernandes
--                 : 05.08.2006 - Recomposição por Lote Individual - Carlos Fernandes
--                 : 05.04.2007 - Acertos Gerais - Anderson/Carlos
--                 : 08.10.2007 - Verificação - Carlos Fernandes
-- 18.11.2010 - Ajustes Diversos - Carlos Fernandes
--------------------------------------------------------------------------------------------------
create procedure pr_recomposicao_saldo_lote_produto
@cd_lote_informado varchar(25) = '',
@dt_inicial        datetime    = '',
@dt_final          datetime    = ''

as


--select * from fechamento_mensal order by cd_ano,cd_mes

declare @cd_ano int
declare @cd_mes int

select
  top 1
  @cd_ano = cd_ano,
  @cd_mes = cd_mes
from 
  fechamento_mensal with (nolock)
where
  isnull(ic_mes_fechado,'N') = 'S'
order by
  cd_ano desc, cd_mes desc



--exec pr_recomposicao_saldo_lote_produto  @cd_lote_informado = ' Não Filtrar'


--Checa o parâmetro para processamento de TODOS OS LOTES

if @cd_lote_informado = ' Não Filtrar'
begin
   set @cd_lote_informado = ''
end


--select cd_lote_produto,* from movimento_estoque

--Gera todos os Lotes do movimento de Estoque na Tabela Lote/Lote Item

select
  isnull(me.cd_lote_produto,'')          as cd_lote_produto,
  isnull(me.cd_produto,0)                as cd_produto,
  max(isnull(lp.cd_lote_produto,0))      as lote,
  max(isnull(lp.nm_ref_lote_produto,'')) as ref,
  max(p.nm_fantasia_produto)             as fantasia

into #lote
from
  movimento_estoque me            with (nolock) 
  left outer join lote_produto lp with (nolock) on lp.nm_ref_lote_produto = me.cd_lote_produto
  inner join produto p            with (nolock) on p.cd_produto           = me.cd_produto
where
  me.cd_lote_produto = case when isnull(@cd_lote_informado,'') = '' then me.cd_lote_produto else @cd_lote_informado end and
  me.cd_lote_produto is not null      and
  isnull(me.cd_lote_produto,'') <> '' 
group by
  me.cd_lote_produto,
  me.cd_produto
order by
  me.cd_lote_produto, me.cd_produto

--selelect * from #lote order by fantasia

declare @lote                int
declare @cd_lote_produto     int
declare @nm_ref_lote_produto varchar(25)
declare @cd_produto          int

while exists ( select top 1 lote from #lote )
begin

  set @cd_lote_produto = 0

  select top 1 
    @nm_ref_lote_produto = cd_lote_produto,
    @lote                = lote,
    @cd_produto          = isnull(cd_produto,0)
  from
    #lote
  order by 
    cd_produto

--  print @lote
--  print @nm_ref_lote_produto 
 
  if isnull(@lote,0)=0 and isnull(@nm_ref_lote_produto,'')<>'' and @cd_produto>0
  begin 

    select top 1 @cd_lote_produto = isnull(cd_lote_produto,0)+1 from Lote_Produto order by cd_lote_produto desc

--    print 'aqui'
--    print 'Código do Lote : '+cast( @cd_lote_produto as varchar )

    --SELECT * FROM LOTE_PRODUTO

    insert into Lote_produto
     select
      @cd_lote_produto,
      @nm_ref_lote_produto,
      @nm_ref_lote_produto,
      'A',
      getdate(),
      getdate(),
      getdate(),
      'S',
      getdate(),
      'S',
      1,
      0,   
      0,   
      getdate(),
      'Gerado Automaticamente recomposição',
      null,
      null,
      'S',
       0 

    --item

    insert Lote_Produto_item
      (cd_lote_produto,
       cd_produto,
       qt_produto_lote_produto )
    values
       (@cd_lote_produto, 
        @cd_produto,
        0 )

    set @lote = @cd_lote_produto

  end

  select
    @cd_lote_produto = isnull(cd_lote_produto,0)
  from
    Lote_produto_item
  where
    cd_lote_produto = @lote and
    cd_produto      = @cd_produto  
  
  --Verifica se existe o item na tabela Lote_produto_item
  --select * from lote_produto_item 
  --select * from lote_produto_item where cd_lote_produto = 69 and cd_produto = 23878
  --select * from lote_produto_item where cd_produto = 23878

   if @cd_lote_produto=0 and @cd_produto>0
--and 
--       not exists(select cd_lote_produto from Lote_Produto_Item where @lote            = cd_lote_produto and
--                                                                      @cd_produto      = cd_produto   )
   begin
    --item
    insert Lote_Produto_item
      (cd_lote_produto,
       cd_produto,
       qt_produto_lote_produto ) values
       (@lote, 
        @cd_produto, 0 )

    --print 'aqui x'

  end

  delete from #lote where @nm_ref_lote_produto = cd_lote_produto 

end

  --Total do Movimento de Entrada/Saída
  --Real

  select 
    me.cd_lote_produto as Lote,
    me.cd_produto      as Produto,
    sum( case when tme.ic_mov_tipo_movimento =  'E'
              then isnull(me.qt_movimento_estoque,0.00)
              else 0.00
         end ) qt_entrada,

    sum( case when tme.ic_mov_tipo_movimento =  'S'
              then isnull(me.qt_movimento_estoque,0.00)
              else 0.00
         end ) qt_saida
  into 
    #EntradaSaidaAtual
  from 
    Movimento_Estoque      me  left outer join 
    Tipo_Movimento_Estoque tme on  tme.cd_tipo_movimento_estoque=me.cd_tipo_movimento_estoque 
  where 
    tme.nm_atributo_produto_saldo = 'qt_saldo_atual_produto' and
    me.cd_lote_produto = case when isnull(@cd_lote_informado,'') = '' then me.cd_lote_produto else @cd_lote_informado end and
    me.cd_lote_produto is not null and
    isnull(me.cd_lote_produto,'') <> ''       
    --me.cd_lote_produto is not null and
    --me.cd_lote_produto <> ''
  group by
    me.cd_lote_produto,
    me.cd_produto

--Saída Real que terá que ser deduzida da Reserva

  select 
    me.cd_lote_produto as Lote,
    me.cd_produto      as Produto,
    sum( 0.00 )        as qt_entrada,

    sum( case when tme.ic_mov_tipo_movimento =  'S'
              then isnull(me.qt_movimento_estoque,0.00)
              else 0.00
         end ) qt_saida
  into 
    #SaidaAtualReserva
  from 
    Movimento_Estoque      me  left outer join 
    Tipo_Movimento_Estoque tme on  tme.cd_tipo_movimento_estoque=me.cd_tipo_movimento_estoque 
  where 
    tme.nm_atributo_produto_saldo = 'qt_saldo_atual_produto' and
    me.cd_lote_produto = case when isnull(@cd_lote_informado,'') = '' then me.cd_lote_produto else @cd_lote_informado end and
    me.cd_lote_produto is not null and
    isnull(me.cd_lote_produto,'') <> '' and
    year(me.dt_movimento_estoque) <= @cd_ano and
    month(me.dt_movimento_estoque)<= @cd_mes 

    --me.cd_lote_produto is not null and
    --me.cd_lote_produto <> ''
  group by
    me.cd_lote_produto,
    me.cd_produto

--  select * from     #EntradaSaidaAtual


  --Entrada na Reserva

  select 
    me.cd_lote_produto as LoteReserva,
    me.cd_produto      as ProdutoReserva,
    sum( case when tme.ic_mov_tipo_movimento =  'E'
              then isnull(me.qt_movimento_estoque,0.00)
              else 0.00
         end ) qt_entrada_reserva,

    sum(0.00)     qt_saida_reserva
  into 
    #EntradaReserva
  from 
    Movimento_Estoque      me  left outer join 
    Tipo_Movimento_Estoque tme on  tme.cd_tipo_movimento_estoque=me.cd_tipo_movimento_estoque 
  where 
    tme.ic_mov_tipo_movimento        =  'E' and 
    ((tme.cd_tipo_movimento_estoque  =  1)  or 
     ((tme.nm_atributo_produto_saldo =  '') or (tme.nm_atributo_produto_saldo = 'qt_saldo_reserva_produto')) or
     ((tme.nm_atributo_produto_saldo =  'qt_saldo_atual_produto') and (me.ic_tipo_lancto_movimento='M'))) and
    me.cd_lote_produto = case when isnull(@cd_lote_informado,'') = '' then me.cd_lote_produto else @cd_lote_informado end and
    me.cd_lote_produto is not null and
    isnull(me.cd_lote_produto,'') <> '' and      
    me.cd_tipo_movimento_estoque<>3     
    --and me.dt_movimento_estoque between @dt_inicial and @dt_final

--select * from movimento_estoque
    --me.cd_lote_produto is not null and
    --me.cd_lote_produto <> ''       
  group by
    me.cd_lote_produto,
    me.cd_produto

--  select * from #EntradaReserva


  --Saída na Reserva

  select 
    me.cd_lote_produto as LoteReserva,
    me.cd_produto      as ProdutoReserva,
    sum( case when tme.ic_mov_tipo_movimento =  'S'
              then isnull(me.qt_movimento_estoque,0.00)
              else 0.00
         end ) qt_saida_reserva,

    sum(0.00)     qt_entrada_reserva
  into 
    #SaidaReserva
  from 
    Movimento_Estoque      me  left outer join 
    Tipo_Movimento_Estoque tme on  tme.cd_tipo_movimento_estoque=me.cd_tipo_movimento_estoque 
  where
    ((tme.nm_atributo_produto_saldo =  'qt_saldo_reserva_produto') 
     or (me.ic_tipo_lancto_movimento   =  'M')
    )                       and
    tme.ic_mov_tipo_movimento       =  'S'                         and
    me.cd_lote_produto = case when isnull(@cd_lote_informado,'') = '' then me.cd_lote_produto else @cd_lote_informado end and
    me.cd_lote_produto is not null and
    isnull(me.cd_lote_produto,'') <> '' 
    --and me.dt_movimento_estoque between @dt_inicial and @dt_final
      
    --me.cd_lote_produto is not null and
    --me.cd_lote_produto <> ''       
  group by
    me.cd_lote_produto,
    me.cd_produto


  --select * from #SaidaReserva

--Entrada
--select * from #EntradaReserva
--order by lotereserva

--Saida
--select * from #SaidaReserva
--order by lotereserva

select
 a.LoteReserva,
 a.ProdutoReserva,
 isnull(a.qt_entrada_reserva,0.00) as qt_entrada_reserva,
 isnull(b.qt_saida_reserva,0.00) +
 isnull(c.qt_saida,0.00 )          as qt_saida_reserva
into #EntradaSaidaReserva
from
  #EntradaReserva a, 
  #SaidaReserva b,
  #SaidaAtualReserva c
where
  a.lotereserva    *= b.lotereserva     and
  a.produtoreserva *= b.produtoreserva  and
  a.lotereserva    *= c.lote            and
  a.produtoreserva *= c.produto

-- select * from #EntradaSaidaReserva
-- order by 1

select 
  a.*, 
  b.*
into
  #Resultado
from
  #EntradaSaidaAtual  a,
  #EntradaSaidaReserva b
where
  a.lote    *= b.lotereserva     and
  a.produto *= b.produtoreserva  and  
  a.lote is not null             and
  a.lote <> ''

-- select * from #Resultado
-- order by lote

 declare @cd_lote            varchar(25)
 declare @qt_entrada         float
 declare @qt_entrada_reserva float
 declare @qt_saida           float
 declare @qt_saida_reserva   float 
 declare @saldo              float

while exists( select top 1 lote from #resultado )
begin
  select 
    top 1
    @cd_lote            = lote,
    @cd_produto         = produto,
    @qt_entrada         = isnull(qt_entrada,0),
    @qt_saida           = isnull(qt_saida,0),
    @qt_entrada_reserva = isnull(qt_entrada_reserva,0),
    @qt_saida_reserva   = isnull(qt_saida_reserva,0)
  from
    #resultado
  order by
    lote

  --busca o lote do produto

  select
    @cd_lote_produto = isnull(cd_lote_produto,0)
  from
    Lote_produto
  where
    @cd_lote = nm_ref_lote_produto

  set @saldo = 0.00

  select
     @saldo=isnull(cd_lote_produto,0)
  from
     Lote_Produto_Saldo where @cd_lote_produto = cd_lote_produto and
                              @cd_produto      = cd_produto   

 -- select @saldo

 if @cd_lote_produto>0 and not exists(select cd_lote_produto from Lote_Produto_Saldo
                                                             where @cd_lote_produto = cd_lote_produto and
                                                                   @cd_produto      = cd_produto   ) and @cd_produto>0
  begin

    insert
      Lote_Produto_Saldo (
        cd_produto,
        cd_lote_produto,
        qt_saldo_reserva_lote,
        qt_saldo_atual_lote,
        cd_usuario,
        dt_usuario )
      select
        @cd_produto,
        @cd_lote_produto,
        0,
        0,
        0,
        getdate()
   end

  update
     Lote_Produto_Saldo
   set
     qt_saldo_atual_lote   = @qt_entrada         - @qt_saida,
     qt_saldo_reserva_lote = @qt_entrada_reserva - @qt_saida_reserva
   where
     cd_lote_produto = @cd_lote_produto and
     cd_produto      = @cd_produto

  delete from #resultado where @cd_lote = lote and @cd_produto = produto

end

