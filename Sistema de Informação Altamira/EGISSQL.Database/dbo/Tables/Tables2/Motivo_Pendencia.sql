CREATE TABLE [dbo].[Motivo_Pendencia] (
    [cd_motivo_pendencia] INT          NOT NULL,
    [nm_motivo_pendencia] VARCHAR (40) NULL,
    [sg_motivo_pendencia] CHAR (10)    NULL,
    [cd_usuario]          INT          NULL,
    [dt_usuario]          DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Pendencia] PRIMARY KEY CLUSTERED ([cd_motivo_pendencia] ASC) WITH (FILLFACTOR = 90)
);

