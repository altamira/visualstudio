
CREATE PROCEDURE pr_exclusao_movimento_reserva_fechamento
@ic_parametro int,
@dt_inicial   datetime,
@dt_final     datetime

as

-------------------------------------------------------------------------------
if (@ic_parametro = 1)   -- CONSULTA DOS LANÇAMENTOS DE RESERVA GERADOS ERRONEAMENTE
-------------------------------------------------------------------------------
begin

  select
    m.dt_movimento_estoque,
    m.cd_produto,  
    p.nm_fantasia_produto,    
    m.nm_historico_movimento,
    count(*) as QtdeFechamento
  from
    movimento_estoque m,
    produto p
  where
    p.cd_produto = m.cd_produto and
    m.dt_movimento_estoque between @dt_inicial and @dt_final and
    m.cd_tipo_movimento_estoque = 2 and  
    upper(m.nm_historico_movimento) like '%FECHAMENTO%'  
  group by
    m.dt_movimento_estoque,
    m.cd_produto,
    p.nm_fantasia_produto,
    m.nm_historico_movimento
  having
    (count(*) > 1)

end

-------------------------------------------------------------------------------
if (@ic_parametro = 9)   -- Exclusão
-------------------------------------------------------------------------------
begin
  delete from
    movimento_estoque
  where
    dt_movimento_estoque      between @dt_inicial and @dt_final and
    cd_tipo_movimento_estoque = 2                 and  --Reserva
    upper(nm_historico_movimento) like '%FECHAMENTO%'  

end
