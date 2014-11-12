CREATE TABLE [dbo].[Analise_Preco_Fob] (
    [cd_produto]       INT        NOT NULL,
    [cd_pais]          INT        NULL,
    [cd_moeda]         INT        NULL,
    [vl_analise_preco] FLOAT (53) NULL,
    [cd_usuario]       INT        NULL,
    [dt_usuario]       DATETIME   NULL,
    CONSTRAINT [PK_Analise_Preco_Fob] PRIMARY KEY CLUSTERED ([cd_produto] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Analise_Preco_Fob_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

