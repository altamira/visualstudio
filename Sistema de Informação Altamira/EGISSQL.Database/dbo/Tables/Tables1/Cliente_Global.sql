CREATE TABLE [dbo].[Cliente_Global] (
    [cd_cliente_global] INT          NOT NULL,
    [nm_cliente_global] VARCHAR (40) NULL,
    [sg_cliente_global] CHAR (10)    NULL,
    [cd_cliente]        INT          NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Global] PRIMARY KEY CLUSTERED ([cd_cliente_global] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Global_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

