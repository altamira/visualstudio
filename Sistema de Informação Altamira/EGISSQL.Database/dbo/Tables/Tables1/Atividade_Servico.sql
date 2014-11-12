CREATE TABLE [dbo].[Atividade_Servico] (
    [cd_atividade]                INT          NOT NULL,
    [nm_atividade]                VARCHAR (60) NULL,
    [sg_atividade]                CHAR (10)    NULL,
    [cd_interface]                VARCHAR (10) NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [nm_idioma_atividade_servico] VARCHAR (60) NULL,
    [ic_site_atividade]           CHAR (1)     NULL,
    CONSTRAINT [PK_Atividade_Servico] PRIMARY KEY CLUSTERED ([cd_atividade] ASC)
);

