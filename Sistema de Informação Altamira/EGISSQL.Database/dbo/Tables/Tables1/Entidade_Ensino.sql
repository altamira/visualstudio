CREATE TABLE [dbo].[Entidade_Ensino] (
    [cd_entidade_ensino] INT          NOT NULL,
    [nm_entidade_ensino] VARCHAR (40) NULL,
    [sg_entidade_ensino] CHAR (10)    NULL,
    [cd_fornecedor]      INT          NULL,
    [cd_usuario]         INT          NULL,
    [dt_usuario]         DATETIME     NULL,
    CONSTRAINT [PK_Entidade_Ensino] PRIMARY KEY CLUSTERED ([cd_entidade_ensino] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Entidade_Ensino_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

