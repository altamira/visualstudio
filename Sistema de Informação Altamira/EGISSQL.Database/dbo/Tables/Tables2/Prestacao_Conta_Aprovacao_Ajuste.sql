CREATE TABLE [dbo].[Prestacao_Conta_Aprovacao_Ajuste] (
    [cd_prestacao]         INT          NOT NULL,
    [cd_tipo_aprovacao]    INT          NOT NULL,
    [cd_usuario_aprovacao] INT          NULL,
    [dt_usuario_aprovacao] DATETIME     NULL,
    [nm_obs_aprovacao]     VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [ic_aprovado]          CHAR (1)     NULL,
    [cd_funcionario]       INT          NULL,
    CONSTRAINT [PK_Prestacao_Conta_Aprovacao_Ajuste] PRIMARY KEY CLUSTERED ([cd_prestacao] ASC, [cd_tipo_aprovacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Prestacao_Conta_Aprovacao_Ajuste_Tipo_Aprovacao] FOREIGN KEY ([cd_tipo_aprovacao]) REFERENCES [dbo].[Tipo_Aprovacao] ([cd_tipo_aprovacao])
);

