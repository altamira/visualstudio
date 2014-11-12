CREATE TABLE [dbo].[Motivo_Perda] (
    [cd_motivo_perda]       INT          NOT NULL,
    [nm_motivo_perda]       VARCHAR (30) NOT NULL,
    [sg_motivo_perda]       CHAR (10)    NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    [ic_pad_motivo_perda]   CHAR (1)     NULL,
    [ic_ativo_motivo_perda] CHAR (1)     NULL
);

