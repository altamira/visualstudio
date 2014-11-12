CREATE TABLE [dbo].[backu_nota_saida_recibo_02a42] (
    [cd_nota_saida]            INT           NOT NULL,
    [cd_recibo_nfe_nota_saida] VARCHAR (15)  NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [cd_protocolo_nfe]         VARCHAR (40)  NULL,
    [ic_cancelada_nfe]         CHAR (1)      NULL,
    [ic_impressao_danfe]       CHAR (1)      NULL,
    [dt_autorizacao_nota]      DATETIME      NULL,
    [ic_numeracao_nfe]         CHAR (1)      NULL,
    [ic_contigencia_nfe]       CHAR (1)      NULL,
    [nm_arquivo_envio_xml]     VARCHAR (200) NULL,
    [nm_arquivo_recibo]        VARCHAR (200) NULL,
    [nm_arquivo_status]        VARCHAR (200) NULL,
    [cd_recibo_backup]         VARCHAR (15)  NULL,
    [ic_email_nota_saida]      CHAR (1)      NULL
);

