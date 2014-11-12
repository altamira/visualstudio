CREATE TABLE [dbo].[Movimento_Operador] (
    [cd_movimento_operador]     INT          NOT NULL,
    [dt_movimento_operador]     DATETIME     NULL,
    [cd_operador]               INT          NULL,
    [cd_maquina]                INT          NULL,
    [cd_status_operador]        INT          NULL,
    [dt_inicio_mov_operador]    DATETIME     NULL,
    [dt_final_mov_operador]     DATETIME     NULL,
    [nm_obs_movimento_operador] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [qt_movimento_operador]     FLOAT (53)   NULL,
    [cd_processo]               INT          NULL,
    [hr_inicio_movimento]       VARCHAR (8)  NULL,
    [hr_final_movimento]        VARCHAR (8)  NULL,
    CONSTRAINT [PK_Movimento_Operador] PRIMARY KEY CLUSTERED ([cd_movimento_operador] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Movimento_Operador_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina]),
    CONSTRAINT [FK_Movimento_Operador_Operador] FOREIGN KEY ([cd_operador]) REFERENCES [dbo].[Operador] ([cd_operador]),
    CONSTRAINT [FK_Movimento_Operador_Processo_Producao] FOREIGN KEY ([cd_processo]) REFERENCES [dbo].[Processo_Producao] ([cd_processo]),
    CONSTRAINT [FK_Movimento_Operador_Status_Operador] FOREIGN KEY ([cd_status_operador]) REFERENCES [dbo].[Status_Operador] ([cd_status_operador])
);

