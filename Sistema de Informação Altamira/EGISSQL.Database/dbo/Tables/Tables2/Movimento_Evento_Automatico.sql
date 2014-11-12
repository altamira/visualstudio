CREATE TABLE [dbo].[Movimento_Evento_Automatico] (
    [cd_movimento_evento]       INT          NOT NULL,
    [dt_movimento_evento]       DATETIME     NULL,
    [cd_tipo_movimento_evento]  INT          NULL,
    [cd_funcionario]            INT          NULL,
    [cd_evento]                 INT          NULL,
    [qt_parcela_evento]         INT          NULL,
    [vl_movimento_evento]       FLOAT (53)   NULL,
    [qt_saldo_parcela_evento]   INT          NULL,
    [dt_inicio_evento]          DATETIME     NULL,
    [dt_final_evento]           DATETIME     NULL,
    [vl_total_movimento_evento] FLOAT (53)   NULL,
    [nm_obs_movimento_evento]   VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_historico_folha]        INT          NULL,
    CONSTRAINT [PK_Movimento_Evento_Automatico] PRIMARY KEY CLUSTERED ([cd_movimento_evento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Movimento_Evento_Automatico_Evento_Folha] FOREIGN KEY ([cd_evento]) REFERENCES [dbo].[Evento_Folha] ([cd_evento]),
    CONSTRAINT [FK_Movimento_Evento_Automatico_Historico_Folha] FOREIGN KEY ([cd_historico_folha]) REFERENCES [dbo].[Historico_Folha] ([cd_historico_folha])
);

