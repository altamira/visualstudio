CREATE TABLE [dbo].[Motivo_Inspecao] (
    [cd_motivo_inspecao] INT          NOT NULL,
    [nm_motivo_inspecao] VARCHAR (40) NULL,
    [sg_motivo_inspecao] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Inspecao] PRIMARY KEY CLUSTERED ([cd_motivo_inspecao] ASC) WITH (FILLFACTOR = 90)
);

