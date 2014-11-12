CREATE TABLE [dbo].[Item_Gerencial] (
    [cd_grupo_gerencial]        INT          NOT NULL,
    [cd_item_gerencial]         INT          NOT NULL,
    [nm_item_gerencial]         VARCHAR (50) NULL,
    [nu_ordem]                  INT          NULL,
    [cd_ordem_item_gerencial]   INT          NULL,
    [cd_procedimento]           INT          NULL,
    [nm_obs_item_gerencial]     VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_mascara_item_gerencial] INT          NULL,
    CONSTRAINT [PK_Item_Gerencial] PRIMARY KEY CLUSTERED ([cd_grupo_gerencial] ASC, [cd_item_gerencial] ASC) WITH (FILLFACTOR = 90)
);

