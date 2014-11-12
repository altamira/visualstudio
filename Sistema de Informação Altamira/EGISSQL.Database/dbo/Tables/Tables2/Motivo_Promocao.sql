CREATE TABLE [dbo].[Motivo_Promocao] (
    [cd_motivo_promocao] INT          NOT NULL,
    [nm_motivo_promocao] VARCHAR (40) NULL,
    [sg_motivo_promocao] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Promocao] PRIMARY KEY CLUSTERED ([cd_motivo_promocao] ASC) WITH (FILLFACTOR = 90)
);

