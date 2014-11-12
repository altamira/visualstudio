CREATE TABLE [dbo].[Cliente_Config] (
    [cd_cliente]          INT           NOT NULL,
    [cd_tipo_formato]     INT           NULL,
    [dt_acesso_inicial]   DATETIME      NULL,
    [dt_ultimo_acesso]    DATETIME      NULL,
    [nm_razaosocial]      VARCHAR (40)  NULL,
    [nm_endereco_cliente] VARCHAR (50)  NULL,
    [nm_bairro_cliente]   VARCHAR (25)  NULL,
    [cd_cep]              VARCHAR (9)   NULL,
    [nm_cidade]           VARCHAR (25)  NULL,
    [sg_estado]           CHAR (2)      NULL,
    [cd_ddd]              CHAR (4)      NULL,
    [cd_telefone]         VARCHAR (15)  NULL,
    [cd_fax]              VARCHAR (15)  NULL,
    [cd_cgc]              VARCHAR (15)  NULL,
    [cd_iest]             VARCHAR (18)  NULL,
    [nm_dominio_internet] VARCHAR (100) NULL,
    [nm_email_internet]   VARCHAR (100) NULL,
    [ic_atualizado_sap]   CHAR (1)      NULL,
    [nm_contato_empresa]  VARCHAR (30)  NULL,
    [nm_email_contato]    VARCHAR (100) NULL,
    [cd_status_cliente]   INT           NULL
);

