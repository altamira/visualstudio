CREATE TABLE [dbo].[Check_List_Componente_Texto] (
    [cd_componente]             INT           NOT NULL,
    [cd_item_componente]        INT           NOT NULL,
    [nm_texto_componente]       VARCHAR (255) NULL,
    [ds_texto_componente]       TEXT          NULL,
    [ic_ativo_texto]            CHAR (1)      NULL,
    [cd_ordem_item_componente]  INT           NULL,
    [ic_negrito_texto]          CHAR (1)      NULL,
    [ic_sublinhado_texto]       CHAR (1)      NULL,
    [ic_mostra_item_componente] CHAR (1)      NULL,
    [cd_idioma]                 INT           NULL,
    [ic_tipo_texto]             CHAR (1)      NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    CONSTRAINT [PK_Check_List_Componente_Texto] PRIMARY KEY CLUSTERED ([cd_componente] ASC, [cd_item_componente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Check_List_Componente_Texto_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

