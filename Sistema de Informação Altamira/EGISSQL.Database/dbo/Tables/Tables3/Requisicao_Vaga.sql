CREATE TABLE [dbo].[Requisicao_Vaga] (
    [cd_requisicao_vaga]      INT      NOT NULL,
    [dt_requisicao_vaga]      DATETIME NULL,
    [cd_departamento]         INT      NULL,
    [cd_seccao]               INT      NULL,
    [cd_requisitante_vaga]    INT      NULL,
    [ds_requisicao_vaga]      TEXT     NULL,
    [cd_motivo_vaga]          INT      NULL,
    [cd_usuario]              INT      NULL,
    [dt_usuario]              DATETIME NULL,
    [cd_cliente]              INT      NULL,
    [cd_tipo_vaga]            INT      NULL,
    [ic_liberado_selecao]     CHAR (1) NULL,
    [dt_cancelamento]         DATETIME NULL,
    [dt_baixa_requisicao]     DATETIME NULL,
    [dt_necessidade_vaga]     DATETIME NULL,
    [cd_centro_custo]         INT      NULL,
    [dt_liberacao_requisicao] DATETIME NULL,
    CONSTRAINT [PK_Requisicao_Vaga] PRIMARY KEY CLUSTERED ([cd_requisicao_vaga] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Vaga_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo])
);

