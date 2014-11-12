CREATE TABLE [dbo].[Consulta_Itens_Grade] (
    [cd_consulta]              INT        NOT NULL,
    [cd_item_consulta]         INT        NOT NULL,
    [cd_cor]                   INT        NOT NULL,
    [cd_ambiente]              INT        NOT NULL,
    [qt_largura_item_consulta] FLOAT (53) NULL,
    [qt_altura_item_consulta]  FLOAT (53) NULL,
    [cd_produto_grade]         INT        NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    [pc_acresc_cor]            FLOAT (53) NULL,
    CONSTRAINT [PK_Consulta_Itens_Grade] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_cor] ASC, [cd_ambiente] ASC) WITH (FILLFACTOR = 90)
);

