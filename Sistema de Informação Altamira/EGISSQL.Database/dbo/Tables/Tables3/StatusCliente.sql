CREATE TABLE [dbo].[StatusCliente] (
    [cd_suspensao_fornecedor] INT          NOT NULL,
    [nm_suspensao_fornecedor] VARCHAR (40) NULL,
    CONSTRAINT [PK_StatusCliente] PRIMARY KEY CLUSTERED ([cd_suspensao_fornecedor] ASC) WITH (FILLFACTOR = 90)
);

