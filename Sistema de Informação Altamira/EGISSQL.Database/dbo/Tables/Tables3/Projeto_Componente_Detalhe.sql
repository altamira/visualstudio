CREATE TABLE [dbo].[Projeto_Componente_Detalhe] (
    [cd_projeto_componente]      INT           NOT NULL,
    [cd_item_projeto_componente] INT           NOT NULL,
    [nm_texto_projeto]           VARCHAR (150) NULL,
    [nm_complemento_projeto]     VARCHAR (60)  NULL,
    [ds_texto_projeto]           TEXT          NULL,
    [ic_ativo_projeto]           CHAR (1)      NULL,
    [ic_negrito_projeto]         CHAR (1)      NULL,
    [ic_sublinhado_projeto]      CHAR (1)      NULL,
    [ic_padrao_texto]            CHAR (1)      NULL,
    [ic_tipo_texto]              CHAR (1)      NULL,
    [ic_manutencao_projeto]      CHAR (1)      NULL,
    [cd_usuario]                 INT           NULL,
    [dt_usuario]                 DATETIME      NULL,
    CONSTRAINT [PK_Projeto_Componente_Detalhe] PRIMARY KEY CLUSTERED ([cd_projeto_componente] ASC, [cd_item_projeto_componente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Projeto_Componente_Detalhe_Projeto_Componente] FOREIGN KEY ([cd_projeto_componente]) REFERENCES [dbo].[Projeto_Componente] ([cd_projeto_componente])
);

