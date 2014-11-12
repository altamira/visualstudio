CREATE TABLE [dbo].[Consulta_Item_Orcamento_Bucha_Coluna] (
    [cd_consulta]               INT          NOT NULL,
    [cd_item_consulta]          INT          NOT NULL,
    [cd_item_orcamento]         INT          NOT NULL,
    [qt_furo_bc_item_orcamento] INT          NULL,
    [qt_diam_bc_item_orcamento] INT          NULL,
    [nm_obs_bc_item_orcamento]  VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_item_furo_bucha_coluna] INT          NULL,
    CONSTRAINT [PK_Consulta_Item_Orcamento_Bucha_Coluna] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_item_orcamento] ASC) WITH (FILLFACTOR = 90)
);

