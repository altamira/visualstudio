CREATE TABLE [dbo].[Cliente_Prospeccao_Contato] (
    [cd_cliente_prospeccao]   INT           NOT NULL,
    [cd_prospeccao_contato]   INT           NOT NULL,
    [nm_contato]              VARCHAR (40)  NULL,
    [nm_fantasia_contato]     VARCHAR (15)  NULL,
    [cd_ddd_contato]          CHAR (4)      NULL,
    [cd_fone_contato]         CHAR (15)     NULL,
    [cd_fax_contato]          CHAR (15)     NULL,
    [cd_celular_contato]      CHAR (15)     NULL,
    [cd_ramal_contato]        CHAR (10)     NULL,
    [nm_email_contato]        VARCHAR (100) NULL,
    [ds_obs_contato]          TEXT          NULL,
    [nm_cargo_contato]        VARCHAR (20)  NULL,
    [nm_departamento_contato] VARCHAR (25)  NULL,
    [dt_nascimento_contato]   DATETIME      NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [cd_ddi_contato]          CHAR (4)      NULL,
    [cd_ddd_celular]          CHAR (4)      NULL,
    [cd_ddi_celular]          CHAR (4)      NULL,
    CONSTRAINT [PK_Cliente_Prospeccao_Contato] PRIMARY KEY CLUSTERED ([cd_cliente_prospeccao] ASC, [cd_prospeccao_contato] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Prospeccao_Contato_Cliente_Prospeccao] FOREIGN KEY ([cd_cliente_prospeccao]) REFERENCES [dbo].[Cliente_Prospeccao] ([cd_cliente_prospeccao])
);

