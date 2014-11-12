
--------------------------------------------------------------------------------  
--sp_View_TabSelecMenu  
--------------------------------------------------------------------------------  
--GBS - Global Business Solution  LTDA                                      2004  
--------------------------------------------------------------------------------  
--Stored Procedure      : Microsoft SQL Server  2000  
--Autor(es)             : Carlos Cardoso Fernandes  
--Banco de Dados        : SapSql  
--Objetivo              : Realizar uma consulta de Menu, trazendo dados de tabelas para o form padrão.  
--Data                  : 21/10/2004  
--Atualizado            : 10/12/2004 - Acerto do Cabeçalho - Sérgio Cardoso   
--                      : 13.08.2005 - Inclusão de um novo atributo, 
--                        para verificar se existe filtro na consulta - Carlos Fernandes  
--30.05.2008 - Novo Atributo para verificar se Mostra os registro automaticamente - Carlos Fernandes                                       
----------------------------------------------------------------------------------------------  
  
  
--exec sp_View_TabSelecMenu 1,1  
CREATE   PROCEDURE [sp_View_TabSelecMenu]  
@cd_menu    int = 0,  
@cd_usuario int = 0 
AS  
  
  
  
declare @ic_tipo_usuario char(1)  
  
select @ic_tipo_usuario = isnull(ic_tipo_usuario ,'P') 
from  
  Usuario with (nolock) 
Where   
  cd_usuario = @cd_usuario  
  
  SELECT   
         MT.*,   
         T.nm_tabela,   
         T.ic_sap_admin,  
         T.ic_supervisor_altera,  
         T.ic_fixa_tabela,  
         T.ds_obs_tabela,  
         T.ic_parametro_tabela,  
         @ic_tipo_usuario            as 'Tipo_Usuario',  
         T.ic_selecao_tabela,
         isnull(M.ic_registro_tabela_menu,'S') as ic_registro_tabela_menu
--select * from menu  
    FROM   
      Menu_Tabela MT   
   INNER JOIN TABELA T ON (MT.cd_tabela = T.cd_tabela)  
   INNER JOIN MENU   M ON (M.cd_menu    = MT.cd_menu )
   WHERE   
      MT.cd_menu = @cd_menu   

