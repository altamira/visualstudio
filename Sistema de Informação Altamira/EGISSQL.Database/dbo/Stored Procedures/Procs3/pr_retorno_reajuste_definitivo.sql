
-------------------------------------------------------------------------------
--pr_retorno_reajuste_definitivo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Retorno do Reajuste Definitivo, caso tenha sido processado indevidamente 
--                   pelo usuário
--Data             : 21/02/2005
--Atualizado       : 
--------------------------------------------------------------------------------------------------
create procedure pr_retorno_reajuste_definitivo
@ic_parametro     int = 0,
@dt_base          datetime,
@ic_tipo_processo char(1) --Venda
                          --Custo
as

--------------------------------------------------------------------------------------------------
--Consulta
--------------------------------------------------------------------------------------------------

if @ic_parametro=1
begin

  select
    ph.dt_historico_produto as Data,
    ph.cd_produto,
    p.cd_mascara_produto    as Codigo,
    p.nm_fantasia_produto   as Fantasia,
    p.nm_produto            as Descricao,
    um.sg_unidade_medida    as Unidade,
    p.vl_produto            as ValorAtual,
    ph.vl_historico_produto as ValorRetorno,
    ph.cd_usuario,
    u.nm_fantasia_usuario   as Usuario           
  from
    Produto_Historico ph 
    left outer join Produto p               on p.cd_produto = ph.cd_produto
    left outer join Unidade_medida um       on um.cd_unidade_medida = p.cd_unidade_medida
    left outer join egisadmin.dbo.usuario u on u.cd_usuario = ph.cd_usuario
  where
    cast( cast(ph.dt_historico_produto as int) as DateTime) between @dt_base and @dt_base + 1 and
    ph.ic_tipo_historico_produto = @ic_tipo_processo

end

--------------------------------------------------------------------------------------------------
--Retorno
--------------------------------------------------------------------------------------------------
--select * from produto_historico

if @ic_parametro=2
begin

  --Montagem da Tabela Auxiliar

  select
    dt_historico_produto,
    cd_produto,
    vl_historico_produto,
    cd_usuario
  into
    #RetornoPreco
  from
    Produto_Historico
  where
    cast( cast(dt_historico_produto as int) as DateTime) between @dt_base and @dt_base + 1 and
    ic_tipo_historico_produto = @ic_tipo_processo

  --Atualização do Cadastro do Produto

  update
    Produto
  set
    vl_produto = vl_historico_produto
  from
    produto p, #RetornoPreco rp
  where
    p.cd_produto = rp.cd_produto

--    select * from #retornoPreco

  Delete From
    Produto_Historico
  Where
    cast( cast(dt_historico_produto as int) as DateTime) between @dt_base and @dt_base + 1 and
    ic_tipo_historico_produto = @ic_tipo_processo
end

--select * from produto where cd_produto = 24059

