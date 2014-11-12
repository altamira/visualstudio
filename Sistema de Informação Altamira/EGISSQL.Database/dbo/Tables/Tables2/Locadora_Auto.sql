CREATE TABLE [dbo].[Locadora_Auto] (
    [cd_locadora_auto]          INT           NOT NULL,
    [nm_locadora_autos]         VARCHAR (30)  NULL,
    [nm_fantasia_locadora_auto] VARCHAR (15)  NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    [cd_cep_locadora]           CHAR (9)      NULL,
    [nm_end_locadora]           VARCHAR (50)  NULL,
    [nm_bairro_locadora]        VARCHAR (25)  NULL,
    [cd_pais]                   INT           NULL,
    [cd_estado]                 INT           NULL,
    [cd_cidade]                 INT           NULL,
    [cd_fone_locadora]          INT           NULL,
    [cd_fax_locadora]           INT           NULL,
    [nm_site_locadora]          VARCHAR (100) NULL,
    [nm_email_locadora]         VARCHAR (100) NULL,
    [nm_contato_locadora]       VARCHAR (40)  NULL,
    [nm_obs_locadora]           VARCHAR (40)  NULL,
    CONSTRAINT [PK_Locadora_Auto] PRIMARY KEY CLUSTERED ([cd_locadora_auto] ASC) WITH (FILLFACTOR = 90)
);

