CREATE TABLE [dbo].[Opcao_Compra] (
    [cd_opcao_compra]         INT          NOT NULL,
    [nm_opcao_compra]         VARCHAR (30) NULL,
    [sg_opcao_compra]         CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [ic_padrao_opcao_compra]  CHAR (1)     NULL,
    [qt_ordem_opcao_compra]   INT          NULL,
    [qt_peso_opcao_compra]    INT          NULL,
    [ic_cotacao_opcao_compra] CHAR (1)     NULL,
    CONSTRAINT [PK_Opcao_Compra] PRIMARY KEY CLUSTERED ([cd_opcao_compra] ASC) WITH (FILLFACTOR = 90)
);

