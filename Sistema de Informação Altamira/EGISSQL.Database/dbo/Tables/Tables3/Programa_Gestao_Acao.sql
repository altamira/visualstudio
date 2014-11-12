CREATE TABLE [dbo].[Programa_Gestao_Acao] (
    [cd_programa]            INT          NOT NULL,
    [cd_item_programa]       INT          NOT NULL,
    [nm_atividade_programa]  VARCHAR (40) NULL,
    [ds_atividade_programa]  TEXT         NULL,
    [cd_usuario_responsavel] INT          NULL,
    [dt_inicio_atividade]    DATETIME     NULL,
    [dt_final_atividade]     DATETIME     NULL,
    [dt_conclusao_atividade] DATETIME     NULL,
    [cd_status_atividade]    INT          NULL,
    [nm_obs_atividade]       VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Programa_Gestao_Acao] PRIMARY KEY CLUSTERED ([cd_programa] ASC, [cd_item_programa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Programa_Gestao_Acao_Status_Atividade] FOREIGN KEY ([cd_status_atividade]) REFERENCES [dbo].[Status_Atividade] ([cd_status_atividade])
);

