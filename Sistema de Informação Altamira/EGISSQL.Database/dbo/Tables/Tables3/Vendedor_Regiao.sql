CREATE TABLE [dbo].[Vendedor_Regiao] (
    [cd_vendedor]             INT          NOT NULL,
    [cd_regiao_venda]         INT          NOT NULL,
    [cd_item_vendedor_regiao] INT          NOT NULL,
    [nm_obs_vendedor_regiao]  VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [vl_pot_vendedor_regiao]  FLOAT (53)   NULL,
    CONSTRAINT [PK_Vendedor_Regiao] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC, [cd_regiao_venda] ASC, [cd_item_vendedor_regiao] ASC) WITH (FILLFACTOR = 90)
);

