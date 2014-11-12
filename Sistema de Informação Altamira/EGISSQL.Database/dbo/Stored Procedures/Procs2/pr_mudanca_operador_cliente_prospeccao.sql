
-------------------------------------------------------------------------------
--pr_mudanca_operador_cliente_prospeccao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_mudanca_operador_cliente_prospeccao
@cd_operador_anterior int = 0,
@cd_operador_atual    int = 0

as

--Propseccao

update
  prospeccao
set
  cd_operador_telemarketing = @cd_operador_atual
where
  cd_operador_telemarketing = @cd_operador_anterior

--Historico

update
  prospeccao_historico
set
  cd_operador_telemarketing = @cd_operador_atual
where
  cd_operador_telemarketing = @cd_operador_anterior

--Cliente Prospecção

-- update
--   cliente_prospeccao
-- set
--   cd_operador_telemarketing = @cd_operador_atual
-- where
--   cd_operador_telemarketing = @cd_operador_anterior

--Cliente Prospecção Campanha

update
  cliente_prospeccao_campanha
set
  cd_operador_telemarketing = @cd_operador_atual
where
  cd_operador_telemarketing = @cd_operador_anterior

--Cliente Prospecção Campanha Histórico

-- update
--   cliente_prospeccao_historico
-- set
--   cd_operador_telemarketing = @cd_operador_atual
-- where
--   cd_operador_telemarketing = @cd_operador_anterior

--Meta Prospeccao Operador/Vendedor

update
  Meta_Prospeccao_Vendedor
set
  cd_operador_telemarketing = @cd_operador_atual
where
  cd_operador_telemarketing = @cd_operador_anterior


--deleta o operador telemarketing

--select * from operador_telemarketing

delete from operador_telemarketing 
where
  cd_operador_telemarketing = @cd_operador_anterior

