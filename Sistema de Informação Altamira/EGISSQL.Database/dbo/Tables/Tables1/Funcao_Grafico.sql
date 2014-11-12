CREATE TABLE [dbo].[Funcao_Grafico] (
    [cd_funcao_grafico] INT          NOT NULL,
    [nm_funcao_grafico] VARCHAR (30) NULL,
    [sg_funcao_grafico] CHAR (10)    NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    CONSTRAINT [PK_Funcao_Grafico] PRIMARY KEY CLUSTERED ([cd_funcao_grafico] ASC) WITH (FILLFACTOR = 90)
);

