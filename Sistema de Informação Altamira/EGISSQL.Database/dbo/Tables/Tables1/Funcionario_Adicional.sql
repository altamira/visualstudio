CREATE TABLE [dbo].[Funcionario_Adicional] (
    [cd_funcionario]            INT          NOT NULL,
    [cd_contribuicao_adicional] INT          NULL,
    [ic_tempo_servico]          CHAR (1)     NULL,
    [dt_tempo_servico]          DATETIME     NULL,
    [pc_tempo_servico]          FLOAT (53)   NULL,
    [ic_adicional_funcao]       CHAR (1)     NULL,
    [vl_adicional_funcao]       MONEY        NULL,
    [ic_premio_producao]        CHAR (1)     NULL,
    [vl_premio_producao]        MONEY        NULL,
    [pc_semfalta_premio]        FLOAT (53)   NULL,
    [pc_comfalta_premio]        FLOAT (53)   NULL,
    [nm_obs_adicional]          VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Funcionario_Adicional] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC) WITH (FILLFACTOR = 90)
);

