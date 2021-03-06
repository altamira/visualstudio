﻿CREATE TABLE [dbo].[Concessionario_Endereco] (
    [cd_concessionario]         INT           NOT NULL,
    [cd_local_correspondencia]  INT           NOT NULL,
    [cd_identifica_cep]         INT           NULL,
    [cd_cep]                    VARCHAR (9)   NULL,
    [nm_enderec_concessionario] VARCHAR (50)  NULL,
    [nm_bairro_concessionario]  VARCHAR (25)  NULL,
    [cd_pais]                   INT           NULL,
    [cd_estado]                 INT           NULL,
    [cd_cidade]                 INT           NULL,
    [cd_ddd_concessionario]     CHAR (4)      NULL,
    [cd_fone_concessionario]    VARCHAR (15)  NULL,
    [cd_celular_concessionario] VARCHAR (15)  NULL,
    [ds_enderec_concessionario] TEXT          NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [cd_tipo_endereco]          INT           NULL,
    [cd_numero_endereco]        VARCHAR (10)  NULL,
    [nm_complemento_endereco]   VARCHAR (30)  NULL,
    [cd_cpf_endereco]           VARCHAR (14)  NULL,
    [cd_inscestadual]           VARCHAR (18)  NULL,
    [dt_cadastro_endereco]      DATETIME      NULL,
    [nm_ponto_ref_conc_ender]   VARCHAR (100) NULL,
    CONSTRAINT [PK_Concessionario_Endereco] PRIMARY KEY CLUSTERED ([cd_concessionario] ASC, [cd_local_correspondencia] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Concessionario_Endereco_Tipo_Endereco] FOREIGN KEY ([cd_tipo_endereco]) REFERENCES [dbo].[Tipo_Endereco] ([cd_tipo_endereco])
);

