create  PROCEDURE sp_View_MenuFuncaoModulo
@cd_modulo int,
@cd_funcao int
AS

/*
SELECT M.cd_menu, M.nm_menu, MFM.cd_indice, I.nm_arquivo_imagem, I.nm_local_imagem
FROM Menu M, Modulo_Funcao_Menu MFM, Imagem I
WHERE M.cd_menu     = MFM.cd_menu
  AND MFM.cd_modulo = @cd_modulo
  AND MFM.cd_funcao = @cd_funcao
  AND M.cd_imagem   *= I.cd_imagem
ORDER BY cd_indice
*/

SELECT
  MFM.cd_modulo,
  MFM.cd_funcao,
  M.cd_menu,
  M.nm_menu,
  cast( M.ds_observacao as varchar(200)) as cl_descricao,
  I.nm_local_imagem,
  I.nm_arquivo_imagem,
  MFM.cd_indice,

  case when isnull(c.cd_classe,0)>0
       then cast(c.cd_classe as varchar(6) )
       else 
         case when isnull(p.cd_procedimento,0)>0
                then 'sp padrão: '+cast(p.cd_procedimento as varchar(6) )
                else 'nc'
         end
  end as cd_classe,

  case when isnull(c.nm_classe,'')<>'' 
       then c.nm_classe 
       else 
         case when isnull(p.nm_sql_procedimento,'')<>'' 
                then 'sp padrão: '+p.nm_sql_procedimento
                else 'não cadastrado no menu'
         end
  end as nm_classe,
  p.nm_procedimento,
  p.nm_sql_procedimento

--select * from procedimento

FROM
  Menu M INNER JOIN
  Modulo_Funcao_Menu MFM         ON (M.cd_menu = MFM.cd_menu) 
  LEFT OUTER JOIN Imagem I       ON (M.cd_imagem = I.cd_imagem)
  LEFT OUTER JOIN Classe C       ON (M.cd_classe = c.cd_classe)
  left outer join procedimento p ON (m.cd_procedimento = p.cd_procedimento)
WHERE 
  ((@cd_modulo = 0) or (MFM.cd_modulo = @cd_modulo))
  and 
  ((@cd_funcao = 0) or (MFM.cd_funcao = @cd_funcao))
  
ORDER BY cd_indice

