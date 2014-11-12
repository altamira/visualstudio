CREATE TABLE [dbo].[Motivo_Ocorrencia_Entrega] (
    [cd_motivo_ocorrencia] INT          NOT NULL,
    [nm_motivo_ocorrencia] VARCHAR (40) NULL,
    [sg_motivo_ocorrencia] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Ocorrencia_Entrega] PRIMARY KEY CLUSTERED ([cd_motivo_ocorrencia] ASC) WITH (FILLFACTOR = 90)
);

