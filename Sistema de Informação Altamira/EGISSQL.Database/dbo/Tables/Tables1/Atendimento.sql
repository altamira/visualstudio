CREATE TABLE [dbo].[Atendimento] (
    [cd_atendimento]         INT          NOT NULL,
    [dt_atendimento]         DATETIME     NOT NULL,
    [nm_atendimento]         VARCHAR (40) NOT NULL,
    [cd_departamento]        INT          NOT NULL,
    [cd_usuario_atendimento] INT          NOT NULL,
    [cd_contrato_manutencao] INT          NOT NULL,
    [cd_tipo_prioridade]     INT          NOT NULL,
    [cd_tipo_atendimento]    INT          NOT NULL,
    [ds_atendimento]         TEXT         NOT NULL,
    [cd_usuario]             INT          NOT NULL,
    [dt_usuario]             DATETIME     NOT NULL,
    CONSTRAINT [PK_Atendimento] PRIMARY KEY CLUSTERED ([cd_atendimento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Atendimento_Contrato_Manutencao] FOREIGN KEY ([cd_contrato_manutencao]) REFERENCES [dbo].[Contrato_Manutencao] ([cd_contrato_manutencao]),
    CONSTRAINT [FK_Atendimento_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento]),
    CONSTRAINT [FK_Atendimento_Tipo_Atendimento] FOREIGN KEY ([cd_tipo_atendimento]) REFERENCES [dbo].[Tipo_Atendimento] ([cd_tipo_atendimento]),
    CONSTRAINT [FK_Atendimento_Tipo_Prioridade] FOREIGN KEY ([cd_tipo_prioridade]) REFERENCES [dbo].[Tipo_Prioridade] ([cd_tipo_prioridade])
);

