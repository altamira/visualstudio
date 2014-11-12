CREATE VIEW dbo.vw_SloganAtivo
AS
SELECT ds_slogan
FROM Slogan
WHERE ic_ativo_slogan = 'S'
