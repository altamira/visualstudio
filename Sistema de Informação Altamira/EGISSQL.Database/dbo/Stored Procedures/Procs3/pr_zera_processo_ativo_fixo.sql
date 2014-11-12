
-------------------------------------------------------------------------------
--pr_zera_processo_ativo_fixo
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2007
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : Egissql
--Objetivo         : Zera todas as tabelas do sistema referente ao Cálculo do 
--                   Ativo Fixo
--Data             : 26.02.2007
--Alteração        : 
------------------------------------------------------------------------------
create procedure pr_zera_processo_ativo_fixo
as

--ciap

delete from ciap_saida
delete from ciap_composicao
delete from ciap_demonstrativo
delete from ciap

--Inventário do bem

delete from inventario_bem_composicao
delete from inventario_bem

--ativo fixo

delete from registro_movimento_bem_item
delete from registro_movimento_bem
delete from calculo_ativo
delete from calculo_bem
delete from valor_bem_fechamento
delete from valor_bem_implantacao
delete from valor_bem
delete from bem

