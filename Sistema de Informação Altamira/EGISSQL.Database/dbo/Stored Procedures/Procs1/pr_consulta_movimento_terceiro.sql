
CREATE PROCEDURE pr_consulta_movimento_terceiro
---------------------------------------------------
--GBS - Global Business Solution	       2003
--Stored Procedure: Microsoft SQL Server       2000
--Autor(es)       : Johnny Mendes de Souza
--Banco de Dados  : EgisSQL
--Objetivo        : Consulta de Movimentação no Estoque por Produto e Terceiro
--Data            : 25/02/2003
--Atualizado      : 
---------------------------------------------------
@ic_parametro		int,
@cd_produto             int,
@cd_fase_produto        int,
@dt_inicial             datetime,
@dt_final               datetime

AS

declare 
@cd_movimento_estoque       int, 
@Saldo_Inicial              float,
@Entrada                    float,
@Saida                      float,
@Saldo                      float,
@vl_saldo_inicial           float,
@vl_saldo_anterior          float

set @vl_saldo_inicial       = 0
set @vl_saldo_anterior      = 0
set @Entrada                = 0
set @Saida                  = 0
set @Saldo                  = 0


-------------------------------------------------------------------------------
-- Achando o Saldo Final do Mês Anterior 
-------------------------------------------------------------------------------
  EXECUTE pr_saldo_inicial 
          1, @dt_inicial, @dt_final, @cd_produto, @cd_fase_produto, @vl_saldo_inicial=@vl_saldo_inicial output
  print('Saldo Inicial Total: '+cast(@vl_saldo_inicial as varchar))

-------------------------------------------------------------------------------
if @ic_parametro = 1    -- Consulta Movimentação do Estoque do Produto e Terceiro 
-------------------------------------------------------------------------------
begin

  declare cMovimento_Estoque cursor for
  select 
    me.cd_movimento_estoque, 
    isnull(@vl_saldo_inicial,0.00) as 'Saldo_Inicial',
    case 
      when tme.ic_mov_tipo_movimento = 'E'
      then (me.qt_movimento_estoque) 
      else 0 
    end as 'Entrada',
    case
      when ic_mov_tipo_movimento = 'S'
      then (me.qt_movimento_estoque) 
      else 0 
    end as 'Saida',
    0.00 as Saldo

  from 
    Movimento_Estoque me left outer join 
    Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque
  where 
    isnull(me.ic_terceiro_movimento,'N') = 'S' and
    me.cd_produto      = @cd_produto and
    me.cd_fase_produto = @cd_fase_produto and
    me.dt_movimento_estoque between @dt_inicial and @dt_final
  order by 
    me.dt_movimento_estoque, 
    me.cd_movimento_estoque

  select    
    me.cd_movimento_estoque,
    td.nm_tipo_destinatario,
    me.nm_destinatario,
    tme.nm_tipo_movimento_estoque,
    me.dt_movimento_estoque,
    he.nm_historico_estoque,
    me.nm_historico_movimento,
    isnull(@vl_saldo_inicial,0.00) as 'Saldo_Inicial',
    case when tme.ic_mov_tipo_movimento = 'E'
      then (me.qt_movimento_estoque) 
      else 0 
    end as 'Entrada',
    case 
      when ic_mov_tipo_movimento = 'S' 
      then (me.qt_movimento_estoque) 
      else 0 
    end as 'Saida',
    cast(0.00 as float) as Saldo

  into
    #Movimento_Estoque1

  from 
    Movimento_Estoque me left outer join 
    Tipo_Movimento_Estoque tme on tme.cd_tipo_movimento_estoque = me.cd_tipo_movimento_estoque Left Outer Join
    Tipo_documento_estoque tde on me.cd_tipo_documento_estoque = tde.cd_tipo_documento_estoque Left Outer Join
    Tipo_Destinatario td on me.cd_tipo_destinatario = td.cd_tipo_destinatario Left Outer Join
    Produto p on me.cd_produto = p.cd_produto left outer join
    Historico_Estoque he on me.cd_historico_estoque = he.cd_historico_estoque
  where 
    isnull(me.ic_terceiro_movimento,'N') = 'S' and
    me.cd_produto = @cd_produto and
    me.cd_fase_produto = @cd_fase_produto and
    me.dt_movimento_estoque between @dt_inicial and @dt_final
  order by 
    me.dt_movimento_estoque, 
    me.cd_movimento_estoque

  open cMovimento_Estoque
  fetch next from cMovimento_Estoque 
  into
    @cd_movimento_estoque, 
    @Saldo_Inicial,
    @Entrada,
    @Saida,
    @Saldo  

  set @vl_saldo_anterior  = @vl_saldo_inicial
  while @@fetch_Status = 0
  begin            

    set @vl_saldo_anterior = @vl_saldo_anterior + @Entrada - @Saida    

    update
      #Movimento_Estoque1
    set
      Saldo = @vl_saldo_anterior
    where
      cd_movimento_estoque = @cd_movimento_estoque

    fetch next from cMovimento_Estoque 
    into
      @cd_movimento_estoque, 
      @Saldo_Inicial,
      @Entrada,
      @Saida,
      @Saldo  

  end
  close cMovimento_Estoque
  deallocate cMovimento_Estoque

  select 
    * 
  from 
    #Movimento_Estoque1 


end

-------------------------------------------------------------------------------
if @ic_parametro = 2    -- Consulta Saldo do Produto
-------------------------------------------------------------------------------
  begin
    select
      ps.cd_produto,
      isnull(ps.qt_saldo_atual_produto,0.00)                    as 'Atual',
      isnull(ps.qt_saldo_reserva_produto,0.00)                  as 'Reserva',
      isnull(ps.qt_pd_compra_produto,0.00)                      as 'Compra',
      isnull(ps.qt_req_compra_produto,0.00)                     as 'Requisicao',
      isnull(ps.qt_terceiro_produto,0.00)                       as 'Terceiro',
      isnull(ps.qt_consig_produto,0.00)                         as 'Consignacao',
      isnull(ps.qt_consumo_produto,0.00)                        as 'Consumo',
      isnull(ps.qt_minimo_produto,0.00)                         as 'Minimo',
      isnull((ps.qt_saldo_reserva_produto / 
             (case len(Rtrim(Ltrim(cast(ps.qt_consumo_produto as varchar(30)))))
                   when 1 then Replace(ps.qt_consumo_produto, 0, 1)
                   else ps.qt_consumo_produto end)) * 30, 0.00) as 'Duracao'
    from Produto_Saldo ps
    where ps.cd_produto      = @cd_produto and
          ps.cd_fase_produto = @cd_fase_produto
  end  

-------------------------------------------------------------------------------
if @ic_parametro = 3    -- Zera Procedure
-------------------------------------------------------------------------------
  begin
    select 
      0         as 'cd_movimento_estoque', 
      getdate() as 'dt_movimento_estoque',
      ''        as 'ic_consig_movimento',
      ''        as 'ic_terceiro_movimento',
      ''        as 'nm_historico_movimento',
      0.00      as 'Saldo_Inicial',
      0.00      as 'Entrada',
      0.00      as 'Saida',
      0.00      as 'Saldo',
      0.00      as 'Saldo_Final'
    where 1 = 2
    end
