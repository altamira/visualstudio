CREATE TABLE [dbo].[Grupo_Orcamento] (
    [cd_grupo_orcamento]        INT          NOT NULL,
    [nm_grupo_orcamento]        VARCHAR (40) NULL,
    [sg_grupo_orcamento]        CHAR (15)    NULL,
    [cd_masc_grupo_orcamento]   VARCHAR (20) NULL,
    [cd_tipo_calculo_orcamento] INT          NULL,
    [cd_mao_obra]               INT          NULL,
    [ic_serv_grupo_orcamento]   CHAR (1)     NULL,
    [ic_resumo_grupo_orcamento] CHAR (1)     NULL,
    [ic_fatora_grupo_orcamento] CHAR (1)     NULL,
    [ic_hora_grupo_orcamento]   CHAR (1)     NULL,
    [cd_ordem_grupo_orcamento]  INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_fator_grupo_orcamento]  CHAR (1)     NULL,
    [ic_ativo_grupo_orcamento]  CHAR (1)     NULL,
    CONSTRAINT [PK_Grupo_Orcamento] PRIMARY KEY CLUSTERED ([cd_grupo_orcamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Grupo_Orcamento_Mao_Obra] FOREIGN KEY ([cd_mao_obra]) REFERENCES [dbo].[Mao_Obra] ([cd_mao_obra]),
    CONSTRAINT [FK_Grupo_Orcamento_Tipo_Calculo_Orcamento] FOREIGN KEY ([cd_tipo_calculo_orcamento]) REFERENCES [dbo].[Tipo_Calculo_Orcamento] ([cd_tipo_calculo_orcamento])
);

