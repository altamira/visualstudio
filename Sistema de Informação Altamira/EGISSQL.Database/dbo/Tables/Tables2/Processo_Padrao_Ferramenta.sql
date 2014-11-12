CREATE TABLE [dbo].[Processo_Padrao_Ferramenta] (
    [cd_processo_padrao]         INT          NOT NULL,
    [cd_maquina]                 INT          NULL,
    [cd_operacao]                INT          NULL,
    [cd_ferramenta]              INT          NULL,
    [nm_obs_ferramenta_processo] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [cd_item_ferramenta]         INT          NOT NULL,
    CONSTRAINT [PK_Processo_Padrao_Ferramenta] PRIMARY KEY CLUSTERED ([cd_processo_padrao] ASC, [cd_item_ferramenta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Padrao_Ferramenta_Ferramenta] FOREIGN KEY ([cd_ferramenta]) REFERENCES [dbo].[Ferramenta] ([cd_ferramenta])
);

