

/****** Object:  Stored Procedure dbo.pr_total_faturamento    Script Date: 13/12/2002 15:08:43 ******/

--pr_total_faturamento
--------------------------------------------------------------------------------------
--Global Business Solution                                                       2002                     
--Stored Procedure : SQL Server Microsoft 2000 
--Carlos Cardoso Fernandes
--Total de Faturamento e Faturamento Diário 
--Data         : 06.04.2002
--
--------------------------------------------------------------------------------------

create  procedure pr_total_faturamento
@dt_inicial datetime,
@dt_final   datetime
as

-- Linha abaixo incluída para rodar no ASP
set nocount on

select
   sum(b.qt_item_nota_saida*b.vl_unitario_item_nota) as 'TotalFaturamento'
from
  Nota_Saida a, Nota_Saida_Item b
Where
  (a.dt_nota_saida between @dt_inicial and @dt_final) and
   a.cd_nota_saida = b.cd_nota_saida                           



