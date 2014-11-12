CREATE TABLE [dbo].[Motivo_Demissao] (
    [cd_motivo_demissao] INT          NOT NULL,
    [nm_motivo_demissao] VARCHAR (40) NULL,
    [sg_motivo_demissao] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Demissao] PRIMARY KEY CLUSTERED ([cd_motivo_demissao] ASC) WITH (FILLFACTOR = 90)
);

