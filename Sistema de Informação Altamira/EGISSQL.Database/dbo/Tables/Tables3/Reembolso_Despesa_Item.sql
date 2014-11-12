CREATE TABLE [dbo].[Reembolso_Despesa_Item] (
    [cd_reembolso_despesa]      INT          NOT NULL,
    [cd_reembolso_despesa_item] INT          NOT NULL,
    [cd_tipo_despesa]           INT          NULL,
    [vl_reembolso_despesa_item] FLOAT (53)   NULL,
    [nm_obs_item_despesa]       VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Reembolso_Despesa_Item] PRIMARY KEY CLUSTERED ([cd_reembolso_despesa] ASC, [cd_reembolso_despesa_item] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Reembolso_Despesa_Item_Tipo_Despesa] FOREIGN KEY ([cd_tipo_despesa]) REFERENCES [dbo].[Tipo_Despesa] ([cd_tipo_despesa])
);

