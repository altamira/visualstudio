
-------------------------------------------------------------------------------
--sp_helptext pr_posicao_saldo_diario_produto
-------------------------------------------------------------------------------
--pr_posicao_saldo_diario_produto
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2009
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Consulta de Posição de Saldo Diário por Produto
--Data             : 07.12.2009
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_posicao_saldo_diario_produto
@ic_parametro    int      = 0,
@dt_inicial      datetime = '',
@dt_final        datetime = '',
@dt_saldo        datetime = '',
@cd_fase_produto int      = 0,
@cd_produto      int      = 0

as

select
  p.cd_produto,
  p.cd_mascara_produto,
  p.nm_fantasia_produto,
  p.nm_produto,
  gp.nm_grupo_produto,
  sp.nm_status_produto,
  cp.nm_categoria_produto


from
  Produto p
  left outer join grupo_produto  gp    on gp.cd_grupo_produto     = p.cd_grupo_produto
  left outer join status_produto sp    on sp.cd_status_produto    = p.cd_status_produto
  left outer join categoria_produto cp on cp.cd_categoria_produto = p.cd_categoria_produto

where
  --select * from status_produto
  isnull(sp.ic_bloqueia_uso_produto,'N')='N'

order by
  p.nm_fantasia_produto


