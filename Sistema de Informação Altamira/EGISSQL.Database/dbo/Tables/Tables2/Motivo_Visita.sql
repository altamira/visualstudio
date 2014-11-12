CREATE TABLE [dbo].[Motivo_Visita] (
    [cd_motivo_visita]     INT          NOT NULL,
    [nm_motivo_visita]     VARCHAR (40) NULL,
    [sg_motivo_visita]     CHAR (10)    NULL,
    [ic_pad_motivo_visita] CHAR (1)     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Visita] PRIMARY KEY CLUSTERED ([cd_motivo_visita] ASC) WITH (FILLFACTOR = 90)
);

