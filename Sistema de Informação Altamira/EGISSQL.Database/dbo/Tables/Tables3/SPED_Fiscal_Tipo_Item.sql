CREATE TABLE [dbo].[SPED_Fiscal_Tipo_Item] (
    [cd_tipo_item]   INT          NOT NULL,
    [nm_tipo_item]   VARCHAR (60) NULL,
    [cd_sped_fiscal] VARCHAR (15) NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_SPED_Fiscal_Tipo_Item] PRIMARY KEY CLUSTERED ([cd_tipo_item] ASC) WITH (FILLFACTOR = 90)
);

