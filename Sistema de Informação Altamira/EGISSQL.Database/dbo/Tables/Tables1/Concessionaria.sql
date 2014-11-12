CREATE TABLE [dbo].[Concessionaria] (
    [cd_concessionaria] INT          NOT NULL,
    [nm_concessionaria] VARCHAR (50) NULL,
    [cd_montadora]      INT          NULL,
    [cd_usuario]        INT          NULL,
    [dt_usuario]        DATETIME     NULL,
    [cd_regiao_venda]   INT          NULL,
    CONSTRAINT [PK_Concessionaria] PRIMARY KEY CLUSTERED ([cd_concessionaria] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Concessionaria_Montadora] FOREIGN KEY ([cd_montadora]) REFERENCES [dbo].[Montadora] ([cd_montadora]),
    CONSTRAINT [FK_Concessionaria_Regiao_Venda] FOREIGN KEY ([cd_regiao_venda]) REFERENCES [dbo].[Regiao_Venda] ([cd_regiao_venda])
);

