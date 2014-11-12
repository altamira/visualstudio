
create PROCEDURE [sp_View_FuncaoModulo2]
@Modulo varchar(50),
-- o parâmetro abaixo indica se @Modulo tem o codigo ou o nome do módulo
@TipoModulo char(1)
AS

  CREATE TABLE #FuncaoModulo (cd_modulo int NULL,
                              cd_funcao int NULL,
                              cd_indice int NULL,
                              nm_funcao varchar(20) NULL,
                              cl_descricao varchar(200) NULL)
                                    
  IF @TipoModulo = 'I'
  begin
    declare @cd_modulo int
    set @cd_modulo = cast(@Modulo as int)

    INSERT INTO #FuncaoModulo (cd_modulo, cd_funcao, nm_funcao, cl_descricao)
             (SELECT DISTINCT MFM.cd_modulo,
                              MFM.cd_funcao, 
                              F.nm_funcao,
                              cast( F.ds_funcao as varchar(200))
                FROM Modulo_Funcao_Menu MFM, Funcao F
               WHERE 
                 ((@cd_modulo = 0) or (MFM.cd_modulo = @cd_modulo)) and
                 F.cd_funcao = MFM.cd_funcao)
  end 
  ELSE
  begin
    INSERT INTO #FuncaoModulo (cd_modulo, cd_funcao, nm_funcao, cl_descricao)
             (SELECT DISTINCT MFM.cd_modulo,
                              MFM.cd_funcao,
                              F.nm_funcao,
                              cast( F.ds_funcao as varchar(200))
                FROM Modulo_Funcao_Menu MFM, Modulo M, Funcao F
               WHERE 
                 M.nm_modulo   = @Modulo and
                 MFM.cd_modulo = M.cd_modulo and
                 MFM.cd_funcao = F.cd_funcao)
  end

  UPDATE #FuncaoModulo
     SET #FuncaoModulo.cd_indice = 
          (Select Min(MFM.cd_indice) 
             from Modulo_Funcao_Menu MFM 
            where (MFM.cd_funcao = #FuncaoModulo.cd_funcao) and
                  (MFM.cd_modulo = #FuncaoModulo.cd_modulo) and
                  (MFM.cd_indice is not null))
                                          
    FROM Modulo_Funcao_Menu MFM
   WHERE
      #FuncaoModulo.cd_funcao = MFM.cd_funcao

  IF (@TipoModulo = 'I') and (@cd_modulo = 0)
    SELECT * FROM #FuncaoModulo ORDER BY cd_modulo, cd_indice
  Else
    SELECT * FROM #FuncaoModulo ORDER BY cd_indice

--exec sp_View_FuncaoModulo2 74, 'I'
--exec sp_View_FuncaoModulo2 0, 'I'

--select * from modulo where sg_modulo like 'GBSA%'
