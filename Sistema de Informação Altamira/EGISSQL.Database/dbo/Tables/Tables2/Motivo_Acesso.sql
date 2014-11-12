CREATE TABLE [dbo].[Motivo_Acesso] (
    [cd_motivo_acesso]        INT          NOT NULL,
    [nm_motivo_acesso]        VARCHAR (40) NULL,
    [sg_motivo_acesso]        CHAR (10)    NULL,
    [ic_padrao_motivo_acesso] CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Acesso] PRIMARY KEY CLUSTERED ([cd_motivo_acesso] ASC) WITH (FILLFACTOR = 90)
);

