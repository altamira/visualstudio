CREATE TABLE [dbo].[Bem_Penhora] (
    [cd_bem_penhora]            INT          NOT NULL,
    [cd_processo_juridico]      INT          NOT NULL,
    [nm_bem_penhora]            VARCHAR (60) NULL,
    [cd_identificacao_bem]      VARCHAR (20) NULL,
    [ds_bem_penhora]            TEXT         NULL,
    [dt_avaliacao_bem_penhora]  DATETIME     NULL,
    [nm_avaliador_bem_penhora]  VARCHAR (60) NULL,
    [vl_original_bem_penhora]   FLOAT (53)   NULL,
    [vl_atualizado_bem_penhora] FLOAT (53)   NULL,
    [nm_obs_bem_penhora]        VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Bem_Penhora] PRIMARY KEY CLUSTERED ([cd_bem_penhora] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Bem_Penhora_Processo_Juridico] FOREIGN KEY ([cd_processo_juridico]) REFERENCES [dbo].[Processo_Juridico] ([cd_processo_juridico])
);

