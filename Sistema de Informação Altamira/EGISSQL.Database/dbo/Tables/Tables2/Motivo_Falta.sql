CREATE TABLE [dbo].[Motivo_Falta] (
    [cd_motivo_falta]      INT          NOT NULL,
    [nm_motivo_falta]      VARCHAR (40) NULL,
    [ic_justificada_falta] CHAR (1)     NULL,
    [ic_desconto_falta]    CHAR (1)     NULL,
    [ic_ferias_falta]      CHAR (1)     NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Falta] PRIMARY KEY CLUSTERED ([cd_motivo_falta] ASC)
);

