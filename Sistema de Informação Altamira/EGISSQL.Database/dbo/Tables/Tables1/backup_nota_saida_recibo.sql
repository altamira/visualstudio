CREATE TABLE [dbo].[backup_nota_saida_recibo] (
    [cd_nota_saida]            INT          NOT NULL,
    [cd_recibo_nfe_nota_saida] VARCHAR (15) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_protocolo_nfe]         VARCHAR (40) NULL,
    [ic_cancelada_nfe]         CHAR (1)     NULL,
    [ic_impressao_danfe]       CHAR (1)     NULL,
    [dt_autorizacao_nota]      DATETIME     NULL,
    [ic_numeracao_nfe]         CHAR (1)     NULL,
    [ic_contigencia_nfe]       CHAR (1)     NULL
);

