CREATE TABLE [dbo].[Agencia_Banco_Contato] (
    [cd_agencia_banco]      INT           NOT NULL,
    [cd_contato_agencia]    INT           NOT NULL,
    [nm_contato_agencia]    VARCHAR (40)  NULL,
    [nm_fantasia_contato]   VARCHAR (15)  NULL,
    [dt_nascimento_contato] DATETIME      NULL,
    [nm_email_contato]      VARCHAR (100) NULL,
    [cd_ddd_contato]        VARCHAR (4)   NULL,
    [cd_fone_contato]       VARCHAR (15)  NULL,
    [cd_celular_contato]    VARCHAR (15)  NULL,
    [cd_ramal_contato]      VARCHAR (15)  NULL,
    [ds_contato_agencia]    TEXT          NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    [cd_ddi_contato]        CHAR (4)      NULL,
    [cd_ddi_celular]        VARCHAR (4)   NULL,
    [cd_ddd_celular]        VARCHAR (4)   NULL,
    CONSTRAINT [PK_Agencia_Banco_Contato] PRIMARY KEY CLUSTERED ([cd_agencia_banco] ASC, [cd_contato_agencia] ASC) WITH (FILLFACTOR = 90)
);

