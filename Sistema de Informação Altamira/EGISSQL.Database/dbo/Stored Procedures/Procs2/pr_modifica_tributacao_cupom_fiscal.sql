
-------------------------------------------------------------------------------
--pr_modifica_tributacao_cupom_fiscal
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Anderson Messias da Silva
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 29/12/2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_modifica_tributacao_cupom_fiscal
  @cd_grupo_produto    int = 0,
  @cd_tributacao_atual int = 0,
  @cd_tributacao_nova  int = 0,
  @pc_icms             float = 0
as

Select
  cd_grupo_produto,
  cd_tributacao,
  pc_icms_produto
From
  Produto
Where
  cd_grupo_produto = case when isnull(@cd_grupo_produto,0)=0    then cd_grupo_produto else @cd_grupo_produto    end and
  cd_tributacao    = @cd_tributacao_atual

-- Update
--   Produto
-- Set
--   cd_tributacao   = @cd_tributacao_nova,
--   pc_icms_produto = @pc_icms
-- Where
--   cd_grupo_produto = case when isnull(@cd_grupo_produto,0)=0 then cd_grupo_produto else @cd_grupo_produto end and
--   cd_tributacao    = @cd_tributacao_atual
