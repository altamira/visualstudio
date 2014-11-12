CREATE TABLE [dbo].[Consulta_Itens_Acessorio] (
    [cd_consulta]              INT        NOT NULL,
    [cd_item_consulta]         INT        NOT NULL,
    [cd_it_acessorio_consulta] INT        NOT NULL,
    [cd_acessorio]             INT        NULL,
    [qt_it_acessorio_consulta] FLOAT (53) NULL,
    [vl_it_acessorio_consulta] FLOAT (53) NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    CONSTRAINT [PK_Consulta_Itens_Acessorio] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_it_acessorio_consulta] ASC) WITH (FILLFACTOR = 90)
);

