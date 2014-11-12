﻿CREATE TABLE [dbo].[Candidato] (
    [cd_candidato]              INT           NOT NULL,
    [dt_candidato]              DATETIME      NULL,
    [cd_cargo_funcionario]      INT           NULL,
    [cd_seccao]                 INT           NULL,
    [cd_departamento]           INT           NULL,
    [nm_arquivo_cv]             VARCHAR (100) NULL,
    [nm_candidato]              VARCHAR (70)  NULL,
    [nm_email_candidato]        VARCHAR (70)  NULL,
    [cd_sexo]                   INT           NULL,
    [cd_estado_civil]           INT           NULL,
    [cd_cpf_candidato]          VARCHAR (18)  NULL,
    [dt_nascimento_candidato]   DATETIME      NULL,
    [ic_trabalhando_candidato]  CHAR (1)      NULL,
    [cd_fone_candidato]         VARCHAR (15)  NULL,
    [cd_ddd_candidato]          CHAR (4)      NULL,
    [cd_ddd_cel_candidato]      VARCHAR (4)   NULL,
    [cd_celular_candidato]      VARCHAR (15)  NULL,
    [cd_fax_candidato]          VARCHAR (15)  NULL,
    [cd_ddd_fax_candidato]      VARCHAR (4)   NULL,
    [nm_home_candidato]         VARCHAR (100) NULL,
    [nm_bairro_candidato]       VARCHAR (25)  NULL,
    [cd_cidade]                 INT           NULL,
    [cd_estado]                 INT           NULL,
    [cd_cep]                    VARCHAR (8)   NULL,
    [cd_pais]                   INT           NULL,
    [ds_cv_personalizado]       TEXT          NULL,
    [cd_usuario]                INT           NULL,
    [nm_curriculum_candidato]   VARCHAR (100) NULL,
    [dt_usuario]                DATETIME      NULL,
    [cd_identifica_cep]         INT           NULL,
    [nm_foto_candidato]         VARCHAR (100) NULL,
    [cd_requisicao_vaga]        INT           NULL,
    [cd_grau_instrucao]         INT           NULL,
    [nm_compl_endereco]         VARCHAR (25)  NULL,
    [nm_numero_endereco]        VARCHAR (10)  NULL,
    [nm_endereco_candidato]     VARCHAR (40)  NULL,
    [nm_recado_candidato]       VARCHAR (40)  NULL,
    [vl_salario_candidato]      FLOAT (53)    NULL,
    [cd_nivel_hierarquico]      INT           NULL,
    [ic_confidencial_candidato] CHAR (1)      NULL,
    [ds_perfil_candidato]       TEXT          NULL,
    [cd_rg_candidato]           VARCHAR (18)  NULL,
    CONSTRAINT [PK_Candidato] PRIMARY KEY CLUSTERED ([cd_candidato] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Candidato_Grau_Instrucao] FOREIGN KEY ([cd_grau_instrucao]) REFERENCES [dbo].[Grau_Instrucao] ([cd_grau_instrucao]),
    CONSTRAINT [FK_Candidato_Nivel_Hierarquico] FOREIGN KEY ([cd_nivel_hierarquico]) REFERENCES [dbo].[Nivel_Hierarquico] ([cd_nivel_hierarquico]),
    CONSTRAINT [FK_Candidato_Pais] FOREIGN KEY ([cd_pais]) REFERENCES [dbo].[Pais] ([cd_pais])
);

