CREATE TABLE [dbo].[Cargo_Cliente] (
    [cd_cargo_cliente] INT          NOT NULL,
    [nm_cargo_cliente] VARCHAR (30) NOT NULL,
    [sg_cargo_cliente] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Cargo_Cliente] PRIMARY KEY CLUSTERED ([cd_cargo_cliente] ASC) WITH (FILLFACTOR = 90)
);

