CREATE TABLE [dbo].[Maquina_Operacao] (
    [cd_maquina]                INT          NOT NULL,
    [cd_operacao]               INT          NOT NULL,
    [cd_maquina_operacao]       INT          NOT NULL,
    [qt_prioridade_maq_oper]    FLOAT (53)   NULL,
    [pc_efic_maquina_operacao]  FLOAT (53)   NULL,
    [pc_red_efic_maq_operacao]  FLOAT (53)   NULL,
    [qt_tempo_maquina_operacao] FLOAT (53)   NULL,
    [nm_obs_maquina_operacao]   VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [pc_custo_maq_operacao]     FLOAT (53)   NULL,
    [pc_prog_maquina_operacao]  FLOAT (53)   NULL,
    [qt_tempo_padrao_maquina]   FLOAT (53)   NULL,
    [qt_setup_padrao_maquina]   FLOAT (53)   NULL,
    CONSTRAINT [PK_Maquina_Operacao] PRIMARY KEY CLUSTERED ([cd_maquina] ASC, [cd_operacao] ASC, [cd_maquina_operacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Maquina_Operacao_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina]),
    CONSTRAINT [FK_Maquina_Operacao_Operacao] FOREIGN KEY ([cd_operacao]) REFERENCES [dbo].[Operacao] ([cd_operacao])
);

