
-------------------------------------------------------------------------------
--sp_helptext pr_geracao_lancamento_movimento_folha
-------------------------------------------------------------------------------
--pr_geracao_lancamento_movimento_folha
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Geração dos Lançamentos do Movimento da Folha
--
--Data             : 16.06.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_geracao_lancamento_movimento_folha
@cd_funcionario int = 0

as

------------------------------------------------------------------------------
--Cálculos
------------------------------------------------------------------------------
--1. Contribuição Sindical
--2. Vale Transporte
--3. Adicional Noturno
--4. Hora Extra
--5. Insalubridade
--6. Periculosidade.
--7. Pensão alimentícia
--8. FGTS
--9. IR
--10.INSS
--11.Incidências
------------------------------------------------------------------------------
--Bases
------------------------------------------------------------------------------




