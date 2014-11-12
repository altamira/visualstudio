CREATE TABLE [dbo].[Faltas] (
    [cd_falta]             INT          NOT NULL,
    [dt_lancamento_falta]  DATETIME     NULL,
    [dt_falta]             DATETIME     NULL,
    [cd_funcionario]       INT          NOT NULL,
    [cd_motivo_falta]      INT          NOT NULL,
    [ic_justificada_falta] CHAR (1)     NULL,
    [ic_desconto_falta]    CHAR (1)     NULL,
    [ic_ferias_falta]      CHAR (1)     NULL,
    [nm_obs_falta]         VARCHAR (60) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Faltas] PRIMARY KEY CLUSTERED ([cd_falta] ASC),
    CONSTRAINT [FK_Faltas_Motivo_Falta] FOREIGN KEY ([cd_motivo_falta]) REFERENCES [dbo].[Motivo_Falta] ([cd_motivo_falta])
);

