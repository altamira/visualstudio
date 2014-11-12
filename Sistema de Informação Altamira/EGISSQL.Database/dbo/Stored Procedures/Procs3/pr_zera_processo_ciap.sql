
-------------------------------------------------------------------------------
--pr_zera_processo_ciap
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2006
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Zera as Tabelas do Cálculo do CIAP
--Data             : 10.12.2006
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_zera_processo_ciap
--@dt_inicial datetime = '',
--@dt_final   datetime = ''

as

--Zera as Tabelas do Cálculo do CIAP
delete from CIAP_Composicao
delete from CIAP_Demonstrativo
delete from CIAP
delete from Livro_CIAP
delete from Tipo_CIAP
delete from Coeficiente_CIAP


