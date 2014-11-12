
CREATE  PROCEDURE sp_View_MnFncPorModUsu

--------------------------------------------------------------------------------------
--sp_View_MnFncPorModUsu
--------------------------------------------------------------------------------------
--Global Business Solution Ltda                                                   2000                     
--Stored Procedure : SQL Servecr Microsoft 2000  
--Fabio Cesar Magalhães
--Stored procedure dos menus pertinentes ao usuário
--Data : 11.06.2002
--       26/01/2004 - Retornar os campos que identificam o procedimento - Eduardo
--       05.10.2006 - Checar a Versão da Empresa - Carlos Fernandes
--       25.01.2007 - Verificação - Carlos Fernandes
---------------------------------------------------------------------------------------

@Modulo             Varchar(50) = '',
@TipoModulo         char(1)     = '' ,
@cd_usuario         int         = 0,
@cd_idioma          int         = 1,
@cd_cliente_sistema int         = -1,
@cd_tipo_versao     int         = 0,
@ic_senha           char(1)     = 'N'
as

--Tipo de Versão
--select * from tipo_versao

--Tratamento do Código da Versão

declare @cd_tipo_versao_aux int
set @cd_tipo_versao_aux = 1

--Se não for passado valor, Todas as Versões

if @cd_tipo_versao = 0 or @cd_tipo_versao is null or @cd_tipo_versao = 1 or @cd_tipo_versao = 3
begin
  set @cd_tipo_versao     = 1
  set @cd_tipo_versao_aux = 3
end

if @cd_cliente_sistema = -1 
begin
  set @cd_tipo_versao     = 1
end

--Idioma

if ( @cd_idioma is null )
   set @cd_idioma = 1

--print @TipoModulo

if ( @TipoModulo = 'I' ) --Realiza o Filtro pelo código do módulo
  begin

    --print '1'
 
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
      IsNull(M.ic_grafico_menu,'N')   as ic_grafico_menu,
      IsNull(M.ic_expandido_menu,'N') as ic_expandido_menu,
      IsNull(M.ic_iso_menu,'N')       as ic_iso_menu,
      P.cd_procedimento,
      P.nm_procedimento,
      P.nm_sql_procedimento,
      Isnull(M.ic_grava_posicao_grid,'N') as ic_grava_posicao_grid,
      Isnull(M.ic_panel_help,'N') as ic_panel_help,
      M.cd_tipo_versao,
 		case 	isnull(pai.nm_endereco_pagina, '') 
				  	when '' then
						isnull(pai.nm_caminho_pagina, '') 
              	else
						isnull(pai.nm_endereco_pagina, '') 
					end
     as Pagina,
     isnull(m.ic_centralizado_menu,'N') as ic_centralizado_menu
    FROM
      Modulo_Funcao_Menu MFM
      INNER JOIN Funcao F               ON (F.cd_funcao = MFM.cd_funcao)
      LEFT OUTER JOIN Funcao_Idioma FI  ON (F.cd_funcao = FI.cd_funcao and FI.cd_idioma = @cd_idioma)       
      INNER JOIN Menu M                 ON ( (MFM.cd_menu = M.cd_menu)            and 
                                             (IsNull(M.ic_habilitado,'S') = 'S')  and  
                                             ((IsNull(M.ic_nucleo_menu,'N') = 'S' ) 
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
		LEFT OUTER JOIN Pagina_Internet  pai   ON (M.cd_pagina = pai.cd_pagina)
      INNER JOIN 
      (Select 
         cd_menu 
       from 
         Menu_Usuario 
       where cd_usuario  = @cd_usuario
       UNION
       Select 
         cd_menu 
       from 
         Grupo_Usuario_Menu GUM
         inner join Usuario_GrupoUsuario UGU
         on GUM.cd_grupo_usuario = UGU.cd_grupo_usuario
       where 
         UGU.cd_usuario = @cd_usuario) MU             ON (MU.cd_menu  = M.cd_menu)

    WHERE
      MFM.cd_modulo = @Modulo 
      and
      --Tipo da Versão
      ( isnull(m.cd_tipo_versao,1) = @cd_tipo_versao or isnull(m.cd_tipo_versao,1) = @cd_tipo_versao_aux )

    ORDER BY cd_indice 

    --Busca os Menus específicos do Cliente Independente da Versão


  end 
else
  begin

    --print '2'

    --Menus Habilitados
 
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
      IsNull(M.ic_grafico_menu,'N')   as ic_grafico_menu,
      IsNull(M.ic_expandido_menu,'N') as ic_expandido_menu,
      IsNull(M.ic_iso_menu,'N')       as ic_iso_menu,
      P.cd_procedimento,
      P.nm_procedimento,
      P.nm_sql_procedimento,
      Isnull(M.ic_grava_posicao_grid,'N') as ic_grava_posicao_grid,
      Isnull(M.ic_panel_help,'N')         as ic_panel_help,
      m.cd_tipo_versao,
   	case 	isnull(pai.nm_endereco_pagina, '') 
				  	when '' then
						isnull(pai.nm_caminho_pagina, '') 
              	else
						isnull(pai.nm_endereco_pagina, '') 
					end
	   as Pagina,
      isnull(m.ic_centralizado_menu,'N') as ic_centralizado_menu
    into #MenuModulo
    FROM
      Modulo_Funcao_Menu MFM
      INNER JOIN Funcao F               ON (F.cd_funcao = MFM.cd_funcao)
      LEFT OUTER JOIN Funcao_Idioma FI  ON (F.cd_funcao = FI.cd_funcao and FI.cd_idioma = @cd_idioma)       
      INNER JOIN Menu M                 ON ( (MFM.cd_menu = M.cd_menu)             and 
                                             (IsNull(M.ic_habilitado,'S')   = 'S') and  --Habilitado 
                                             ((IsNull(M.ic_nucleo_menu,'N') = 'S')      --Núcleo
                                               or
                                               (@cd_cliente_sistema = -1)
                                                or 
                                                ((IsNull(M.ic_nucleo_menu,'N') = 'N') 
                                            and 
                                             exists(
                                                    Select 'x' from Menu_Cliente MC 
                                                      where MC.cd_cliente_sistema = @cd_cliente_sistema 
                                                     and MC.cd_menu = MFM.cd_menu
                                                      ) 
                                                    ) 
                                                  )
                                                )
      LEFT OUTER JOIN Procedimento P         ON (P.cd_procedimento = M.cd_procedimento)
      LEFT OUTER JOIN Menu_Idioma MI         ON (MFM.cd_menu = MI.cd_menu and MI.cd_idioma = @cd_idioma) 
      LEFT OUTER JOIN Imagem I               ON (M.cd_imagem = I.cd_imagem)
      LEFT OUTER JOIN Classe C               ON (M.cd_classe = C.cd_classe )
		LEFT OUTER JOIN Pagina_Internet  pai   ON (M.cd_pagina = pai.cd_pagina)
      INNER JOIN 
      (Select 
         cd_menu 
       from 
         Menu_Usuario 
       where 
         cd_usuario  = @cd_usuario
       UNION
       Select 
         cd_menu 
       from 
         Grupo_Usuario_Menu GUM
         inner join Usuario_GrupoUsuario UGU
         on GUM.cd_grupo_usuario = UGU.cd_grupo_usuario
       where 
         UGU.cd_usuario = @cd_usuario) MU    ON (MU.cd_menu  = M.cd_menu)
      INNER JOIN Modulo MD                   ON (MFM.cd_modulo = MD.cd_modulo)
    WHERE
      MD.nm_modulo  = @Modulo
      and
      --Tipo de Versão
      ( isnull(m.cd_tipo_versao,1) = @cd_tipo_versao or isnull(m.cd_tipo_versao,1) = @cd_tipo_versao_aux )

    ORDER BY cd_indice

    --Menus Não Habilitados

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
      IsNull(M.ic_grafico_menu,'N')   as ic_grafico_menu,
      IsNull(M.ic_expandido_menu,'N') as ic_expandido_menu,
      IsNull(M.ic_iso_menu,'N')       as ic_iso_menu,
      P.cd_procedimento,
      P.nm_procedimento,
      P.nm_sql_procedimento,
      Isnull(M.ic_grava_posicao_grid,'N') as ic_grava_posicao_grid,
      Isnull(M.ic_panel_help,'N')         as ic_panel_help,
      m.cd_tipo_versao,
   	case 	isnull(pai.nm_endereco_pagina, '') 
				  	when '' then
						isnull(pai.nm_caminho_pagina, '') 
              	else
						isnull(pai.nm_endereco_pagina, '') 
					end
	   as Pagina,
      isnull(m.ic_centralizado_menu,'N') as ic_centralizado_menu
    into
      #MenuModuloNaoHabilitado
    FROM
      Modulo_Funcao_Menu MFM
      INNER JOIN Funcao F               ON (F.cd_funcao = MFM.cd_funcao)
      LEFT OUTER JOIN Funcao_Idioma FI  ON (F.cd_funcao = FI.cd_funcao and FI.cd_idioma = @cd_idioma)       
      INNER JOIN Menu M                 ON ( MFM.cd_menu = M.cd_menu            and 
                                             IsNull(M.ic_habilitado,'S')  = 'N' and  --Habilitado 
                                             IsNull(M.ic_nucleo_menu,'N') = 'N' and     --Núcleo
                                             @ic_senha = 'S' )
      LEFT OUTER JOIN Procedimento P         ON (P.cd_procedimento = M.cd_procedimento)
      LEFT OUTER JOIN Menu_Idioma MI         ON (MFM.cd_menu = MI.cd_menu and MI.cd_idioma = @cd_idioma) 
      LEFT OUTER JOIN Imagem I               ON (M.cd_imagem = I.cd_imagem)
      LEFT OUTER JOIN Classe C               ON (M.cd_classe = C.cd_classe )
		LEFT OUTER JOIN Pagina_Internet  pai   ON (M.cd_pagina = pai.cd_pagina)
      INNER JOIN 
      (Select 
         cd_menu 
       from 
         Menu_Usuario 
       where 
         cd_usuario  = @cd_usuario
       UNION
       Select 
         cd_menu 
       from 
         Grupo_Usuario_Menu GUM
         inner join Usuario_GrupoUsuario UGU
         on GUM.cd_grupo_usuario = UGU.cd_grupo_usuario
       where 
         UGU.cd_usuario = @cd_usuario) MU    ON (MU.cd_menu  = M.cd_menu)
      INNER JOIN Modulo MD                   ON (MFM.cd_modulo = MD.cd_modulo)
    WHERE
      MD.nm_modulo  = @Modulo
      and
      --Tipo de Versão
      ( isnull(m.cd_tipo_versao,1) = @cd_tipo_versao or isnull(m.cd_tipo_versao,1) = @cd_tipo_versao_aux )

    ORDER BY cd_indice 

    --Busca os Menus específicos do Cliente Independente da Versão

    select * from  #MenuModulo
    union all
      select * from #MenuModuloNaoHabilitado
    union all
      (SELECT distinct
         MFM.cd_indice,           
         case @cd_idioma when 1  then F.nm_funcao
                                 else IsNull(FI.nm_funcao_idioma, F.nm_funcao)
         end as nm_funcao,
         M.cd_menu, 
         case @cd_idioma when 1  then M.nm_menu
                                 else MI.nm_menu_idioma
         end as nm_menu ,
         case @cd_idioma when 1  then M.nm_menu_titulo
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
         P.nm_sql_procedimento,
         Isnull(M.ic_grava_posicao_grid,'N') as ic_grava_posicao_grid,
      	 Isnull(M.ic_panel_help,'N') as ic_panel_help,
         m.cd_tipo_versao,
   		case 	isnull(pai.nm_endereco_pagina, '') 
				  	when '' then
						isnull(pai.nm_caminho_pagina, '') 
              	else
						isnull(pai.nm_endereco_pagina, '') 
					end
	     as Pagina,
         isnull(m.ic_centralizado_menu,'N') as ic_centralizado_menu
      FROM
        Menu_Empresa ME 
        inner join Modulo_Funcao_Menu MFM   on MFM.cd_menu   = ME.cd_menu 
        INNER JOIN Funcao F                 ON (F.cd_funcao = MFM.cd_funcao)
        LEFT OUTER JOIN Funcao_Idioma FI    ON (F.cd_funcao = FI.cd_funcao and FI.cd_idioma = @cd_idioma)       
        INNER JOIN Menu M                   ON (ME.cd_menu = M.cd_menu) 
        LEFT OUTER JOIN Procedimento P      ON (P.cd_procedimento = M.cd_procedimento)
        LEFT OUTER JOIN Menu_Idioma MI      ON (MFM.cd_menu = MI.cd_menu and MI.cd_idioma = @cd_idioma) 
        LEFT OUTER JOIN Imagem I            ON (M.cd_imagem = I.cd_imagem)
        LEFT OUTER JOIN Classe C            ON (M.cd_classe = C.cd_classe )
        INNER JOIN Modulo MD                   ON (MFM.cd_modulo = MD.cd_modulo)
 		  LEFT OUTER JOIN Pagina_Internet  pai   ON (M.cd_pagina = pai.cd_pagina)
     WHERE
      MD.nm_modulo  = @Modulo )
    order by cd_indice 



  end

--select * from modulo_funcao_menu

-- =============================================
-- Testando a procedure
-- =============================================

