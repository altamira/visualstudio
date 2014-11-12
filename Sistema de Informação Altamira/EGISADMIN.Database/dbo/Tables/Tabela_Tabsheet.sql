CREATE TABLE [dbo].[Tabela_Tabsheet] (
    [cd_tabela]         INT          NOT NULL,
    [cd_tabsheet]       INT          NOT NULL,
    [cd_ordem_tabsheet] INT          NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [nm_hint_tabsheet]  VARCHAR (40) NULL,
    [nm_obs_tabsheet]   VARCHAR (40) NULL,
    CONSTRAINT [PK_Tabela_Tabsheet] PRIMARY KEY CLUSTERED ([cd_tabela] ASC, [cd_tabsheet] ASC) WITH (FILLFACTOR = 90)
);

