CREATE TABLE [dbo].[Motivo_Vaga] (
    [cd_motivo_vaga] INT          NOT NULL,
    [nm_motivo_vaga] VARCHAR (40) NULL,
    [sg_motivo_vaga] CHAR (10)    NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Vaga] PRIMARY KEY CLUSTERED ([cd_motivo_vaga] ASC) WITH (FILLFACTOR = 90)
);

