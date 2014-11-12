CREATE   PROCEDURE [sp_View_ModuloUsuario]
@cd_usuario             int = 0,
@ic_alfa_modulo_empresa char(1) = 'N'
AS
set nocount on
/*
  Select M.*,
         I.nm_local_imagem, 
         I.nm_arquivo_imagem,
         UC.nm_destino 
    from Usuario_GrupoUsuario UGU 
           INNER JOIN Modulo_GrupoUsuario MGU
                               ON (UGU.cd_grupo_usuario = MGU.cd_grupo_usuario)
           INNER JOIN Modulo M 
                               ON (M.cd_modulo = MGU.cd_modulo)
           LEFT OUTER JOIN Usuario_Config UC 
                               ON (MGU.cd_modulo = UC.cd_modulo AND
                                   UC.cd_usuario = @cd_usuario)  
           LEFT OUTER JOIN Imagem I 
                               ON (M.cd_imagem = I.cd_imagem)
   WHERE UGU.cd_usuario = @cd_usuario
     AND M.ic_liberado = 'S'
   ORDER BY cd_ordem_modulo
*/

 Select Distinct M.cd_modulo,
         I.nm_local_imagem, 
         I.nm_arquivo_imagem,
         UC.nm_destino 
   INTO #MUTemp
    from Usuario_GrupoUsuario UGU 
           INNER JOIN Modulo_GrupoUsuario MGU
                               ON (UGU.cd_grupo_usuario = MGU.cd_grupo_usuario)
           INNER JOIN Modulo M 
                               ON (M.cd_modulo = MGU.cd_modulo)
           LEFT OUTER JOIN Usuario_Config UC 
                               ON (MGU.cd_modulo = UC.cd_modulo AND
                                   UC.cd_usuario = @cd_usuario)  
           LEFT OUTER JOIN Imagem I 
                               ON (M.cd_imagem = I.cd_imagem)
   WHERE UGU.cd_usuario = @cd_usuario
     AND isnull(M.ic_liberado,'N') = 'S'

--Mostra a Tabela Final  

select
  @ic_alfa_modulo_empresa = isnull(ic_alfa_modulo_empresa,'N')
from
  empresa
where
  cd_empresa = egissql.dbo.fn_empresa()


if @ic_alfa_modulo_empresa='N'
begin
 Select 
   M.*, 
   #MUTemp.*
 FROM Modulo M, #MUTemp,Cadeia_Valor C
   where m.cd_modulo = #MUTemp.cd_modulo and
         c.cd_cadeia_valor=m.cd_cadeia_valor
   order by 
     c.cd_ordem_cadeia_valor,
     m.cd_ordem_modulo
end
else
begin
 Select 
   M.*, 
   #MUTemp.*
 FROM Modulo M, #MUTemp,Cadeia_Valor C
   where m.cd_modulo = #MUTemp.cd_modulo and
         c.cd_cadeia_valor=m.cd_cadeia_valor
   order by 
     m.nm_modulo
end

--Verificar se a Empresa quer os Módulos em Ordem Alfabética
--carlos

 
 


