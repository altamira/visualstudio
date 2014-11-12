CREATE TABLE [dbo].[Grupo_Bem_Contabilizacao] (
    [cd_grupo_bem]                INT          NOT NULL,
    [cd_lancamento_padrao]        INT          NOT NULL,
    [nm_obs_contabilizacao_grupo] VARCHAR (40) NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [cd_tipo_contabilizacao]      INT          NULL,
    CONSTRAINT [PK_Grupo_Bem_Contabilizacao] PRIMARY KEY CLUSTERED ([cd_grupo_bem] ASC, [cd_lancamento_padrao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Bem_Contabilizacao_Lancamento_Padrao] FOREIGN KEY ([cd_lancamento_padrao]) REFERENCES [dbo].[Lancamento_Padrao] ([cd_lancamento_padrao]),
    CONSTRAINT [FK_Grupo_Bem_Contabilizacao_Tipo_Contabilizacao] FOREIGN KEY ([cd_tipo_contabilizacao]) REFERENCES [dbo].[Tipo_Contabilizacao] ([cd_tipo_contabilizacao])
);

