CREATE TABLE [dbo].[Pendencia] (
    [cd_pendencia]            INT          NOT NULL,
    [dt_pendencia]            DATETIME     NULL,
    [nm_pendencia]            VARCHAR (40) NULL,
    [ds_pendencia]            TEXT         NULL,
    [cd_status_pendencia]     INT          NULL,
    [cd_prioridade_pendencia] INT          NULL,
    [dt_inicio_pendencia]     DATETIME     NULL,
    [dt_aviso_pendencia]      DATETIME     NULL,
    [dt_entrega_pendencia]    DATETIME     NULL,
    [dt_resolucao_pendencia]  DATETIME     NULL,
    [ic_ocorrencia_pendencia] CHAR (1)     NULL,
    [cd_ocorrencia]           INT          NULL,
    [cd_modulo]               INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Pendencia] PRIMARY KEY CLUSTERED ([cd_pendencia] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pendencia_Prioridade_Pendencia] FOREIGN KEY ([cd_prioridade_pendencia]) REFERENCES [dbo].[Prioridade_Pendencia] ([cd_prioridade_pendencia]),
    CONSTRAINT [FK_Pendencia_Status_Pendencia] FOREIGN KEY ([cd_status_pendencia]) REFERENCES [dbo].[Status_Pendencia] ([cd_status_pendencia]),
    CONSTRAINT [FK_Pendencia_Usuario] FOREIGN KEY ([cd_usuario]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

