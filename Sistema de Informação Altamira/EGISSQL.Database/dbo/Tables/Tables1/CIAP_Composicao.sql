CREATE TABLE [dbo].[CIAP_Composicao] (
    [cd_ciap]              INT          NOT NULL,
    [cd_item_ciap]         INT          NOT NULL,
    [nm_bem_ciap]          VARCHAR (60) NULL,
    [ds_bemn_ciap]         TEXT         NULL,
    [pc_icms_ciap]         FLOAT (53)   NULL,
    [vl_base_icms_ciap]    FLOAT (53)   NULL,
    [vl_icms_ciap]         FLOAT (53)   NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_item_nota_entrada] INT          NULL,
    [ds_bem_ciap]          TEXT         NULL,
    [cd_bem]               INT          NULL,
    [nm_obs_item_ciap]     VARCHAR (40) NULL,
    CONSTRAINT [PK_CIAP_Composicao] PRIMARY KEY CLUSTERED ([cd_ciap] ASC, [cd_item_ciap] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_CIAP_Composicao_Ciap] FOREIGN KEY ([cd_ciap]) REFERENCES [dbo].[Ciap] ([cd_ciap])
);

