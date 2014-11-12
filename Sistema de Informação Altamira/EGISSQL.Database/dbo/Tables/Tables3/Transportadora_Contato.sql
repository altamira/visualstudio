CREATE TABLE [dbo].[Transportadora_Contato] (
    [cd_transportadora]         INT           NOT NULL,
    [cd_transportadora_contato] INT           NOT NULL,
    [nm_contato]                VARCHAR (40)  NULL,
    [nm_fantasia]               VARCHAR (15)  NULL,
    [cd_ddd_contato]            CHAR (4)      NULL,
    [cd_telefone_contato]       VARCHAR (15)  NULL,
    [cd_fax_contato]            VARCHAR (15)  NULL,
    [cd_celular_contato]        VARCHAR (15)  NULL,
    [cd_ramal_contato]          VARCHAR (10)  NULL,
    [nm_email_contato]          VARCHAR (100) NULL,
    [nm_obs_contato]            VARCHAR (60)  NULL,
    [cd_cargo]                  INT           NULL,
    [cd_departamento]           INT           NULL,
    [cd_acesso_contato]         VARCHAR (10)  COLLATE Latin1_General_CI_AS NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [dt_nascimento_contato]     DATETIME      NULL,
    [ic_nfe_contato]            CHAR (1)      NULL,
    CONSTRAINT [PK_Transportadora_Contato] PRIMARY KEY CLUSTERED ([cd_transportadora] ASC, [cd_transportadora_contato] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [idx_transportadora_contato]
    ON [dbo].[Transportadora_Contato]([cd_transportadora] ASC, [cd_transportadora_contato] ASC) WITH (FILLFACTOR = 90);

