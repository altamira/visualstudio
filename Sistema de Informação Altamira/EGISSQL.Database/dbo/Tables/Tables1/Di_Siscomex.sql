CREATE TABLE [dbo].[Di_Siscomex] (
    [cd_di]                INT      NOT NULL,
    [cd_tipo_tarifacao]    INT      NOT NULL,
    [cd_fundamento_legal]  INT      NOT NULL,
    [cd_receita_despacho]  INT      NOT NULL,
    [cd_receita_entrega]   INT      NOT NULL,
    [cd_agencia_secex]     INT      NOT NULL,
    [cd_acordo_aladi]      INT      NOT NULL,
    [cd_regime_tributacao] INT      NOT NULL,
    [cd_usuario]           INT      NOT NULL,
    [dt_usuario]           DATETIME NOT NULL,
    CONSTRAINT [PK_Di_Siscomex] PRIMARY KEY CLUSTERED ([cd_di] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Di_Siscomex_Acordo_Aladi] FOREIGN KEY ([cd_acordo_aladi]) REFERENCES [dbo].[Acordo_Aladi] ([cd_acordo_aladi]),
    CONSTRAINT [FK_Di_Siscomex_Agencia_Secex] FOREIGN KEY ([cd_agencia_secex]) REFERENCES [dbo].[Agencia_Secex] ([cd_agencia_secex]),
    CONSTRAINT [FK_Di_Siscomex_Fundamento_Legal] FOREIGN KEY ([cd_fundamento_legal]) REFERENCES [dbo].[Fundamento_Legal] ([cd_fundamento_legal]),
    CONSTRAINT [FK_Di_Siscomex_Regime_Tributacao] FOREIGN KEY ([cd_regime_tributacao]) REFERENCES [dbo].[Regime_Tributacao] ([cd_regime_tributacao]),
    CONSTRAINT [FK_Di_Siscomex_tipo_tarifacao] FOREIGN KEY ([cd_tipo_tarifacao]) REFERENCES [dbo].[tipo_tarifacao] ([cd_tipo_tarifacao])
);

