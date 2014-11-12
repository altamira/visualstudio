CREATE TABLE [dbo].[Consulta_Item_Orcamento_Furo_Adicional] (
    [cd_consulta]              INT          NOT NULL,
    [cd_item_consulta]         INT          NOT NULL,
    [cd_item_orcamento]        INT          NOT NULL,
    [cd_item_furo_adic_orcam]  INT          NOT NULL,
    [cd_tipo_furo]             INT          NULL,
    [qt_furo_adic_item_orcam]  INT          NULL,
    [qt_tempo_adic_item_orcam] FLOAT (53)   NULL,
    [nm_obs_adic_item_orcam]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Consulta_Item_Orcamento_Furo_Adicional] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_item_orcamento] ASC, [cd_item_furo_adic_orcam] ASC) WITH (FILLFACTOR = 90)
);

