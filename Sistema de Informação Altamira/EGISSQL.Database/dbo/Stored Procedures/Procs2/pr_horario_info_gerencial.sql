

/****** Object:  Stored Procedure dbo.pr_horario_info_gerencial    Script Date: 13/12/2002 15:08:33 ******/
--pr_horario_info_gerencial
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio
--Horários de envios de documentos por e-mail
--Data         : 06.07.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_horario_info_gerencial
as
select cd_info_gerencial,
       hr_info_gerencial
from 
   Horario_Info_Gerencial
order by hr_info_gerencial


