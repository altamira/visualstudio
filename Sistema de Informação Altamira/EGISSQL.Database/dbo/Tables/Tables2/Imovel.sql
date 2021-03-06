﻿CREATE TABLE [dbo].[Imovel] (
    [cd_imovel]               INT          NOT NULL,
    [nm_imovel]               VARCHAR (60) NULL,
    [ds_imovel]               TEXT         NULL,
    [nm_contribuinte_imovel]  VARCHAR (30) NULL,
    [cd_igreja]               INT          NULL,
    [cd_situacao_iptu]        INT          NULL,
    [cd_pais]                 INT          NULL,
    [cd_estado]               INT          NULL,
    [cd_cidade]               INT          NULL,
    [cd_identifica_cep]       INT          NULL,
    [nm_endereco]             VARCHAR (60) NULL,
    [cd_numero_endereco]      VARCHAR (10) NULL,
    [cd_complemento_endereco] VARCHAR (30) NULL,
    [nm_bairro]               VARCHAR (25) NULL,
    [cd_tipo_imovel]          INT          NULL,
    [cd_prefeitura]           INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_contribuinte_imovel]  VARCHAR (30) NULL,
    [cd_matricula_imovel]     VARCHAR (30) NULL,
    [nm_cartorio]             VARCHAR (50) NULL,
    [nm_comarca]              VARCHAR (15) NULL,
    [ic_alvara_imovel]        CHAR (1)     NULL,
    [ic_escritura_imovel]     CHAR (1)     NULL,
    CONSTRAINT [PK_Imovel] PRIMARY KEY CLUSTERED ([cd_imovel] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Imovel_Prefeitura] FOREIGN KEY ([cd_prefeitura]) REFERENCES [dbo].[Prefeitura] ([cd_prefeitura])
);

