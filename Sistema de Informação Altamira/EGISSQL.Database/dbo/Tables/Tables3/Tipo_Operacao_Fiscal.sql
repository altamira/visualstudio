CREATE TABLE [dbo].[Tipo_Operacao_Fiscal] (
    [cd_tipo_operacao_fiscal] INT          NOT NULL,
    [nm_tipo_operacao_fiscal] VARCHAR (30) NOT NULL,
    [sg_tipo_operacao_fiscal] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Operacao_Fiscal] PRIMARY KEY CLUSTERED ([cd_tipo_operacao_fiscal] ASC) WITH (FILLFACTOR = 90)
);

