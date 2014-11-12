
-------------------------------------------------------------------------------
--sp_helptext pr_zerar_processo_modulo_viagem
-------------------------------------------------------------------------------
--pr_gera_contabilizacao_prestacao_conta
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007	
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Zerar todas as tabelas do processo do Módulo de viagens 
--                   Travel / Financeiro
--Data             : 06.06.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_zerar_processo_modulo_viagem
as

--delete from autorizacao_pagamento_contabil
--delete from autorizacao_pagto_composicao
--delete from autorizacao_pagamento

delete from prestacao_conta_contabil
delete from prestacao_conta_composicao
delete from prestacao_conta_aprovacao
delete from prestacao_conta_moeda
delete from prestacao_conta

delete from solicitacao_adiantamento_moeda
delete from solicitacao_adiantamento_contabil
delete from solicitacao_adiantamento_baixa
delete from solicitacao_adiantamento_aprovacao
delete from solicitacao_adiantamento

delete from requisicao_viagem_prestacao
delete from requisicao_viagem_composicao
delete from requisicao_viagem_aprovacao
delete from requisicao_viagem

--delete from projeto_viagem

