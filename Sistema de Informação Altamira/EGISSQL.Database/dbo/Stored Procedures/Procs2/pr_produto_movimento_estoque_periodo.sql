
-------------------------------------------------------------------------------
--sp_helptext pr_produto_movimento_estoque_periodo
-------------------------------------------------------------------------------
--pr_produto_movimento_estoque_periodo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : David Becker
--Banco de Dados   : Egissql
--Objetivo         : Consulta produtoscom movimentação em estoquje por periodo
--Data             : 09.09.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_produto_movimento_estoque_periodo
  
  @ic_parametro  int = 0,
  @produto       varchar(30),
  @fase          int = 0,
  @dt_inicial    datetime,
  @dt_final      datetime

as
 
--Busca todos os produtos em um determinado periodo

--declare  @dt_inicial         datetime
--declare  @dt_final           datetime

--set @dt_inicial                = isnull('2005/05/17',null)
--set @dt_final                  = isnull('2005/12/11',null)

if @ic_parametro = 0
begin

  Select 
    p.cd_produto,
    max(fp.nm_fase_produto)        as nm_fase_produto,
    max(p.cd_mascara_produto)      as cd_mascara_produto,
    max(p.nm_produto)              as nm_produto,
    max(p.nm_fantasia_produto)     as nm_fantasia_produto,
    max(um.sg_unidade_medida)      as sg_unidade_medida,
    count(me.cd_movimento_estoque) as qt_movimento_produto,
    min(me.dt_movimento_estoque)   as dt_inicial_movimento,
    max(me.dt_movimento_estoque)   as dt_final_movimento

  From 
    Produto p                              with (nolock)
    left outer join MOVIMENTO_ESTOQUE me   with (nolock) on me.cd_produto        = p.cd_produto
    left outer join FASE_PRODUTO   fp      with (nolock) on fp.cd_fase_produto   = me.cd_fase_produto
    left outer join UNIDADE_MEDIDA um      with (nolock) on um.cd_unidade_medida = p.cd_unidade_medida

  where 
--     p.nm_fantasia_produto = case when @produto = 0 then p.nm_fantasia_produto 
--                                  else @produto  end and
        me.cd_fase_produto  = @fase and
        me.dt_movimento_estoque between @dt_inicial and @dt_final

  group by
    p.cd_produto

end

if @ic_parametro = 1
begin
  Select 
    fp.nm_fase_produto,
    me.cd_produto,
    p.cd_mascara_produto,
    p.nm_produto,
    p.nm_fantasia_produto,
    p.ds_produto,
    um.sg_unidade_medida,
    me.qt_movimento_estoque,
    me.dt_movimento_estoque,
    me.dt_documento_movimento
  From 

    MOVIMENTO_ESTOQUE me
    left outer join FASE_PRODUTO   fp with(nolock) on fp.cd_fase_produto   = me.cd_fase_produto
    left outer join PRODUTO        p  with(nolock) on p.cd_produto         = me.cd_produto
    left outer join UNIDADE_MEDIDA um with(nolock) on um.cd_unidade_medida = me.cd_unidade_medida

  where p.nm_fantasia_produto = @produto and
        me.cd_fase_produto = @fase    and
        dt_movimento_estoque between @dt_inicial and @dt_final      

end

