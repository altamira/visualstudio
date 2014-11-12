CREATE TABLE [dbo].[Motivo_Treinamento] (
    [cd_motivo_treinamento] INT          NOT NULL,
    [nm_motivo_treinamento] VARCHAR (40) NULL,
    [sg_motivo_treinamento] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Treinamento] PRIMARY KEY CLUSTERED ([cd_motivo_treinamento] ASC) WITH (FILLFACTOR = 90)
);

