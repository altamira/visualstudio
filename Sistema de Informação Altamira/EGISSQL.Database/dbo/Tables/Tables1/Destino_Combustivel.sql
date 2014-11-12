CREATE TABLE [dbo].[Destino_Combustivel] (
    [cd_destino] INT          NOT NULL,
    [nm_destino] VARCHAR (40) NULL,
    [ds_destino] TEXT         NULL,
    [cd_usuario] INT          NULL,
    [dt_usuario] DATETIME     NULL,
    CONSTRAINT [PK_Destino_Combustivel] PRIMARY KEY CLUSTERED ([cd_destino] ASC)
);

