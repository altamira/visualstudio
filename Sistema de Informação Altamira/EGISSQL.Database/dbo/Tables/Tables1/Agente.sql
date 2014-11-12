CREATE TABLE [dbo].[Agente] (
    [cd_agente]             INT           NOT NULL,
    [nm_agente]             VARCHAR (40)  NULL,
    [nm_fantasia_agente]    VARCHAR (40)  NULL,
    [cd_tipo_agente]        INT           NULL,
    [cd_ddd_agente]         INT           NULL,
    [cd_fone_agente]        VARCHAR (15)  NULL,
    [cd_celular_agente]     VARCHAR (15)  NULL,
    [ds_agente]             TEXT          NULL,
    [pc_comissao_agente]    FLOAT (53)    NULL,
    [ic_ativo_agente]       CHAR (1)      NULL,
    [dt_usuario]            DATETIME      NULL,
    [cd_usuario]            INT           NULL,
    [dt_aniversario_agente] DATETIME      NULL,
    [nm_site_agente]        VARCHAR (100) NULL,
    [nm_email_agente]       VARCHAR (100) NULL,
    CONSTRAINT [PK_Agente] PRIMARY KEY CLUSTERED ([cd_agente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Agente_Tipo_Agente] FOREIGN KEY ([cd_tipo_agente]) REFERENCES [dbo].[Tipo_Agente] ([cd_tipo_agente])
);

