CREATE TABLE [dbo].[Categoria_Cliente] (
    [cd_categoria_cliente]     INT          NOT NULL,
    [nm_categoria_cliente]     VARCHAR (40) NULL,
    [sg_categoria_cliente]     CHAR (10)    NULL,
    [ic_vendas_categoria_cli]  CHAR (1)     NULL,
    [ic_fatura_categoria_cli]  CHAR (1)     NULL,
    [cd_grupo_categoria_cli]   INT          NOT NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_categoria_cliente_pai] INT          NULL,
    [cd_mascara_categoria_cli] VARCHAR (20) NULL,
    [ic_salesnet]              CHAR (1)     NULL,
    CONSTRAINT [PK_Categoria_Cliente] PRIMARY KEY CLUSTERED ([cd_categoria_cliente] ASC, [cd_grupo_categoria_cli] ASC) WITH (FILLFACTOR = 90)
);

