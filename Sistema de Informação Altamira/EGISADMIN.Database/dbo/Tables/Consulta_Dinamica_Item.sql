CREATE TABLE [dbo].[Consulta_Dinamica_Item] (
    [cd_consulta_dinamica] INT           NOT NULL,
    [cd_tabela]            INT           NOT NULL,
    [cd_atributo]          INT           NOT NULL,
    [cd_ordem_atributo]    INT           NULL,
    [ic_order_by]          CHAR (1)      NULL,
    [ic_desc_order_by]     CHAR (1)      NULL,
    [nm_filtro_atributo]   VARCHAR (200) NULL,
    [cd_usuario]           INT           NULL,
    [dt_usuario]           DATETIME      NULL,
    [nm_atributo]          VARCHAR (50)  NULL,
    CONSTRAINT [PK_Consulta_Dinamica_Item] PRIMARY KEY CLUSTERED ([cd_consulta_dinamica] ASC, [cd_tabela] ASC, [cd_atributo] ASC) WITH (FILLFACTOR = 90)
);

