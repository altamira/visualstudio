CREATE TABLE [dbo].[Sepultura_Preco] (
    [cd_parcela_preco]     INT        NOT NULL,
    [cd_sepultura]         INT        NULL,
    [cd_num_parcela_preco] INT        NULL,
    [vl_parcela_preco]     FLOAT (53) NULL,
    [cd_usuario]           INT        NULL,
    [dt_usuario]           DATETIME   NULL,
    CONSTRAINT [PK_Sepultura_Preco] PRIMARY KEY CLUSTERED ([cd_parcela_preco] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Sepultura_Preco_Sepultura] FOREIGN KEY ([cd_sepultura]) REFERENCES [dbo].[Sepultura] ([cd_sepultura])
);

