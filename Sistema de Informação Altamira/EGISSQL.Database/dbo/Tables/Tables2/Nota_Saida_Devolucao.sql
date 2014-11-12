CREATE TABLE [dbo].[Nota_Saida_Devolucao] (
    [cd_nota_saida]           INT          NOT NULL,
    [cd_item_nota_saida]      INT          NOT NULL,
    [cd_devolucao_nota_saida] INT          NOT NULL,
    [ic_dev_nota_saida]       CHAR (1)     NULL,
    [dt_nota_dev_nota_saida]  DATETIME     NULL,
    [cd_nota_dev_nota_saida]  INT          NULL,
    [cd_status_nota]          INT          NULL,
    [qt_devolucao_item_nota]  FLOAT (53)   NULL,
    [nm_mot_devol_nota_saida] VARCHAR (60) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Nota_Saida_Devolucao] PRIMARY KEY CLUSTERED ([cd_nota_saida] ASC, [cd_item_nota_saida] ASC, [cd_devolucao_nota_saida] ASC) WITH (FILLFACTOR = 90)
);

