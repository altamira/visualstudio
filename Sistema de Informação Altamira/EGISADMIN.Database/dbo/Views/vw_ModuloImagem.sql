CREATE VIEW dbo.vw_ModuloImagem
AS
SELECT M.cd_modulo, M.nm_modulo, M.cd_ordem_modulo, I.nm_arquivo_imagem, 
   I.nm_local_imagem
FROM Modulo M LEFT OUTER JOIN
   Imagem I ON (M.cd_imagem = I.cd_imagem)
WHERE ic_liberado = 'S'
