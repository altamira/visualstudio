
CREATE PROCEDURE [sp_View_MenuFuncaoPorModulo]
@Modulo Varchar(50),
@TipoModulo char(1)
AS
  IF @TipoModulo = 'I'
    SELECT MFM.cd_indice,
           F.cd_funcao, 
           F.nm_funcao,
           M.cd_menu, 
           M.nm_menu ,
           M.nm_menu_titulo,
           I.nm_local_imagem ,
           I.nm_arquivo_imagem,
           C.nm_classe
      FROM Funcao F LEFT OUTER JOIN Modulo_Funcao_Menu MFM ON (F.cd_funcao = MFM.cd_funcao)
                    LEFT OUTER JOIN Menu M  ON (MFM.cd_menu = M.cd_menu) 
                    LEFT OUTER JOIN Imagem I ON (M.cd_imagem = I.cd_imagem)
                    LEFT OUTER JOIN Classe C ON (M.cd_classe = C.cd_classe )
      WHERE MFM.cd_modulo = @Modulo
      ORDER BY cd_indice 
  ELSE 
    SELECT MFM.cd_indice,
           F.cd_funcao, 
           F.nm_funcao,
           M.cd_menu, 
           M.nm_menu ,
           M.nm_menu_titulo,
           I.nm_local_imagem ,
           I.nm_arquivo_imagem,
           C.nm_classe
      FROM Funcao F LEFT OUTER JOIN Modulo_Funcao_Menu MFM ON (F.cd_funcao = MFM.cd_funcao)
                LEFT OUTER JOIN Modulo MD ON (MFM.cd_modulo = MD.cd_modulo)         
                LEFT OUTER JOIN Menu M  ON (MFM.cd_menu = M.cd_menu) 
                LEFT OUTER JOIN Imagem I ON (M.cd_imagem = I.cd_imagem)
                LEFT OUTER JOIN Classe C ON (M.cd_classe = C.cd_classe )
      WHERE MD.nm_modulo = @Modulo
      ORDER BY cd_indice

