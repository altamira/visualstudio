CREATE VIEW dbo.vw_AtributosTabela
AS
SELECT Tabela.cd_tabela,
                  Tabela.nm_tabela,
                  Atributo.cd_atributo, 
                  Atributo.nm_atributo,
                  Atributo.cd_usuario,
                  Atributo.dt_usuario,
                  Natureza_Atributo.cd_natureza_atributo, 
                  Natureza_Atributo.nm_natureza_atributo
FROM Tabela INNER JOIN
    Atributo ON Tabela.cd_tabela = Atributo.cd_tabela INNER JOIN
    Natureza_Atributo ON 
    Atributo.cd_natureza_atributo = Natureza_Atributo.cd_natureza_atributo
