CREATE TABLE [dbo].[Produto_Origem] (
    [cd_produto]            INT          NOT NULL,
    [cd_origem_produto]     INT          NOT NULL,
    [nm_obs_produto_origem] VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_pais]               INT          NULL,
    [cd_moeda]              INT          NULL,
    [vl_fob_produto_origem] FLOAT (53)   NULL,
    [cd_regime_tributacao]  INT          NULL,
    [cd_norma_origem]       INT          NULL,
    [cd_pais_procedencia]   INT          NULL,
    CONSTRAINT [PK_Produto_Origem] PRIMARY KEY CLUSTERED ([cd_produto] ASC, [cd_origem_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Produto_Origem_Pais] FOREIGN KEY ([cd_pais_procedencia]) REFERENCES [dbo].[Pais] ([cd_pais])
);

