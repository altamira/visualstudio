
CREATE VIEW vw_faturamento_devolucao_mes
--------------------------------------------------------------------------------------
--GBS Global Business Solution Ltda                                               2004
--Stored Procedure : SQL Server 2000
--Autor		   : Fabio Cesar Magalhães
--Objetivo	   : Notas Fiscais Devolvidas para consultas do BI,
--		    Considerando apenas as devolvidas no mesmo mês
--Data             : 22.01.2004
--Atualizado       : 
-- - Não utilizar. Utilizar a vw_faturamento_devolucao.
-- - 20/04/2004 - Daniel C. Neto.
-------------------------------------------------------------------------------------------

as 

  select
   * 
  from
   vw_faturamento_devolucao

