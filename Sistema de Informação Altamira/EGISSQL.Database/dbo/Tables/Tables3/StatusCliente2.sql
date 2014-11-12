CREATE TABLE [dbo].[StatusCliente2] (
    [cd_status_cliente]          INT          NOT NULL,
    [nm_status_cliente]          VARCHAR (30) NOT NULL,
    [nm_fantasia_status_cliente] VARCHAR (15) NOT NULL,
    [ic_pagto_comissao_cliente]  CHAR (1)     NOT NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    CONSTRAINT [PK_StatusCliente2] PRIMARY KEY CLUSTERED ([cd_status_cliente] ASC) WITH (FILLFACTOR = 90)
);

