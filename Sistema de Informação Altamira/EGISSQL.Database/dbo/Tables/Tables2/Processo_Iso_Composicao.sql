CREATE TABLE [dbo].[Processo_Iso_Composicao] (
    [cd_processo_iso]           INT      NOT NULL,
    [cd_item_processo_iso]      INT      NOT NULL,
    [cd_tarefa_iso]             INT      NOT NULL,
    [ds_processo_iso_composica] TEXT     NOT NULL,
    [cd_cargo_empresa]          INT      NOT NULL,
    [cd_usuario]                INT      NOT NULL,
    [dt_usuario]                DATETIME NOT NULL,
    CONSTRAINT [PK_Processo_Iso_Composicao] PRIMARY KEY CLUSTERED ([cd_processo_iso] ASC, [cd_item_processo_iso] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Iso_Composicao_Cargo_Empresa] FOREIGN KEY ([cd_cargo_empresa]) REFERENCES [dbo].[Cargo_Empresa] ([cd_cargo_empresa]),
    CONSTRAINT [FK_Processo_Iso_Composicao_Tarefa_Iso] FOREIGN KEY ([cd_tarefa_iso]) REFERENCES [dbo].[Tarefa_Iso] ([cd_tarefa_iso])
);

