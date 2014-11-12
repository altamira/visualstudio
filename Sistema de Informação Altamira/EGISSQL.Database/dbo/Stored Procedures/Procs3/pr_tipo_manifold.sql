

/****** Object:  Stored Procedure dbo.pr_tipo_manifold    Script Date: 13/12/2002 15:08:43 ******/
--pr_tipo_projeto
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2000                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Lucio
--Retorno do Cadastro de Tipos de Manifold
--Data         : 24.05.2001
--Atualizado   : 
-----------------------------------------------------------------------------------
CREATE procedure pr_tipo_manifold
as
select cd_tipo_manifold,
       nm_tipo_manifold,
       sg_tipo_manifold,
       qt_via_tipo_manifold
from 
   Tipo_Manifold
order by nm_tipo_manifold


