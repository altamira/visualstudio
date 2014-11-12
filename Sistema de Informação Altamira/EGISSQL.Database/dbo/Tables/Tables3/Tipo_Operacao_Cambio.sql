CREATE TABLE [dbo].[Tipo_Operacao_Cambio] (
    [cd_tipo_operacao_cambio] INT          NOT NULL,
    [nm_tipo_operacao_cambio] VARCHAR (40) NULL,
    [sg_tipo_operacao_cambio] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Operacao_Cambio] PRIMARY KEY CLUSTERED ([cd_tipo_operacao_cambio] ASC) WITH (FILLFACTOR = 90)
);

