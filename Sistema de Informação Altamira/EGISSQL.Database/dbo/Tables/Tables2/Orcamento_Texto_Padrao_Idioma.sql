CREATE TABLE [dbo].[Orcamento_Texto_Padrao_Idioma] (
    [cd_orcamento_texto_padrao] INT          NOT NULL,
    [cd_idioma]                 INT          NOT NULL,
    [ds_obs_texto_padrao]       TEXT         NULL,
    [nm_texto_proposta]         VARCHAR (60) NULL,
    CONSTRAINT [PK_Orcamento_Texto_Padrao_Idioma] PRIMARY KEY CLUSTERED ([cd_orcamento_texto_padrao] ASC, [cd_idioma] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Orcamento_Texto_Padrao_Idioma_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

