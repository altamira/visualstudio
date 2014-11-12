CREATE TABLE [dbo].[Requisicao_Treinamento] (
    [cd_requisicao_treinamento]  INT      NOT NULL,
    [dt_requisicao_treinamento]  DATETIME NULL,
    [cd_departamento]            INT      NULL,
    [cd_seccao]                  INT      NULL,
    [cd_motivo_treinamento]      INT      NULL,
    [ds_requisicao_treinamento]  TEXT     NULL,
    [cd_usuario_treinamento]     INT      NULL,
    [cd_usuario]                 INT      NULL,
    [dt_usuario]                 DATETIME NULL,
    [cd_centro_custo]            INT      NULL,
    [ic_liberacao_requisicao]    CHAR (1) NULL,
    [dt_liberacao_requisicao]    DATETIME NULL,
    [cd_tipo_treinamento]        INT      NULL,
    [dt_necessidade_treinamento] DATETIME NULL,
    CONSTRAINT [PK_Requisicao_Treinamento] PRIMARY KEY CLUSTERED ([cd_requisicao_treinamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Treinamento_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo]),
    CONSTRAINT [FK_Requisicao_Treinamento_Tipo_Treinamento] FOREIGN KEY ([cd_tipo_treinamento]) REFERENCES [dbo].[Tipo_Treinamento] ([cd_tipo_treinamento]),
    CONSTRAINT [FK_Requisicao_Treinamento_Usuario] FOREIGN KEY ([cd_usuario_treinamento]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

