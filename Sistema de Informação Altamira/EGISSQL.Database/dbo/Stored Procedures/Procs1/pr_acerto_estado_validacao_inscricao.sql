
-------------------------------------------------------------------------------
--pr_acerto_estado_validacao_inscricao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2004
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 09/12/2004
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_acerto_estado_validacao_inscricao
as

--Estado

update
  estado
set
  ic_valida_ie_estado = 'S'
where
  ic_valida_ie_estado is null

--Fornecedor

update
  fornecedor
set
  ic_valida_ie_fornecedor = 'S'
where
  ic_valida_ie_fornecedor is null


--Cliente

update
  cliente
set
  ic_valida_ie_cliente = 'S'
where
  ic_valida_ie_cliente is null



