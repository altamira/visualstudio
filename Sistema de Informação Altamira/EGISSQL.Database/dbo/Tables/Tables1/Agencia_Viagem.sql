CREATE TABLE [dbo].[Agencia_Viagem] (
    [cd_agencia_viagem]         INT           NOT NULL,
    [nm_agencia_viagem]         VARCHAR (40)  NULL,
    [nm_fantasia_ag_viagem]     VARCHAR (15)  NULL,
    [cd_cep_agencia_viagem]     INT           NULL,
    [nm_end_agencia_viagem]     VARCHAR (50)  NULL,
    [nm_bairro_agencia_viagem]  VARCHAR (25)  NULL,
    [cd_pais]                   INT           NULL,
    [cd_estado]                 INT           NULL,
    [cd_cidade]                 INT           NULL,
    [cd_fone_agencia_viagem]    INT           NULL,
    [cd_fax_agencia_viagem]     INT           NULL,
    [nm_site_agencia_viagem]    VARCHAR (100) NULL,
    [nm_email_agencia_viagem]   VARCHAR (100) NULL,
    [nm_contato_agencia_viagem] VARCHAR (40)  NULL,
    [nm_obs_agencia_viagem]     VARCHAR (40)  NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [ds_agencia_viagem]         TEXT          NULL,
    CONSTRAINT [PK_Agencia_Viagem] PRIMARY KEY CLUSTERED ([cd_agencia_viagem] ASC) WITH (FILLFACTOR = 90)
);

