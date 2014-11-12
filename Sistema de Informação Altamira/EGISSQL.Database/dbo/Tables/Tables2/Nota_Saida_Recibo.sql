CREATE TABLE [dbo].[Nota_Saida_Recibo] (
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
    [ic_email_nota_saida]      CHAR (1)      NULL,
    CONSTRAINT [PK_Nota_Saida_Recibo] PRIMARY KEY CLUSTERED ([cd_nota_saida] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Nota_Saida_Recibo_Nota_Saida] FOREIGN KEY ([cd_nota_saida]) REFERENCES [dbo].[Nota_Saida] ([cd_nota_saida])
);

