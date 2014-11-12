CREATE TABLE [dbo].[Processo_Producao_Inspecao] (
    [cd_processo]               INT          NOT NULL,
    [cd_item_inspecao_processo] INT          NOT NULL,
    [cd_inspetor]               INT          NULL,
    [dt_inspecao_processo]      DATETIME     NULL,
    [ic_status_inspecao]        CHAR (1)     NULL,
    [ds_inspecao_processo]      TEXT         NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_tipo_inspecao]          INT          NULL,
    [cd_motivo_inspecao]        INT          NULL,
    [nm_obs_inspecao_processo]  VARCHAR (40) NULL,
    CONSTRAINT [PK_Processo_Producao_Inspecao] PRIMARY KEY CLUSTERED ([cd_processo] ASC, [cd_item_inspecao_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Producao_Inspecao_Motivo_Inspecao] FOREIGN KEY ([cd_motivo_inspecao]) REFERENCES [dbo].[Motivo_Inspecao] ([cd_motivo_inspecao])
);

