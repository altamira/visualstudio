CREATE TABLE [dbo].[Funcionario_Afastamento] (
    [cd_afastamento]        INT          NOT NULL,
    [cd_funcionario]        INT          NOT NULL,
    [dt_afastamento]        DATETIME     NULL,
    [dt_inicio_afastamento] DATETIME     NULL,
    [dt_fim_afastamento]    DATETIME     NULL,
    [cd_tipo_afastamento]   INT          NULL,
    [cd_evento]             INT          NULL,
    [vl_evento_afastamento] FLOAT (53)   NULL,
    [nm_obs_afastamento]    VARCHAR (60) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Funcionario_Afastamento] PRIMARY KEY CLUSTERED ([cd_afastamento] ASC),
    CONSTRAINT [FK_Funcionario_Afastamento_Evento_Folha] FOREIGN KEY ([cd_evento]) REFERENCES [dbo].[Evento_Folha] ([cd_evento])
);

