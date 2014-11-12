CREATE TABLE [dbo].[Motivo_Recebimento] (
    [cd_motivo_recebimento]     INT          NOT NULL,
    [nm_motivo_recebimento]     VARCHAR (40) NULL,
    [sg_motivo_recebimento]     CHAR (10)    NULL,
    [ic_pad_motivo_recebimento] CHAR (1)     NULL,
    [ic_conf_mot_recebimento]   CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Recebimento] PRIMARY KEY CLUSTERED ([cd_motivo_recebimento] ASC) WITH (FILLFACTOR = 90)
);

