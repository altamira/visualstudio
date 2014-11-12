CREATE TABLE [dbo].[RNC_Acao_Corretiva] (
    [cd_rnc]                INT          NOT NULL,
    [cd_acao_corretiva]     INT          NOT NULL,
    [cd_departamento]       INT          NULL,
    [cd_usuario_acao_rnc]   INT          NULL,
    [dt_inicial_acao_rnc]   DATETIME     NULL,
    [dt_final_acao_rnc]     DATETIME     NULL,
    [dt_conclusao_acao_rnc] DATETIME     NULL,
    [nm_obs_acao_rnc]       VARCHAR (40) NULL,
    [ds_acao_rnc]           TEXT         NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_RNC_Acao_Corretiva] PRIMARY KEY CLUSTERED ([cd_rnc] ASC, [cd_acao_corretiva] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_RNC_Acao_Corretiva_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

