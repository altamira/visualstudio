CREATE TABLE [dbo].[Maquina_Turno] (
    [ic_operacao]              CHAR (1)   NOT NULL,
    [cd_usuario]               INT        NOT NULL,
    [dt_usuario]               DATETIME   NOT NULL,
    [cd_turno]                 INT        NOT NULL,
    [cd_maquina]               INT        NOT NULL,
    [qt_hora_operacao_maquina] FLOAT (53) NOT NULL,
    CONSTRAINT [PK_Maquina_Turno] PRIMARY KEY CLUSTERED ([cd_turno] ASC, [cd_maquina] ASC) WITH (FILLFACTOR = 90)
);

