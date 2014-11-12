
CREATE  PROCEDURE sp_View_MnFncPorModUsu_temp
--sp_View_MnFncPorModUsu_temp
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                   2000                     
--Stored Procedure : SQL Servecr Microsoft 2000  
--Fabio Cesar Magalhães
--Stored procedure dos menus pertinentes ao usuário
--Data : 11.06.2002
--       26/01/2004 - Retornar os campos que identificam o procedimento - Eduardo
---------------------------------------------------------------------------------------

@Modulo Varchar(50),
@TipoModulo char(1),
@cd_usuario int,
@cd_idioma int = 1,
@cd_cliente_sistema int = -1
AS

	if ( @cd_idioma is null )
		set @cd_idioma = 1

  if ( @TipoModulo = 'I' ) --Realiza o Filtro pelo código do módulo
  begin
 
    SELECT distinct
      MFM.cd_indice,
			case @cd_idioma when 1
        then F.nm_funcao
        else IsNull(FI.nm_funcao_idioma, F.nm_funcao)
      end as nm_funcao,
      F.nm_funcao,
      M.cd_menu, 
      case @cd_idioma when 1
        then M.nm_menu
        else MI.nm_menu_idioma
      end as nm_menu ,
      case @cd_idioma when 1
        then M.nm_menu_titulo
        else MI.nm_titulo_menu_idioma
      end as nm_menu_titulo ,
      I.nm_local_imagem ,
      I.nm_arquivo_imagem,
      M.nm_form_menu,
      C.nm_classe,
      M.ic_mdi,
      M.nm_executavel,
      M.sg_tipo_opcao,
      M.cd_senha_acesso_menu,
      IsNull(M.ic_grafico_menu,'N') as ic_grafico_menu,
      IsNull(M.ic_expandido_menu,'N') as ic_expandido_menu,
      IsNull(M.ic_iso_menu,'N') as ic_iso_menu,
      P.cd_procedimento,
      P.nm_procedimento,
      P.nm_sql_procedimento
     
    FROM
      Modulo_Funcao_Menu MFM
      LEFT OUTER JOIN Funcao F               ON (F.cd_funcao = MFM.cd_funcao)
      LEFT OUTER JOIN Funcao_Idioma FI       ON (F.cd_funcao = FI.cd_funcao and FI.cd_idioma = @cd_idioma)       
      LEFT OUTER JOIN Menu M                 ON (
                                                  (MFM.cd_menu = M.cd_menu) 
                                                  and 
                                                  (
                                                    IsNull(M.ic_habilitado,'S') = 'S'
                                                  ) 
                                                  and  
                                                  ( 
                                                    (
                                                      IsNull(M.ic_nucleo_menu,'N') = 'S'
                                                    ) 
                                                    or
                                                    (@cd_cliente_sistema = -1)
                                                    or 
                                                    ( 
                                                      (
                                                        IsNull(M.ic_nucleo_menu,'N') = 'N'
                                                      ) 
                                                      and 
                                                      exists(
                                                        Select 'x' from Menu_Cliente MC 
                                                        where MC.cd_cliente_sistema = @cd_cliente_sistema 
                                                        --and MC.ic_habilitado_menu  = 'S' 
                                                        and MC.cd_menu = MFM.cd_menu
                                                      ) 
                                                    ) 
                                                  )
                                                )
      LEFT OUTER JOIN Procedimento P         ON (P.cd_procedimento = M.cd_procedimento)
      LEFT OUTER JOIN Menu_Idioma MI         ON (MFM.cd_menu = MI.cd_menu and MI.cd_idioma = @cd_idioma) 
      LEFT OUTER JOIN Imagem I               ON (M.cd_imagem = I.cd_imagem)
      LEFT OUTER JOIN Classe C               ON (M.cd_classe = C.cd_classe )
      INNER JOIN Menu_Usuario MU             ON (MU.cd_menu  = M.cd_menu)

    WHERE
      MFM.cd_modulo = @Modulo AND
      MU.cd_usuario = @cd_usuario

    ORDER BY cd_indice 

  end 
  else
  begin
 
    SELECT distinct
      MFM.cd_indice,           
      case @cd_idioma when 1
        then F.nm_funcao
        else IsNull(FI.nm_funcao_idioma, F.nm_funcao)
      end as nm_funcao,
      M.cd_menu, 
      case @cd_idioma when 1
        then M.nm_menu
        else MI.nm_menu_idioma
      end as nm_menu ,
      case @cd_idioma when 1
        then M.nm_menu_titulo
        else MI.nm_titulo_menu_idioma
      end as nm_menu_titulo ,
      I.nm_local_imagem ,
      I.nm_arquivo_imagem,
      M.nm_form_menu,
      C.nm_classe,
      M.ic_mdi,
      M.nm_executavel,
      M.sg_tipo_opcao,
      F.cd_funcao,
      M.cd_senha_acesso_menu,
      IsNull(M.ic_grafico_menu,'N') as ic_grafico_menu,
      IsNull(M.ic_expandido_menu,'N') as ic_expandido_menu,
      IsNull(M.ic_iso_menu,'N') as ic_iso_menu,
      P.cd_procedimento,
      P.nm_procedimento,
      P.nm_sql_procedimento

    FROM
      Modulo_Funcao_Menu MFM
      LEFT OUTER JOIN Funcao F               ON (F.cd_funcao = MFM.cd_funcao)
      LEFT OUTER JOIN Funcao_Idioma FI       ON (F.cd_funcao = FI.cd_funcao and FI.cd_idioma = @cd_idioma)       
      LEFT OUTER JOIN Menu M                 ON (
                                                  (MFM.cd_menu = M.cd_menu) 
                                                  and 
                                                  (
                                                    IsNull(M.ic_habilitado,'S') = 'S'
                                                  ) 
                                                  and  
                                                  ( 
                                                    (
                                                      IsNull(M.ic_nucleo_menu,'N') = 'S'
                                                    ) 
                                                    or
                                                    (@cd_cliente_sistema = -1)
                                                    or 
                                                    ( 
                                                      (
                                                        IsNull(M.ic_nucleo_menu,'N') = 'N'
                                                      ) 
                                                      and 
                                                      exists(
                                                        Select 'x' from Menu_Cliente MC 
                                                        where MC.cd_cliente_sistema = @cd_cliente_sistema 
                                                        --and MC.ic_habilitado_menu  = 'S' 
                                                        and MC.cd_menu = MFM.cd_menu
                                                      ) 
                                                    ) 
                                                  )
                                                )
      LEFT OUTER JOIN Procedimento P         ON (P.cd_procedimento = M.cd_procedimento)
      LEFT OUTER JOIN Menu_Idioma MI         ON (MFM.cd_menu = MI.cd_menu and MI.cd_idioma = @cd_idioma) 
      LEFT OUTER JOIN Imagem I               ON (M.cd_imagem = I.cd_imagem)
      LEFT OUTER JOIN Classe C               ON (M.cd_classe = C.cd_classe )
      LEFT OUTER JOIN Menu_Usuario MU        ON (MU.cd_menu  = M.cd_menu)
      INNER JOIN Modulo MD                   ON (MFM.cd_modulo = MD.cd_modulo)
    WHERE
      MD.nm_modulo  = @Modulo AND
      MU.cd_usuario = @cd_usuario

    ORDER BY cd_indice

  end

-- =============================================
-- Testando a procedure
-- =============================================
