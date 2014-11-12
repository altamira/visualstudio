CREATE TABLE [dbo].[Cliente_Fase] (
    [cd_cliente_fase] INT          NOT NULL,
    [nm_cliente_fase] VARCHAR (30) NULL,
    [sg_cliente_fase] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Fase] PRIMARY KEY CLUSTERED ([cd_cliente_fase] ASC) WITH (FILLFACTOR = 90)
);

