CREATE TABLE [dbo].[forma_condicao_pagamento] (
    [cd_forma_condicao]        INT          NOT NULL,
    [nm_forma_condicao]        VARCHAR (40) NULL,
    [sg_forma_condicao]        CHAR (10)    NULL,
    [cd_digito_forma_condicao] INT          NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [ic_avista_forma_condicao] CHAR (1)     NULL
);

