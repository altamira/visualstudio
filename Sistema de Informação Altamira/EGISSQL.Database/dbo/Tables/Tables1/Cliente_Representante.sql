﻿CREATE TABLE [dbo].[Cliente_Representante] (
    [cd_cliente]               INT           NOT NULL,
    [cd_item_cliente]          INT           NOT NULL,
    [nm_cliente_representante] VARCHAR (45)  NULL,
    [cd_identifca_cep]         INT           NULL,
    [cd_cep]                   VARCHAR (8)   NULL,
    [nm_endereco]              VARCHAR (60)  NULL,
    [cd_numero_endereo]        VARCHAR (10)  NULL,
    [nm_bairro]                VARCHAR (25)  NULL,
    [cd_pais]                  INT           NULL,
    [cd_estado]                INT           NULL,
    [cd_cidade]                INT           NULL,
    [cd_ddd]                   VARCHAR (4)   NULL,
    [cd_telefone]              VARCHAR (15)  NULL,
    [cd_ddd_celular]           VARCHAR (4)   NULL,
    [cd_celular]               VARCHAR (15)  NULL,
    [cd_ddd_comercial]         VARCHAR (4)   NULL,
    [cd_telefone_comercial]    VARCHAR (4)   NULL,
    [cd_cpf_cliente]           VARCHAR (18)  NULL,
    [cd_rg_cliente]            VARCHAR (18)  NULL,
    [cd_banco]                 INT           NULL,
    [nm_agencia_banco]         VARCHAR (25)  NULL,
    [cd_conta_banco]           VARCHAR (20)  NULL,
    [ds_cliente_representante] TEXT          NULL,
    [cd_usuario]               INT           NULL,
    [dt_usuario]               DATETIME      NULL,
    [cd_tipo_pessoa]           INT           NULL,
    [cd_numero_endereco]       VARCHAR (10)  NULL,
    [nm_abertura_conta]        VARCHAR (5)   NULL,
    [nm_email]                 VARCHAR (150) NULL,
    [dt_nascimento]            DATETIME      NULL,
    [dt_abertura_conta]        DATETIME      NULL,
    CONSTRAINT [PK_Cliente_Representante] PRIMARY KEY CLUSTERED ([cd_cliente] ASC, [cd_item_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Representante_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

