CREATE TABLE [dbo].[Equipamento_Historico] (
    [cd_equipamento]           INT      NOT NULL,
    [dt_historico_equipamento] DATETIME NOT NULL,
    [cd_causa_manutencao]      INT      NOT NULL,
    [cd_impedimento]           INT      NOT NULL,
    [cd_os_manutencao]         INT      NOT NULL,
    [ds_historico_equipamento] TEXT     NOT NULL,
    [cd_usuario]               INT      NOT NULL,
    [dt_usuario]               DATETIME NOT NULL,
    CONSTRAINT [PK_Equipamento_Historico] PRIMARY KEY CLUSTERED ([cd_equipamento] ASC, [dt_historico_equipamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Equipamento_Historico_Causa_Manutencao] FOREIGN KEY ([cd_causa_manutencao]) REFERENCES [dbo].[Causa_Manutencao] ([cd_causa_manutencao])
);

