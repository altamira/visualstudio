CREATE VIEW dbo.vw_Relatorio_Atributo
AS
SELECT Relatorio_Atributo.cd_relatorio, 
    Relatorio_Atributo.cd_tabela, Relatorio_Atributo.cd_atributo, 
    Atributo.nm_atributo, Tabela.nm_tabela, 
    Natureza_Atributo.nm_natureza_atributo
FROM Relatorio_Atributo INNER JOIN
    Atributo ON 
    Relatorio_Atributo.cd_tabela = Atributo.cd_tabela AND 
    Relatorio_Atributo.cd_atributo = Atributo.cd_atributo INNER JOIN
    Tabela ON Atributo.cd_tabela = Tabela.cd_tabela INNER JOIN
    Natureza_Atributo ON 
    Atributo.cd_natureza_atributo = Natureza_Atributo.cd_natureza_atributo
