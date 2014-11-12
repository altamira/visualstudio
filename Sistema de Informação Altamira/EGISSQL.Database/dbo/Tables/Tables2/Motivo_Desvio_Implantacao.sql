CREATE TABLE [dbo].[Motivo_Desvio_Implantacao] (
    [cd_motivo_desvio]     INT          NOT NULL,
    [nm_motivo_desvio]     VARCHAR (40) NULL,
    [sg_motivo_desvio]     CHAR (10)    NULL,
    [ic_pad_motivo_desvio] CHAR (1)     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Desvio_Implantacao] PRIMARY KEY CLUSTERED ([cd_motivo_desvio] ASC) WITH (FILLFACTOR = 90)
);

