CREATE TABLE [dbo].[Componente_Avaliacao_Texto] (
    [cd_componente_avaliacao]   INT           NOT NULL,
    [cd_item_texto_avaliacao]   INT           NOT NULL,
    [nm_texto_avaliacao]        VARCHAR (255) NULL,
    [ds_texto_avaliacao]        TEXT          NULL,
    [ic_ativo_texto]            CHAR (1)      NULL,
    [ic_negrito_texto]          CHAR (1)      NULL,
    [ic_sublinhado_texto]       CHAR (1)      NULL,
    [cd_ordem_texto]            INT           NULL,
    [ic_padrao_texto]           CHAR (1)      NULL,
    [ic_tipo_texto]             CHAR (1)      NULL,
    [ic_manutencao_texto]       CHAR (1)      NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [ic_mostra_item_componente] CHAR (1)      NULL,
    [nm_complemento_texto]      VARCHAR (60)  NULL,
    CONSTRAINT [PK_Componente_Avaliacao_Texto] PRIMARY KEY CLUSTERED ([cd_componente_avaliacao] ASC, [cd_item_texto_avaliacao] ASC) WITH (FILLFACTOR = 90)
);

