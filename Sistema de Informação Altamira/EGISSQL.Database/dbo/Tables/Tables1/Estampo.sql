CREATE TABLE [dbo].[Estampo] (
    [cd_estampo]               INT          NOT NULL,
    [nm_estampo]               VARCHAR (50) NULL,
    [nm_fantasia_estampo]      VARCHAR (15) NULL,
    [cd_identificacao_estampo] VARCHAR (15) NULL,
    [ds_estampo]               TEXT         NULL,
    [cd_tipo_estampo]          INT          NULL,
    [cd_modalidade_estampo]    INT          NULL,
    [qt_cap_maquina_estampo]   FLOAT (53)   NULL,
    [qt_diametro_interno]      FLOAT (53)   NULL,
    [qt_diametro_externo]      FLOAT (53)   NULL,
    [qt_espessura]             FLOAT (53)   NULL,
    [qt_altura]                FLOAT (53)   NULL,
    [nm_obs_estampo]           VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_base_estampo]          VARCHAR (15) NULL,
    [cd_produto]               INT          NULL,
    CONSTRAINT [PK_Estampo] PRIMARY KEY CLUSTERED ([cd_estampo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Estampo_Modalidade] FOREIGN KEY ([cd_modalidade_estampo]) REFERENCES [dbo].[Modalidade] ([cd_modalidade]),
    CONSTRAINT [FK_Estampo_Produto] FOREIGN KEY ([cd_produto]) REFERENCES [dbo].[Produto] ([cd_produto])
);

