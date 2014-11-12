CREATE TABLE [dbo].[Veiculo_Area_Regiao] (
    [cd_veiculo_area_regiao] INT           NOT NULL,
    [nm_veiculo_area_regiao] VARCHAR (100) NULL,
    [cd_veiculo]             INT           NOT NULL,
    [cd_area_entrega]        INT           NOT NULL,
    [cd_tipo_carga]          INT           NULL,
    [cd_vendedor]            INT           NULL,
    [nm_obs_veiculo]         VARCHAR (40)  NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    CONSTRAINT [PK_Veiculo_Area_Regiao] PRIMARY KEY CLUSTERED ([cd_veiculo_area_regiao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Veiculo_Area_Regiao_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

