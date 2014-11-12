CREATE TABLE [dbo].[Modulo_Cliente] (
    [cd_modulo]             INT          NOT NULL,
    [cd_modulo_cliente]     INT          NOT NULL,
    [cd_cliente]            INT          NULL,
    [cd_cliente_sistema]    INT          NULL,
    [ic_habilitado_modulo]  CHAR (1)     NULL,
    [dt_modulo_cliente]     DATETIME     NULL,
    [nm_obs_modulo_cliente] VARCHAR (40) NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_usuario]            INT          NULL,
    CONSTRAINT [PK_Modulo_Cliente] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_modulo_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Modulo_Cliente_Cliente_Sistema] FOREIGN KEY ([cd_cliente_sistema]) REFERENCES [dbo].[Cliente_Sistema] ([cd_cliente_sistema])
);

