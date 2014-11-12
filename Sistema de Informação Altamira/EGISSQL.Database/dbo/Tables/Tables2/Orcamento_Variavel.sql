CREATE TABLE [dbo].[Orcamento_Variavel] (
    [cd_orcamento_variavel]   INT          NOT NULL,
    [nm_orcamento_variavel]   VARCHAR (60) NULL,
    [cd_tipo_variavel_orcam]  INT          NULL,
    [nm_valor_orcam_variavel] VARCHAR (20) NULL,
    [nm_obs_orcam_variavel]   VARCHAR (40) NULL,
    [cd_unidade_medida]       INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ds_orcamento_variavel]   TEXT         NULL,
    [vl_orcamento_variavel]   FLOAT (53)   NULL,
    CONSTRAINT [PK_Orcamento_Variavel] PRIMARY KEY CLUSTERED ([cd_orcamento_variavel] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Orcamento_Variavel_Tipo_Variavel_Orcamento] FOREIGN KEY ([cd_tipo_variavel_orcam]) REFERENCES [dbo].[Tipo_Variavel_Orcamento] ([cd_tipo_variavel_orcam]),
    CONSTRAINT [FK_Orcamento_Variavel_Unidade_Medida] FOREIGN KEY ([cd_unidade_medida]) REFERENCES [dbo].[Unidade_Medida] ([cd_unidade_medida])
);

