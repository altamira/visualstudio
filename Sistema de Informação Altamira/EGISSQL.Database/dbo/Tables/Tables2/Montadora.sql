CREATE TABLE [dbo].[Montadora] (
    [cd_montadora]          INT          NOT NULL,
    [nm_montadora]          VARCHAR (60) NULL,
    [sg_montadora]          CHAR (10)    NULL,
    [nm_fantasia_montadora] VARCHAR (15) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_fornecedor]         INT          NULL,
    [ds_montadora]          TEXT         NULL,
    [pc_comissao_montadora] FLOAT (53)   NULL,
    CONSTRAINT [PK_Montadora] PRIMARY KEY CLUSTERED ([cd_montadora] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Montadora_Fornecedor] FOREIGN KEY ([cd_fornecedor]) REFERENCES [dbo].[Fornecedor] ([cd_fornecedor])
);

