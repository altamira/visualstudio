CREATE TABLE [dbo].[Tipo_Fornecimento] (
    [cd_tipo_fornecimento] INT          NOT NULL,
    [nm_tipo_fornecimento] VARCHAR (40) NULL,
    [sg_tipo_fornecimento] CHAR (10)    NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Fornecimento] PRIMARY KEY CLUSTERED ([cd_tipo_fornecimento] ASC) WITH (FILLFACTOR = 90)
);

