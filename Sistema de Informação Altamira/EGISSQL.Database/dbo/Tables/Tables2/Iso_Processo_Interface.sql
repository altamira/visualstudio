CREATE TABLE [dbo].[Iso_Processo_Interface] (
    [cd_iso_processo]           INT          NOT NULL,
    [cd_item_iso_processo]      INT          NOT NULL,
    [cd_iso_processo_interface] INT          NOT NULL,
    [nm_obs_iso_processo_inter] VARCHAR (40) NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Iso_Processo_Interface] PRIMARY KEY CLUSTERED ([cd_item_iso_processo] ASC, [cd_iso_processo_interface] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Iso_Processo_Interface_Iso_Processo] FOREIGN KEY ([cd_iso_processo]) REFERENCES [dbo].[Iso_Processo] ([cd_iso_processo])
);

