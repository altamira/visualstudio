CREATE TABLE [dbo].[Consulta_Item_Texto] (
    [cd_consulta]            INT      NOT NULL,
    [cd_item_consulta]       INT      NOT NULL,
    [cd_componente_proposta] INT      NOT NULL,
    [ds_texto_item_consulta] TEXT     NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    [cd_idioma]              INT      NULL,
    CONSTRAINT [PK_Consulta_Item_Texto] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_componente_proposta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Consulta_Item_Texto_Componente_Proposta] FOREIGN KEY ([cd_componente_proposta]) REFERENCES [dbo].[Componente_Proposta] ([cd_componente_proposta])
);

