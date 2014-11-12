CREATE TABLE [dbo].[Funcionario_Exame_Medico] (
    [cd_funcionario]            INT          NOT NULL,
    [cd_item_exame_funcionario] INT          NULL,
    [dt_exame_funcionario]      DATETIME     NULL,
    [ic_exame_funcionario]      CHAR (1)     NULL,
    [nm_obs_exame_funcionario]  VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [nm_status]                 VARCHAR (10) NULL,
    [dt_ultimo_exame]           DATETIME     NULL,
    [cd_tipo_exame]             INT          NULL,
    [qt_dia_validade_exame]     INT          NULL,
    [dt_vencimento_exame]       DATETIME     NULL,
    CONSTRAINT [PK_Funcionario_Exame_Medico] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_Exame_Medico_Tipo_Exame] FOREIGN KEY ([cd_tipo_exame]) REFERENCES [dbo].[Tipo_Exame] ([cd_tipo_exame])
);

