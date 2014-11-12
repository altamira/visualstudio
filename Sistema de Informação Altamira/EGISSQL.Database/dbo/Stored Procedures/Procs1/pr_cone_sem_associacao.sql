

/****** Object:  Stored Procedure dbo.pr_cone_sem_associacao    Script Date: 13/12/2002 15:08:15 ******/
--pr_cone_sem_associacao
-----------------------------------------------------------------------------------
--Polimold Industrial S/A                                                         2001                     
--Stored Procedure : SQL Server Microsoft 7.0  
--Cleiton Marques de Souza
--Cones que nao estao associados a uma ferramenta 
--Data         : 9.1.2001
--Atualizado   :
-----------------------------------------------------------------------------------
CREATE procedure pr_cone_sem_associacao
AS
select a.*,
       b.nm_tipo_cone,
       c.nm_fantasia_usuario
from   
  Cone a, Tipo_Cone b,SapAdmin.dbo.usuario c
where
   a.cd_tipo_cone=b.cd_tipo_cone                        and
   a.ic_cone_ativo = 'S'                                and
   cd_cone Not in (select cd_cone from ferramenta_cone) and
   a.cd_usuario = c.cd_usuario


