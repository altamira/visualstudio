CREATE TABLE [dbo].[Tipo_Funcao_Grafico] (
    [cd_tipo_funcao_grafico] INT          NOT NULL,
    [nm_tipo_funcao_grafico] VARCHAR (30) NOT NULL,
    [sg_tipo_funcao]         CHAR (10)    NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Funcao_Grafico] PRIMARY KEY CLUSTERED ([cd_tipo_funcao_grafico] ASC) WITH (FILLFACTOR = 90)
);

