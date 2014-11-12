CREATE TABLE [dbo].[Modulo_Tabela] (
    [cd_modulo]             INT          NOT NULL,
    [cd_tabela]             INT          NOT NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_item_modulo_tabela] INT          NULL,
    [cd_procedimento]       INT          NULL,
    [cd_view]               INT          NULL,
    [cd_trigger]            INT          NULL,
    [nm_obs_modulo_tabela]  VARCHAR (40) NULL,
    CONSTRAINT [PK_Modulo_Tabela] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_tabela] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Modulo_Tabela_Procedimento] FOREIGN KEY ([cd_procedimento]) REFERENCES [dbo].[Procedimento] ([cd_procedimento]),
    CONSTRAINT [FK_Modulo_Tabela_Trigger_] FOREIGN KEY ([cd_trigger]) REFERENCES [dbo].[Trigger_] ([cd_trigger]),
    CONSTRAINT [FK_Modulo_Tabela_View_] FOREIGN KEY ([cd_view]) REFERENCES [dbo].[View_] ([cd_view])
);

