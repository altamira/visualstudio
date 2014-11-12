CREATE TABLE [dbo].[Fonte_Pesquisa_Salario] (
    [cd_fonte_pesquisa_salario] INT          NOT NULL,
    [nm_fonte_pesquisa_salario] VARCHAR (40) NULL,
    [sg_fonte_pesquisa]         CHAR (10)    NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Fonte_Pesquisa_Salario] PRIMARY KEY CLUSTERED ([cd_fonte_pesquisa_salario] ASC) WITH (FILLFACTOR = 90)
);

