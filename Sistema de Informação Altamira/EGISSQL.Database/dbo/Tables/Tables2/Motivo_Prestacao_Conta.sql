CREATE TABLE [dbo].[Motivo_Prestacao_Conta] (
    [cd_motivo_prestacao]     INT          NOT NULL,
    [nm_motivo_prestacao]     VARCHAR (40) NULL,
    [sg_motivo_prestacao]     CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_pad_motivo_prestacao] CHAR (1)     NULL,
    CONSTRAINT [PK_Motivo_Prestacao_Conta] PRIMARY KEY CLUSTERED ([cd_motivo_prestacao] ASC) WITH (FILLFACTOR = 90)
);

