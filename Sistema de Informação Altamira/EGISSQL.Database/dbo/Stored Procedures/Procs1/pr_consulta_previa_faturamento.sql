

/****** Object:  Stored Procedure dbo.pr_consulta_previa_faturamento    Script Date: 13/12/2002 15:08:23 ******/


--pr_consulta_previa_faturamento
--------------------------------------------------------------------------------------
--Global Business Solution Ltda
--Stored Procedure : SQL Server Microsoft 2002  
--Adriano Levy        
--Consulta Prévia de Faturamento
--Data          : 05.06.2002
--Atualizado    : 
--------------------------------------------------------------------------------------

CREATE PROCEDURE pr_consulta_previa_faturamento
@cd_parametro int,
@dt_inicial datetime,
@dt_final   datetime

AS
    Select
      pf.cd_previa_faturamento,
      pf.dt_previa_faturamento,
      pf.qt_pedido_previa_faturame, 
      pf.vl_pedido_previa_faturame
    from
      Previa_Faturamento pf
    order by pf.dt_previa_faturamento,
             pf.cd_previa_faturamento



