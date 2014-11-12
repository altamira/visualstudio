CREATE TABLE [dbo].[Consulta_Itens_Desconto] (
    [cd_consulta]               INT        NOT NULL,
    [cd_item_consulta]          INT        NOT NULL,
    [cd_consulta_item_desconto] INT        NOT NULL,
    [pc_desc_ad_item_consulta]  FLOAT (53) NULL,
    [cd_usuario]                INT        NULL,
    [dt_usuario]                DATETIME   NULL,
    CONSTRAINT [PK_Consulta_Itens_Desconto] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_consulta_item_desconto] ASC) WITH (FILLFACTOR = 90)
);

