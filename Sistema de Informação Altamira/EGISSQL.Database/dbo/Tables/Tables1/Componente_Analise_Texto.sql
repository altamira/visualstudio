CREATE TABLE [dbo].[Componente_Analise_Texto] (
    [cd_componente_analise] INT           NOT NULL,
    [cd_item_texto_analise] INT           NOT NULL,
    [nm_texto_analise]      VARCHAR (255) NULL,
    [ds_texto_analise]      TEXT          NULL,
    [ic_ativo_texto]        CHAR (1)      NULL,
    [ic_negrito_texto]      CHAR (1)      NULL,
    [ic_sublinhado_texto]   CHAR (1)      NULL,
    [cd_ordem_texto]        INT           NULL,
    [ic_padrao_texto]       CHAR (1)      NULL,
    [ic_tipo_texto]         CHAR (1)      NULL,
    [ic_manutencao_texto]   CHAR (1)      NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    [nm_complemento_texto]  VARCHAR (60)  NULL,
    CONSTRAINT [PK_Componente_Analise_Texto] PRIMARY KEY CLUSTERED ([cd_componente_analise] ASC, [cd_item_texto_analise] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Componente_Analise_Texto_Componente_Analise] FOREIGN KEY ([cd_componente_analise]) REFERENCES [dbo].[Componente_Analise] ([cd_componente_analise])
);

