CREATE TABLE [dbo].[GrupoUsuario] (
    [cd_grupo_usuario]             INT          NOT NULL,
    [nm_grupo_usuario]             VARCHAR (40) NOT NULL,
    [sg_grupo_usuario]             CHAR (10)    NOT NULL,
    [ic_tipo_grupo_usuario]        CHAR (1)     NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [ic_bloquear_exportacao_dados] CHAR (1)     NULL,
    [cd_departamento]              INT          NULL,
    [nm_obs_grupo_usuario]         VARCHAR (40) NULL,
    [ic_solicitacao_pagamento]     CHAR (1)     NULL,
    [ic_extrato_funcionario]       CHAR (1)     NULL,
    CONSTRAINT [PK_GrupoUsuario] PRIMARY KEY CLUSTERED ([cd_grupo_usuario] ASC) WITH (FILLFACTOR = 90)
);

