CREATE TABLE [dbo].[Tipo_Pesquisa_Salario] (
    [cd_tipo_pesquisa_salario] INT          NOT NULL,
    [nm_tipo_pesquisa_salario] VARCHAR (40) NULL,
    [sg_tipo_pesquisa_salario] CHAR (10)    NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Pesquisa_Salario] PRIMARY KEY CLUSTERED ([cd_tipo_pesquisa_salario] ASC) WITH (FILLFACTOR = 90)
);

