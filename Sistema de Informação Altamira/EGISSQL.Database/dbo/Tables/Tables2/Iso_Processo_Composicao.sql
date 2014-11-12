CREATE TABLE [dbo].[Iso_Processo_Composicao] (
    [cd_iso_processo]          INT           NOT NULL,
    [cd_item_iso_processo]     INT           NOT NULL,
    [cd_iso_tarefa]            INT           NULL,
    [nm_item_iso_processo]     VARCHAR (60)  NULL,
    [ds_item_iso_processo]     TEXT          NULL,
    [cd_cargo_empresa]         INT           NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [nm_doc_item_iso_processo] VARCHAR (100) NULL,
    [nm_obs_item_iso_processo] VARCHAR (40)  NULL,
    CONSTRAINT [PK_Iso_Processo_Composicao] PRIMARY KEY CLUSTERED ([cd_iso_processo] ASC, [cd_item_iso_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Iso_Processo_Composicao_Cargo_Empresa] FOREIGN KEY ([cd_cargo_empresa]) REFERENCES [dbo].[Cargo_Empresa] ([cd_cargo_empresa]),
    CONSTRAINT [FK_Iso_Processo_Composicao_Iso_Tarefa] FOREIGN KEY ([cd_iso_tarefa]) REFERENCES [dbo].[Iso_Tarefa] ([cd_iso_tarefa])
);

