CREATE TABLE [dbo].[Tipo_Teste_Formula] (
    [cd_tipo_teste_formula] INT          NOT NULL,
    [nm_tipo_teste_formula] VARCHAR (40) NULL,
    [sg_tipo_teste_formula] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Teste_Formula] PRIMARY KEY CLUSTERED ([cd_tipo_teste_formula] ASC) WITH (FILLFACTOR = 90)
);

