CREATE TABLE [dbo].[Tabela_Tabsheet_Atributo] (
    [cd_tabela]         INT      NOT NULL,
    [cd_tabsheet]       INT      NOT NULL,
    [cd_atributo]       INT      NOT NULL,
    [cd_ordem_atributo] INT      NULL,
    [cd_usuario]        INT      NULL,
    [dt_usuario]        DATETIME NULL,
    CONSTRAINT [PK_Tabela_Tabsheet_Atributo] PRIMARY KEY CLUSTERED ([cd_tabela] ASC, [cd_tabsheet] ASC, [cd_atributo] ASC) WITH (FILLFACTOR = 90)
);

