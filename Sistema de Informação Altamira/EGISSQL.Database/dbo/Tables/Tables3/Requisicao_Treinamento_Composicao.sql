CREATE TABLE [dbo].[Requisicao_Treinamento_Composicao] (
    [cd_requisicao_treinamento] INT          NOT NULL,
    [cd_item_req_treinamento]   INT          NOT NULL,
    [cd_curso]                  INT          NULL,
    [ds_perfil_curso]           TEXT         NULL,
    [vl_curso_requisicao]       FLOAT (53)   NULL,
    [cd_funcionario]            INT          NULL,
    [cd_entidade_ensino]        INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [qt_carga_horaria]          FLOAT (53)   NULL,
    [dt_inicial_treinamento]    DATETIME     NULL,
    [dt_final_treinamento]      DATETIME     NULL,
    [nm_obs_treinamento]        VARCHAR (40) NULL,
    CONSTRAINT [PK_Requisicao_Treinamento_Composicao] PRIMARY KEY CLUSTERED ([cd_requisicao_treinamento] ASC, [cd_item_req_treinamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Requisicao_Treinamento_Composicao_Entidade_Ensino] FOREIGN KEY ([cd_entidade_ensino]) REFERENCES [dbo].[Entidade_Ensino] ([cd_entidade_ensino])
);

