CREATE TABLE [dbo].[TstCab] (
    [TstCabCodigo]    INT            NOT NULL,
    [TstCabDescricao] NVARCHAR (100) NULL,
    [TstCabBloqueado] BIT            NULL,
    [TstCabData]      DATETIME       NULL,
    [TstCabValor]     FLOAT (53)     NULL,
    CONSTRAINT [PK_TstCab] PRIMARY KEY CLUSTERED ([TstCabCodigo] ASC)
);

