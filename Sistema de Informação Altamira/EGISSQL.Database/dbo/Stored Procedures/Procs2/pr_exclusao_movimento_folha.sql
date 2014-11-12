
-------------------------------------------------------------------------------
--sp_helptext pr_exclusao_movimento_folha
-------------------------------------------------------------------------------
--pr_documentacao_padrao
-------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                        2008
-------------------------------------------------------------------------------
--Stored Procedure : Microsoft SQL Server 2000
--Autor(es)        : Carlos Cardoso Fernandes
--Banco de Dados   : EgisAdmin ou Egissql
--Objetivo         : 
--Data             : 01.01.2008
--Alteração        : 
--
--
------------------------------------------------------------------------------
create procedure pr_exclusao_movimento_folha
@ic_parametro           int      = 0,
@cd_tipo_calculo_folha  int      = 0,
@dt_inicial             datetime = '',
@dt_final               datetime = ''

as


--Movimento Completo

if @ic_parametro = 9
begin
  delete from controle_folha
  delete from calculo_folha
  delete from movimento_folha
end
  


