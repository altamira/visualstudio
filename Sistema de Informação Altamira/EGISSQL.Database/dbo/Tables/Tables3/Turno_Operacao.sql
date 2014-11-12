CREATE TABLE [dbo].[Turno_Operacao] (
    [cd_turno]               INT          NOT NULL,
    [ic_dia1_operacao_turno] CHAR (1)     NULL,
    [ic_dia2_operacao_turno] CHAR (1)     NULL,
    [ic_dia3_operacao_turno] CHAR (1)     NULL,
    [ic_dia4_operacao_turno] CHAR (1)     NULL,
    [ic_dia5_operacao_turno] CHAR (1)     NULL,
    [ic_dia6_operacao_turno] CHAR (1)     NULL,
    [ic_dia7_operacao_turno] CHAR (1)     NULL,
    [nm_obs_turno_operacao]  VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Turno_Operacao] PRIMARY KEY CLUSTERED ([cd_turno] ASC) WITH (FILLFACTOR = 90)
);

