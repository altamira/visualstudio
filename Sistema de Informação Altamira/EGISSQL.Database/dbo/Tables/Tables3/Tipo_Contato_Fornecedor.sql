CREATE TABLE [dbo].[Tipo_Contato_Fornecedor] (
    [cd_tipo_contato] INT          NOT NULL,
    [nm_tipo_contato] VARCHAR (30) NOT NULL,
    [sg_tipo_contato] CHAR (10)    NOT NULL,
    [cd_usuario]      INT          NOT NULL,
    [dt_usuario]      DATETIME     NOT NULL,
    CONSTRAINT [PK_Tipo_Contato_Fornecedor] PRIMARY KEY CLUSTERED ([cd_tipo_contato] ASC) WITH (FILLFACTOR = 90)
);

