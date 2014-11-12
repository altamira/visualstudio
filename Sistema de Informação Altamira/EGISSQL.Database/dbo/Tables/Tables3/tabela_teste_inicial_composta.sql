CREATE TABLE [dbo].[tabela_teste_inicial_composta] (
    [cd_tab_teste_inicial_cp]  INT NOT NULL,
    [cd_tab_teste_inicial_cp2] INT NOT NULL,
    CONSTRAINT [PK_tabela_teste_inicial_composta] PRIMARY KEY CLUSTERED ([cd_tab_teste_inicial_cp] ASC, [cd_tab_teste_inicial_cp2] ASC) WITH (FILLFACTOR = 90)
);

