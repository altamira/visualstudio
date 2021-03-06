﻿CREATE TABLE [dbo].[Registro_Atendimento] (
    [cd_registro_atendimento]     INT           NOT NULL,
    [dt_registro_atendimento]     DATETIME      NULL,
    [cd_usuario_atendimento]      INT           NULL,
    [cd_assunto_atendimento]      INT           NULL,
    [cd_empresa_atendimento]      INT           NULL,
    [nm_empresa_registro]         VARCHAR (40)  NULL,
    [cd_tratamento_pessoa]        INT           NULL,
    [nm_contato_registro]         VARCHAR (40)  NULL,
    [nm_depto_contato]            VARCHAR (30)  NULL,
    [cd_ddd_empresa]              CHAR (4)      NULL,
    [cd_fone_empresa]             VARCHAR (15)  NULL,
    [cd_celular_contato]          VARCHAR (15)  NULL,
    [cd_email_contato]            VARCHAR (100) NULL,
    [ds_registro_atendimento]     TEXT          NULL,
    [nm_obs_registro_atendimento] VARCHAR (40)  NULL,
    [ic_recado]                   CHAR (1)      NULL,
    [dt_recado]                   DATETIME      NULL,
    [cd_usuario_recado]           INT           NULL,
    [nm_obs_recado]               VARCHAR (40)  NULL,
    [ic_retorno]                  CHAR (1)      NULL,
    [qt_dia_retorno]              INT           NULL,
    [dt_retorno]                  DATETIME      NULL,
    [cd_usuario_retorno]          INT           NULL,
    [nm_obs_retorno]              VARCHAR (40)  NULL,
    [cd_usuario]                  INT           NULL,
    [dt_usuario]                  DATETIME      NULL,
    CONSTRAINT [PK_Registro_Atendimento] PRIMARY KEY CLUSTERED ([cd_registro_atendimento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Registro_Atendimento_Usuario] FOREIGN KEY ([cd_usuario_retorno]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

