CREATE TABLE [dbo].[Viagem_Destino_Combustivel] (
    [cd_viagem]              INT          NOT NULL,
    [cd_item_viagem_destino] INT          NOT NULL,
    [cd_destino]             INT          NULL,
    [qt_item_destino]        FLOAT (53)   NULL,
    [cd_tipo_combustivel]    INT          NULL,
    [nm_obs_destino]         VARCHAR (60) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Viagem_Destino_Combustivel] PRIMARY KEY CLUSTERED ([cd_viagem] ASC, [cd_item_viagem_destino] ASC)
);

