CREATE TABLE [dbo].[Suspensao_Fornecedor] (
    [cd_suspensao_fornecedor] INT          NOT NULL,
    [nm_suspensao_fornecedor] VARCHAR (40) NULL,
    [sg_suspensao_fornecedor] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Suspensao_Fornecedor] PRIMARY KEY CLUSTERED ([cd_suspensao_fornecedor] ASC) WITH (FILLFACTOR = 90)
);

