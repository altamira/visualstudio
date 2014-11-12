CREATE TABLE [dbo].[Tipo_Especificacao_Produto] (
    [cd_tipo_especificacao] INT          NOT NULL,
    [nm_tipo_especificacao] VARCHAR (40) NULL,
    [sg_tipo_especificacao] CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Especificacao_Produto] PRIMARY KEY CLUSTERED ([cd_tipo_especificacao] ASC) WITH (FILLFACTOR = 90)
);

