CREATE TABLE [dbo].[Motivo_Reprogramacao] (
    [cd_motivo_reprogramacao] INT          NOT NULL,
    [nm_motivo_reprogramacao] VARCHAR (40) NULL,
    [sg_motivo_reprogramacao] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_padrao_motivo]        CHAR (1)     NULL,
    CONSTRAINT [PK_Motivo_Reprogramacao] PRIMARY KEY CLUSTERED ([cd_motivo_reprogramacao] ASC) WITH (FILLFACTOR = 90)
);

