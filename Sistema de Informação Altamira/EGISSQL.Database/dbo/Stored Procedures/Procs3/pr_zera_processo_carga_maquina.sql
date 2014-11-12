
--sp_helptext pr_zera_processo_carga_maquina

-------------------------------------------------------------------------------
--pr_zera_processo_carga_maquina
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : 
--Data             : 11.12.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_zera_processo_carga_maquina

as

--Carga Máquina

delete from carga_maquina_reserva
delete from carga_maquina_alteracao
delete from carga_maquina

--Programação de Produção

delete from reserva_programacao
delete from programacao_composicao
delete from programacao

--Simulação de Programação

delete from programacao_simulacao_item
delete from programacao_simulacao

