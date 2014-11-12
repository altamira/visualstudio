CREATE TABLE [dbo].[Departamento_Cliente] (
    [cd_departamento_cliente] INT          NOT NULL,
    [nm_departamento_cliente] VARCHAR (30) NOT NULL,
    [sg_departamento_cliente] CHAR (10)    NOT NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    CONSTRAINT [PK_Departamento_Cliente] PRIMARY KEY CLUSTERED ([cd_departamento_cliente] ASC) WITH (FILLFACTOR = 90)
);

