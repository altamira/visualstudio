CREATE TABLE [dbo].[Preco_Frete] (
    [cd_preco_frete] INT          NOT NULL,
    [nm_preco_frete] VARCHAR (40) NOT NULL,
    [vl_preco_frete] FLOAT (53)   NULL,
    [pc_preco_frete] FLOAT (53)   NULL,
    [ic_ativo]       CHAR (1)     NOT NULL,
    [cd_usuario]     INT          NULL,
    [dt_usuario]     DATETIME     NULL,
    CONSTRAINT [PK_Preco_Frete] PRIMARY KEY CLUSTERED ([cd_preco_frete] ASC) WITH (FILLFACTOR = 90)
);

