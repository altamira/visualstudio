
-------------------------------------------------------------------------------
--pr_atualizacao_flag_fechamento_mensal
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2005
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server       2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisSQL
--Objetivo         : Atualização Automática do Flag de Fechamento mensal de Estoque
--                   Grupo de Produto / Produto
--Data             : 19.10.2005
--Atualizado       : 19.10.2005
-----------------------------------------------------------------------------------
create procedure pr_atualizacao_flag_fechamento_mensal
@cd_grupo_produto int = 0
as

--Geração de Registros na Tabela Grupo Produto Custo / Produto Custo

insert into Grupo_produto_Custo ( cd_grupo_produto )
select
  cd_grupo_produto
from
  Grupo_Produto
where
  cd_grupo_produto not in ( select cd_grupo_produto from Grupo_Produto_Custo ) 

--Produto_Custo

insert into Produto_Custo ( cd_produto )
select
  cd_produto
from
  Produto
where
  cd_produto not in ( select cd_produto from Produto_Custo ) 


--Grupo de Produto

update
  grupo_produto_custo
set
  ic_fechamento_mensal = 'S'
where
 cd_grupo_produto = case when @cd_grupo_produto = 0 then cd_grupo_produto else @cd_grupo_produto end and
 isnull(ic_fechamento_mensal,'N') = 'N'


--Produto

update
 produto_custo
set
 ic_fechamento_mensal_prod = 'S'
from
  Produto_Custo pc
  left outer join Produto       p         on p.cd_produto         = pc.cd_produto 
  left outer join Grupo_Produto gp        on gp.cd_grupo_produto  = p.cd_grupo_produto
where
  p.cd_grupo_produto = case when @cd_grupo_produto = 0 then p.cd_grupo_produto else @cd_grupo_produto end and
  isnull(pc.ic_fechamento_mensal_prod,'N')='N' 

-- select
--  p.cd_produto,
--  pc.ic_fechamento_mensal_prod
-- from
--   Produto p
--   left outer join Grupo_Produto gp        on gp.cd_grupo_produto  = p.cd_grupo_produto
--   left outer join Grupo_Produto_Custo gpc on gpc.cd_grupo_produto = p.cd_grupo_produto
--   inner join Produto_Custo pc        on pc.cd_produto        = p.cd_produto 
-- where
--   p.cd_grupo_produto = case when @cd_grupo_produto = 0 then p.cd_grupo_produto else @cd_grupo_produto end and
--   isnull(pc.ic_fechamento_mensal_prod,'N')='N' 
-- 


