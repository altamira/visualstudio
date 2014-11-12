CREATE TABLE [dbo].[Motorista_Advertencia] (
    [cd_motorista_advertencia]     INT          NOT NULL,
    [dt_motorista_advertencia]     DATETIME     NULL,
    [cd_motorista]                 INT          NULL,
    [cd_advertencia]               INT          NULL,
    [ds_motorista_advertencia]     TEXT         NULL,
    [nm_obs_motorista_advertencia] VARCHAR (40) NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    CONSTRAINT [PK_Motorista_Advertencia] PRIMARY KEY CLUSTERED ([cd_motorista_advertencia] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Motorista_Advertencia_Advertencia] FOREIGN KEY ([cd_advertencia]) REFERENCES [dbo].[Advertencia] ([cd_advertencia])
);

