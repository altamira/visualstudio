
-------------------------------------------------------------------------------
--sp_helptext pr_alteracao_status_produto_grupo
-------------------------------------------------------------------------------
--pr_alteracao_status_produto_grupo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 14.03.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_alteracao_status_produto_grupo
@cd_grupo_produto  int = 0,
@cd_status_produto int = 0

as


select
  cd_produto,
  cd_grupo_produto,
  cd_status_produto
from
  Produto
where
  cd_grupo_produto = case when @cd_grupo_produto = 0 then cd_grupo_produto else @cd_grupo_produto end

update
  produto
set
  cd_status_produto = @cd_status_produto
from
  Produto
where
  cd_grupo_produto = case when @cd_grupo_produto = 0 then cd_grupo_produto else @cd_grupo_produto end


select
  cd_produto,
  cd_grupo_produto,
  cd_status_produto
from
  Produto
where
  cd_grupo_produto = case when @cd_grupo_produto = 0 then cd_grupo_produto else @cd_grupo_produto end


