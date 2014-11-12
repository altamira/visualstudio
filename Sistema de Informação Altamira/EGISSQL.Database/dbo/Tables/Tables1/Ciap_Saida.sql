CREATE TABLE [dbo].[Ciap_Saida] (
    [cd_ciap]              INT          NOT NULL,
    [cd_nota_saida]        INT          NULL,
    [dt_nota_saida]        DATETIME     NULL,
    [cd_serie_nota_fiscal] INT          NULL,
    [cd_cliente]           INT          NULL,
    [cd_livro_saida]       INT          NULL,
    [qt_folha_livro_saida] FLOAT (53)   NULL,
    [nm_obs_ciap_saida]    VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Ciap_Saida] PRIMARY KEY CLUSTERED ([cd_ciap] ASC) WITH (FILLFACTOR = 90)
);

