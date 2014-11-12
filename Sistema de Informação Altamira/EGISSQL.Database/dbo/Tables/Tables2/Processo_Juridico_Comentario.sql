CREATE TABLE [dbo].[Processo_Juridico_Comentario] (
    [cd_processo_comentario]     INT          NOT NULL,
    [dt_processo_comentario]     DATETIME     NULL,
    [cd_processo_juridico]       INT          NOT NULL,
    [cd_advogado]                INT          NULL,
    [ds_processo_comentario]     TEXT         NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [nm_obs_processo_comentario] VARCHAR (40) NULL,
    CONSTRAINT [PK_Processo_Juridico_Comentario] PRIMARY KEY CLUSTERED ([cd_processo_comentario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Juridico_Comentario_Advogado] FOREIGN KEY ([cd_advogado]) REFERENCES [dbo].[Advogado] ([cd_advogado])
);

