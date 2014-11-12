CREATE TABLE [dbo].[Fornecedor_Fase] (
    [cd_fornecedor_fase] INT          NOT NULL,
    [nm_fornecedor_fase] VARCHAR (40) NULL,
    [sg_fornecedor_fase] CHAR (10)    NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Fornecedor_Fase] PRIMARY KEY CLUSTERED ([cd_fornecedor_fase] ASC) WITH (FILLFACTOR = 90)
);

