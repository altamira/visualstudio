CREATE TABLE [dbo].[Componente_Proposta_Texto] (
    [cd_componente_proposta]  INT          NOT NULL,
    [cd_item_texto_proposta]  INT          NOT NULL,
    [nm_texto_proposta]       VARCHAR (40) NULL,
    [ds_texto_proposta]       TEXT         NULL,
    [ic_ativo_texto_proposta] CHAR (1)     NULL,
    [ic_manut_texto_proposta] CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_negrito_texto]        CHAR (1)     NULL,
    [ic_sublinhado_texto]     CHAR (1)     NULL,
    [cd_ordem_texto]          INT          NULL,
    [ic_padrao_texto]         CHAR (1)     NULL,
    [cd_idioma]               INT          NULL,
    CONSTRAINT [PK_Componente_Proposta_Texto] PRIMARY KEY CLUSTERED ([cd_componente_proposta] ASC, [cd_item_texto_proposta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Componente_Proposta_Texto_Componente_Proposta] FOREIGN KEY ([cd_componente_proposta]) REFERENCES [dbo].[Componente_Proposta] ([cd_componente_proposta]),
    CONSTRAINT [FK_Componente_Proposta_Texto_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

