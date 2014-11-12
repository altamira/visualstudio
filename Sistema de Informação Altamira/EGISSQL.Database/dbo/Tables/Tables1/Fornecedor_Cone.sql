CREATE TABLE [dbo].[Fornecedor_Cone] (
    [cd_fornecedor]          INT          NOT NULL,
    [cd_cone]                INT          NOT NULL,
    [cd_item_montagem_cone]  INT          NOT NULL,
    [nm_ref_fornecedor_cone] VARCHAR (40) NULL,
    [ds_fornecedor_cone]     VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL
);

