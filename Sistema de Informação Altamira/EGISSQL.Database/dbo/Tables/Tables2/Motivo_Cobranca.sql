CREATE TABLE [dbo].[Motivo_Cobranca] (
    [cd_motivo_cobranca]     INT          NOT NULL,
    [nm_motivo_cobranca]     VARCHAR (40) NULL,
    [sg_motivo_cobranca]     CHAR (10)    NULL,
    [ic_pad_motivo_cobranca] CHAR (1)     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Cobranca] PRIMARY KEY CLUSTERED ([cd_motivo_cobranca] ASC) WITH (FILLFACTOR = 90)
);

