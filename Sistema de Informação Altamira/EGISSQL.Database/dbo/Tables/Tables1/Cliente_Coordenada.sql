CREATE TABLE [dbo].[Cliente_Coordenada] (
    [cd_cliente]        INT          NOT NULL,
    [qt_latitude]       FLOAT (53)   NULL,
    [qt_longitude]      FLOAT (53)   NULL,
    [nm_obs_coordenada] VARCHAR (40) NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Coordenada] PRIMARY KEY CLUSTERED ([cd_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Coordenada_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

