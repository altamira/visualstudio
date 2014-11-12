CREATE TABLE [dbo].[Tabela_Composicao] (
    [cd_tabela]                 INT          NOT NULL,
    [cd_item_tabela_composicao] INT          NOT NULL,
    [cd_tabela_composicao]      INT          NULL,
    [nm_obs_tabela_composicao]  VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Tabela_Composicao] PRIMARY KEY CLUSTERED ([cd_tabela] ASC, [cd_item_tabela_composicao] ASC) WITH (FILLFACTOR = 90)
);

