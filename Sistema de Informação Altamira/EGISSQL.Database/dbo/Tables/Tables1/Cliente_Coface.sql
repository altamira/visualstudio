CREATE TABLE [dbo].[Cliente_Coface] (
    [cd_cliente]            INT          NOT NULL,
    [cd_cliente_coface]     INT          NOT NULL,
    [cd_ref_cliente_coface] VARCHAR (15) NULL,
    [nm_obs_cliente_coface] VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Coface] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_cliente_coface] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Coface_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

