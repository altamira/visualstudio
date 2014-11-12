CREATE TABLE [dbo].[Nivel_Cliente] (
    [cd_nivel_cliente] INT          NOT NULL,
    [nm_nivel_cliente] VARCHAR (40) NULL,
    [sg_nivel_cliente] CHAR (10)    NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    CONSTRAINT [PK_Nivel_Cliente] PRIMARY KEY CLUSTERED ([cd_nivel_cliente] ASC) WITH (FILLFACTOR = 90)
);

