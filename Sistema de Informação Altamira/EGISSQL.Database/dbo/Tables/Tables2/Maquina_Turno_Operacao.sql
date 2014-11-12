CREATE TABLE [dbo].[Maquina_Turno_Operacao] (
    [cd_maquina]               INT          NOT NULL,
    [cd_turno]                 INT          NOT NULL,
    [ic_dia1_operacao_maquina] CHAR (1)     NULL,
    [ic_dia2_operacao_maquina] CHAR (1)     NULL,
    [ic_dia3_operacao_maquina] CHAR (1)     NULL,
    [ic_dia4_operacao_maquina] CHAR (1)     NULL,
    [ic_dia5_operacao_maquina] CHAR (1)     NULL,
    [ic_dia6_operacao_maquina] CHAR (1)     NULL,
    [ic_dia7_operacao_maquina] CHAR (1)     NULL,
    [nm_obs_maquina_operacao]  VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Maquina_Turno_Operacao] PRIMARY KEY CLUSTERED ([cd_maquina] ASC, [cd_turno] ASC) WITH (FILLFACTOR = 90)
);

