CREATE TABLE [dbo].[Motivo_Retirada_Documento] (
    [cd_motivo_retirada]        INT          NOT NULL,
    [nm_motivo_retirada]        VARCHAR (40) NULL,
    [sg_motivo_retirada]        CHAR (10)    NULL,
    [ic_padrao_motivo_retirada] CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [qt_dia_devolucao]          INT          NULL,
    CONSTRAINT [PK_Motivo_Retirada_Documento] PRIMARY KEY CLUSTERED ([cd_motivo_retirada] ASC) WITH (FILLFACTOR = 90)
);

