CREATE TABLE [dbo].[Grupo_Bem] (
    [cd_grupo_bem]             INT          NOT NULL,
    [nm_grupo_bem]             VARCHAR (30) NULL,
    [sg_grupo_bem]             CHAR (10)    NULL,
    [nm_mascara_grupo_bem]     VARCHAR (20) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_depreciacao_grupo_bem] CHAR (1)     NULL,
    [pc_depreciacao_grupo_bem] FLOAT (53)   NULL,
    [pc_amortizacao_grupo_bem] FLOAT (53)   NULL,
    [qt_vida_util_grupo_bem]   INT          NULL,
    [cd_lancamento_padrao]     INT          NULL,
    [qt_coef_1turno_grupo_bem] FLOAT (53)   NULL,
    [qt_coef_2turno_grupo_bem] FLOAT (53)   NULL,
    [qt_coef_3turno_grupo_bem] FLOAT (53)   NULL,
    [cd_ref_conta_grupo_bem]   VARCHAR (20) NULL,
    [nm_obs_grupo_bem]         VARCHAR (40) NULL,
    [cd_conta]                 INT          NULL,
    CONSTRAINT [PK_Grupo_Bem] PRIMARY KEY CLUSTERED ([cd_grupo_bem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Bem_Lancamento_Padrao] FOREIGN KEY ([cd_lancamento_padrao]) REFERENCES [dbo].[Lancamento_Padrao] ([cd_lancamento_padrao])
);

