
CREATE PROCEDURE pr_consulta_res_manut
@Ano DateTime
AS

select 
  Sum(qt_manut_cem_hist) as qt_manut_cem_hist ,
  Sum(qt_manut_gerada_cem_hist) as qt_manut_gerada_cem_hist,
  Sum(vl_total_manut_cem_hist) as vl_total_manut_cem_hist,
  Sum(qt_isent_manut_cem_hist)as qt_isent_manut_cem_hist,
  month(dt_venc_manut_cem_hist) as MES
from 
  Manut_Cem_Hist
where 
  year(dt_venc_manut_cem_hist) = @Ano 
  Group by month(dt_venc_manut_cem_hist)


EXECUTE pr_consulta_res_manut


 

