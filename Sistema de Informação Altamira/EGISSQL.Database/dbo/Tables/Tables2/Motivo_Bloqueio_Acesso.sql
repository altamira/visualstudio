CREATE TABLE [dbo].[Motivo_Bloqueio_Acesso] (
    [cd_motivo_bloqueio] INT          NOT NULL,
    [nm_motivo_bloqueio] VARCHAR (40) NULL,
    [sg_motivo_bloqueio] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Bloqueio_Acesso] PRIMARY KEY CLUSTERED ([cd_motivo_bloqueio] ASC) WITH (FILLFACTOR = 90)
);

