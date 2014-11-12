CREATE TABLE [dbo].[Viagem_Combustivel_Composicao] (
    [cd_viagem]            INT          NOT NULL,
    [cd_item_viagem]       INT          NOT NULL,
    [cd_tipo_combustivel]  INT          NULL,
    [qt_item_viagem]       FLOAT (53)   NULL,
    [vl_item_viagem]       FLOAT (53)   NULL,
    [vl_item_total_viagem] FLOAT (53)   NULL,
    [nm_obs_item_viagem]   VARCHAR (60) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [cd_destino]           INT          NULL,
    CONSTRAINT [PK_Viagem_Combustivel_Composicao] PRIMARY KEY CLUSTERED ([cd_viagem] ASC, [cd_item_viagem] ASC),
    CONSTRAINT [FK_Viagem_Combustivel_Composicao_Tipo_Combustivel] FOREIGN KEY ([cd_tipo_combustivel]) REFERENCES [dbo].[Tipo_Combustivel] ([cd_tipo_combustivel])
);

