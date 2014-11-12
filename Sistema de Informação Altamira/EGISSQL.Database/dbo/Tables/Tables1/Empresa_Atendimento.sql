CREATE TABLE [dbo].[Empresa_Atendimento] (
    [cd_empresa_atendimento] INT           NOT NULL,
    [nm_empresa_atendimento] VARCHAR (40)  NULL,
    [cd_ddd_empresa]         CHAR (4)      NULL,
    [cd_fone_empresa]        VARCHAR (15)  NULL,
    [nm_site_empresa]        VARCHAR (100) NULL,
    [nm_email_empresa]       VARCHAR (100) NULL,
    [ds_empresa_atendimento] TEXT          NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    CONSTRAINT [PK_Empresa_Atendimento] PRIMARY KEY CLUSTERED ([cd_empresa_atendimento] ASC) WITH (FILLFACTOR = 90)
);

