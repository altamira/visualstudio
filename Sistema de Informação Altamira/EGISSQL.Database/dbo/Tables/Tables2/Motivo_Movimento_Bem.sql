CREATE TABLE [dbo].[Motivo_Movimento_Bem] (
    [cd_motivo_movimento_bem] INT          NOT NULL,
    [nm_motivo_movimento_bem] VARCHAR (40) NULL,
    [sg_motivo_movimento_bem] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Movimento_Bem] PRIMARY KEY CLUSTERED ([cd_motivo_movimento_bem] ASC) WITH (FILLFACTOR = 90)
);

