CREATE TABLE [dbo].[Motivo_Liberacao_Credito] (
    [cd_motivo_liberacao]     INT          NOT NULL,
    [nm_motivo_liberacao]     VARCHAR (40) NULL,
    [sg_motivo_liberacao]     CHAR (10)    NULL,
    [ic_pad_motivo_liberacao] CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Liberacao_Credito] PRIMARY KEY CLUSTERED ([cd_motivo_liberacao] ASC) WITH (FILLFACTOR = 90)
);

