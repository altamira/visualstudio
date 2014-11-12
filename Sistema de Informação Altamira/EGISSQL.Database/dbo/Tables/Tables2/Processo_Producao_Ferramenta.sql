CREATE TABLE [dbo].[Processo_Producao_Ferramenta] (
    [cd_processo_producao]       INT          NOT NULL,
    [cd_operacao]                INT          NULL,
    [cd_maquina]                 INT          NULL,
    [cd_ferramenta]              INT          NOT NULL,
    [nm_obs_ferramenta_processo] VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [cd_item_ferramenta]         INT          NOT NULL,
    CONSTRAINT [PK_Processo_Producao_Ferramenta] PRIMARY KEY CLUSTERED ([cd_processo_producao] ASC, [cd_item_ferramenta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Producao_Ferramenta_Ferramenta] FOREIGN KEY ([cd_ferramenta]) REFERENCES [dbo].[Ferramenta] ([cd_ferramenta])
);

