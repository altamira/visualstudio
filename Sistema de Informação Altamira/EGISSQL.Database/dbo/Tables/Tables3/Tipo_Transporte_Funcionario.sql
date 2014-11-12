CREATE TABLE [dbo].[Tipo_Transporte_Funcionario] (
    [cd_tipo_transporte_func] INT          NOT NULL,
    [nm_tipo_transporte_func] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [sg_tipo_transporte_func] CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NULL,
    [cd_usuario]              INT          NOT NULL,
    [dt_usuario]              DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Transporte_Funcionario] PRIMARY KEY CLUSTERED ([cd_tipo_transporte_func] ASC) WITH (FILLFACTOR = 90)
);

