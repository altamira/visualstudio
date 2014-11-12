CREATE TABLE [dbo].[Consulta_Item_Perda] (
    [cd_consulta]         INT        NOT NULL,
    [cd_item_consulta]    INT        NOT NULL,
    [cd_concorrente]      INT        NULL,
    [dt_perda_consulta]   DATETIME   NULL,
    [vl_perda_consulta]   FLOAT (53) NULL,
    [ds_perda_consulta]   TEXT       NULL,
    [pc_perda_consulta]   FLOAT (53) NULL,
    [cd_usuario]          INT        NOT NULL,
    [dt_usuario]          DATETIME   NOT NULL,
    [cd_motivo_perda]     INT        NULL,
    [dt_lancamento_perda] DATETIME   NULL,
    [vl_produto]          FLOAT (53) NULL,
    CONSTRAINT [PK_Consulta_Item_Perda] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_item_consulta] ASC) WITH (FILLFACTOR = 90)
);

