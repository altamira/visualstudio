CREATE TABLE [dbo].[Tipo_Autorizacao_Pagamento] (
    [cd_tipo_ap]             INT           NOT NULL,
    [nm_tipo_ap]             VARCHAR (50)  NULL,
    [sg_tipo_ap]             CHAR (10)     NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    [ic_mostra_ap]           CHAR (1)      NULL,
    [nm_referencia_tipo_ap]  VARCHAR (100) NULL,
    [nm_forma_pagto_tipo_ap] VARCHAR (40)  NULL,
    CONSTRAINT [PK_Tipo_Autorizacao_Pagamento] PRIMARY KEY CLUSTERED ([cd_tipo_ap] ASC) WITH (FILLFACTOR = 90)
);

