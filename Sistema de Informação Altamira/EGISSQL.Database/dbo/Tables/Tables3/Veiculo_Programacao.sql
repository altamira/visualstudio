CREATE TABLE [dbo].[Veiculo_Programacao] (
    [cd_programacao]      INT        NOT NULL,
    [dt_programacao]      DATETIME   NULL,
    [cd_veiculo]          INT        NULL,
    [cd_motorista]        INT        NULL,
    [cd_evento]           INT        NULL,
    [qt_hora_programacao] FLOAT (53) NULL,
    [cd_local_saida]      INT        NULL,
    [cd_local_chegada]    INT        NULL,
    [cd_usuario]          INT        NULL,
    [dt_usuario]          DATETIME   NULL,
    CONSTRAINT [PK_Veiculo_Programacao] PRIMARY KEY CLUSTERED ([cd_programacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Veiculo_Programacao_Local_Deslocamento] FOREIGN KEY ([cd_local_chegada]) REFERENCES [dbo].[Local_Deslocamento] ([cd_local_deslocamento])
);

