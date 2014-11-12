CREATE TABLE [dbo].[Tipo_Informacao_Cadastro] (
    [cd_tipo_info_cadastro] INT          NOT NULL,
    [nm_tipo_info_cadastro] VARCHAR (40) NULL,
    [sg_tipo_info_cadastro] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Informacao_Cadastro] PRIMARY KEY CLUSTERED ([cd_tipo_info_cadastro] ASC) WITH (FILLFACTOR = 90)
);

