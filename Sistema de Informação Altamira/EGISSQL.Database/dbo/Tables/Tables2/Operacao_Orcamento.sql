CREATE TABLE [dbo].[Operacao_Orcamento] (
    [cd_operacao]               INT          NULL,
    [cd_operacao_orcamento]     INT          NOT NULL,
    [cd_grupo_orcamento]        INT          NOT NULL,
    [nm_obs_operacao_orcamento] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Operacao_Orcamento] PRIMARY KEY CLUSTERED ([cd_operacao_orcamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Operacao_Orcamento_Grupo_Orcamento] FOREIGN KEY ([cd_grupo_orcamento]) REFERENCES [dbo].[Grupo_Orcamento] ([cd_grupo_orcamento]),
    CONSTRAINT [FK_Operacao_Orcamento_Operacao] FOREIGN KEY ([cd_operacao]) REFERENCES [dbo].[Operacao] ([cd_operacao])
);

