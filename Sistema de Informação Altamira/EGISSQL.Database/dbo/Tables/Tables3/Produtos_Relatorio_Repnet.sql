CREATE TABLE [dbo].[Produtos_Relatorio_Repnet] (
    [cd_produtos_relatorio] INT          NOT NULL,
    [sg_produtos_relatorio] VARCHAR (25) NULL,
    [nm_produtos_relatorio] VARCHAR (30) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Produtos_Relatorio_Repnet] PRIMARY KEY CLUSTERED ([cd_produtos_relatorio] ASC) WITH (FILLFACTOR = 90)
);

