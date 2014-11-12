CREATE TABLE [dbo].[Remessa] (
    [cd_remessa]               INT          NOT NULL,
    [dt_remessa]               DATETIME     NULL,
    [cd_identificacao_remessa] VARCHAR (15) NULL,
    [cd_cliente]               INT          NULL,
    [nm_obs_remessa]           VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Remessa] PRIMARY KEY CLUSTERED ([cd_remessa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Remessa_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

