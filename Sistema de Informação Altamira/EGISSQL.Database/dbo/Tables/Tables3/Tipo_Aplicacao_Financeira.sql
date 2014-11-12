CREATE TABLE [dbo].[Tipo_Aplicacao_Financeira] (
    [cd_tipo_aplicacao_finan] INT          NOT NULL,
    [nm_tipo_aplicacao_finan] VARCHAR (40) NULL,
    [sg_tipo_aplicacao_finan] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Aplicacao_Financeira] PRIMARY KEY CLUSTERED ([cd_tipo_aplicacao_finan] ASC) WITH (FILLFACTOR = 90)
);

