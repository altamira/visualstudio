CREATE TABLE [dbo].[Tipo_Salario] (
    [cd_tipo_salario] INT          NOT NULL,
    [nm_tipo_salario] VARCHAR (30) NULL,
    [sg_tipo_salario] CHAR (10)    NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Salario] PRIMARY KEY CLUSTERED ([cd_tipo_salario] ASC) WITH (FILLFACTOR = 90)
);

