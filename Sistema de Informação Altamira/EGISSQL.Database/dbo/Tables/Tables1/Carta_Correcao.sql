CREATE TABLE [dbo].[Carta_Correcao] (
    [cd_carta_correcao]       INT           NOT NULL,
    [dt_carta_correcao]       DATETIME      NULL,
    [ic_lista_carta_correcao] CHAR (1)      NULL,
    [nm_obs_carta_correcao]   VARCHAR (120) NULL,
    [cd_nota_saida]           INT           NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [cd_nota_entrada]         INT           NULL,
    [cd_serie_nota_fiscal]    INT           NULL,
    [cd_fornecedor]           INT           NULL,
    [cd_tipo_destinatario]    INT           NULL,
    [ic_usuario_carta]        CHAR (1)      NULL,
    [cd_usuario_carta]        INT           NULL,
    CONSTRAINT [PK_Carta_Correcao] PRIMARY KEY CLUSTERED ([cd_carta_correcao] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [ix_cd_nota_saida]
    ON [dbo].[Carta_Correcao]([cd_nota_saida] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [ix_cd_nota_entrada]
    ON [dbo].[Carta_Correcao]([cd_nota_entrada] ASC, [cd_serie_nota_fiscal] ASC, [cd_fornecedor] ASC) WITH (FILLFACTOR = 90);

