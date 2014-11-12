CREATE TABLE [dbo].[Cliente_Conceito] (
    [cd_conceito_cliente] INT          NOT NULL,
    [nm_conceito_cliente] VARCHAR (30) NOT NULL,
    [sg_conceito_cliente] CHAR (10)    NOT NULL,
    [cd_usuario]          INT          NOT NULL,
    [dt_usuario]          DATETIME     NOT NULL,
    CONSTRAINT [PK_Cliente_Conceito] PRIMARY KEY CLUSTERED ([cd_conceito_cliente] ASC) WITH (FILLFACTOR = 90)
);

