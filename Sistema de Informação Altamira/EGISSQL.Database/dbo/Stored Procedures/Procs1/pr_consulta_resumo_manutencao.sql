
CREATE PROCEDURE pr_consulta_resumo_manutencao
@Ano Int
AS

select 
  Sum(qt_manut_cem_hist) as qt_manut_cem_hist ,
  Sum(qt_manut_gerada_cem_hist) as qt_manut_gerada_cem_hist,
  Sum(vl_total_manut_cem_hist) as vl_total_manut_cem_hist,
  Sum(qt_isent_manut_cem_hist)as qt_isent_manut_cem_hist,
  case
   when month(dt_venc_manut_cem_hist) = 1  then 'Janeiro' 
   when month(dt_venc_manut_cem_hist) = 2  then 'Fevereiro' 
   when month(dt_venc_manut_cem_hist) = 3  then 'Março' 
   when month(dt_venc_manut_cem_hist) = 4  then 'Abril' 
   when month(dt_venc_manut_cem_hist) = 5  then 'Maio' 
   when month(dt_venc_manut_cem_hist) = 6  then 'Junho'   
   when month(dt_venc_manut_cem_hist) = 7  then 'Julho' 
   when month(dt_venc_manut_cem_hist) = 8  then 'Agosto'    
   when month(dt_venc_manut_cem_hist) = 9  then 'Setembro' 
   when month(dt_venc_manut_cem_hist) = 10 then 'Outubro' 
   when month(dt_venc_manut_cem_hist) = 11 then 'Novembro' 
   when month(dt_venc_manut_cem_hist) = 12 then 'Dezembro' 
end
as MES
from 
  Manut_Cem_Hist
where 
  year(dt_venc_manut_cem_hist) = @Ano 
  Group by month(dt_venc_manut_cem_hist)

