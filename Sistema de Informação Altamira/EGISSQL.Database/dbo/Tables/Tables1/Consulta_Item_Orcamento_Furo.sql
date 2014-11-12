CREATE TABLE [dbo].[Consulta_Item_Orcamento_Furo] (
    [cd_consulta]             INT          NOT NULL,
    [cd_item_consulta]        INT          NOT NULL,
    [cd_item_orcamento]       INT          NOT NULL,
    [cd_item_furo_orcamento]  INT          NOT NULL,
    [cd_tipo_furo]            INT          NULL,
    [qt_furo_item_orcamento]  INT          NULL,
    [qt_tempo_item_orcamento] FLOAT (53)   NULL,
    [nm_obs_furo_item_orcam]  VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Consulta_Item_Orcamento_Furo] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC, [cd_item_orcamento] ASC, [cd_item_furo_orcamento] ASC) WITH (FILLFACTOR = 90)
);

