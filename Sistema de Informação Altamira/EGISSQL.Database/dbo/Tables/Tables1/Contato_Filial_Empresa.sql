CREATE TABLE [dbo].[Contato_Filial_Empresa] (
    [cd_filial_empresa]         INT           NOT NULL,
    [cd_contato_filial_empresa] INT           NOT NULL,
    [nm_contato_filial_emp]     VARCHAR (40)  NULL,
    [nm_fantasia_c_filial_emp]  VARCHAR (15)  NULL,
    [cd_ddd_contato_filial_emp] CHAR (4)      NULL,
    [cd_fone_c_filial_emp]      VARCHAR (15)  NULL,
    [cd_fax_contato_filial_emp] VARCHAR (15)  NULL,
    [cd_cel_contato_filial_emp] VARCHAR (15)  NULL,
    [nm_email_c_filial_empresa] VARCHAR (100) NULL,
    [cd_acesso]                 INT           NULL,
    [nm_departamento]           VARCHAR (30)  NULL,
    [nm_cargo]                  VARCHAR (30)  NULL,
    [ds_obs_contato_filial_emp] TEXT          NULL,
    [cd_usuario]                INT           NULL,
    [dt_usuario]                DATETIME      NULL,
    CONSTRAINT [PK_Contato_Filial_Empresa] PRIMARY KEY CLUSTERED ([cd_filial_empresa] ASC, [cd_contato_filial_empresa] ASC) WITH (FILLFACTOR = 90)
);

