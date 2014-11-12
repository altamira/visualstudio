
-------------------------------------------------------------------------------
--pr_consulta_reajuste_data
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Retorno do Reajuste Definitivo, caso tenha sido processado indevidamente 
--                   pelo usuário
--Data             : 21/02/2005
--Atualizado       : 23.06.2005 - Acerto do código do Reajuste de preço
--------------------------------------------------------------------------------------------------
create procedure pr_consulta_reajuste_data
@dt_base          datetime,
@ic_tipo_processo char(1) -- V-Venda
                          -- C-Custo
as
--------------------------------------------------------------------------------------------------
--Consulta
--------------------------------------------------------------------------------------------------
  select
    ph.dt_historico_produto    as Data,
    gp.nm_grupo_produto        as GrupoProduto,
    ph.cd_produto              as cd_produto,
    p.cd_mascara_produto       as Codigo,
    p.nm_fantasia_produto      as Fantasia,
    p.nm_produto               as Descricao,
    um.sg_unidade_medida       as Unidade,
    p.vl_produto               as ValorAtual,
    ph.vl_historico_produto    as ValorAnterior,
    case when p.vl_produto>0 then 
        cast(((p.vl_produto / ph.vl_historico_produto) - 1) * 100 as money) else 0 end as Variacao,
    ph.cd_usuario,
    u.nm_fantasia_usuario      as Usuario,
    tr.nm_tipo_reajuste        as TipoReajuste,
    mr.nm_motivo_reajuste      as MotivoReajuste,
    gpp.cd_mascara_grupo_preco as MascaraCodigoPreco, 
    gpp.nm_grupo_preco_produto as GrupoPreco,
    'Produto'                  as 'Tipo'
  from
    Produto_Historico ph 
    left outer join Produto p               on p.cd_produto               = ph.cd_produto
    left outer join Produto_Custo pc        on pc.cd_produto              = p.cd_produto
    left outer join Grupo_Produto gp        on gp.cd_grupo_produto        = p.cd_grupo_produto
    left outer join Unidade_medida um       on um.cd_unidade_medida       = p.cd_unidade_medida
    left outer join egisadmin.dbo.usuario u on u.cd_usuario               = ph.cd_usuario
    left outer join Tipo_Reajuste tr        on tr.cd_tipo_reajuste        = ph.cd_tipo_reajuste
    left outer join Motivo_Reajuste mr      on mr.cd_motivo_reajuste      = ph.cd_motivo_reajuste
    left outer join Grupo_Preco_Produto gpp on gpp.cd_grupo_preco_produto = pc.cd_grupo_preco_produto
  where
    cast( cast(ph.dt_historico_produto as int) as DateTime) between @dt_base and @dt_base + 1 and
    ph.ic_tipo_historico_produto = @ic_tipo_processo
  
  Union

  select
    sh.dt_servico_historico            as Data,
    gp.nm_grupo_produto                as GrupoProduto,
    sh.cd_servico                      as cd_produto,
    s.cd_mascara_servico               as Codigo,
    cast( s.nm_servico as varchar(15)) as Fantasia,
    s.nm_servico                       as Descricao,
    um.sg_unidade_medida               as Unidade,
    s.vl_servico                       as ValorAtual,
    sh.vl_servico_historico            as ValorAnterior,
    case when s.vl_servico>0 then 
        cast(((s.vl_servico / sh.vl_servico_historico) - 1) * 100 as money) else 0 end as Variacao,
    sh.cd_usuario,
    u.nm_fantasia_usuario              as Usuario,
    tr.nm_tipo_reajuste                as TipoReajuste,
    ''                                 as MotivoReajuste,
    gpp.cd_mascara_grupo_preco         as MascaraCodigoPreco, 
    gpp.nm_grupo_preco_produto         as GrupoPreco,
    'Serviço'                           as 'Tipo'
  from
    Servico_Historico sh 
    left outer join Servico s               on s.cd_servico               = sh.cd_servico
    left outer join Grupo_Produto gp        on gp.cd_grupo_produto        = s.cd_grupo_produto
    left outer join Unidade_medida um       on um.cd_unidade_medida       = s.cd_unidade_medida
    left outer join egisadmin.dbo.usuario u on u.cd_usuario               = sh.cd_usuario
    left outer join Tipo_Reajuste tr        on tr.cd_tipo_reajuste        = sh.cd_tipo_reajuste
    left outer join Grupo_Preco_Produto gpp on gpp.cd_grupo_preco_produto = s.cd_grupo_preco_produto
  where
    cast( cast(sh.dt_servico_historico as int) as DateTime) between @dt_base and @dt_base + 1
    --and sh.ic_tipo_historico_servico = @ic_tipo_processo
