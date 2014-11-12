CREATE TABLE [dbo].[Tipo_Operacao_Contabil] (
    [cd_tipo_operacao_contabil] INT          NOT NULL,
    [nm_tipo_operacao_contabil] VARCHAR (30) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [sg_tipo_opeacao_contabil]  CHAR (10)    COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Operacao_Contabil] PRIMARY KEY CLUSTERED ([cd_tipo_operacao_contabil] ASC) WITH (FILLFACTOR = 90)
);

