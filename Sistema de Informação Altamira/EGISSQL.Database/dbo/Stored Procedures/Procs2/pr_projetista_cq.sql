

/****** Object:  Stored Procedure dbo.pr_projetista_cq    Script Date: 13/12/2002 15:08:39 ******/
--pr_projetista_cq
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio
--Retorno do Cadastro de Projetistas 
--Data         : 22.05.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_projetista_cq
as
select cd_projetista,
       nm_projetista,
       nm_fantasia_projetista
from 
   Projetista
order by nm_projetista


