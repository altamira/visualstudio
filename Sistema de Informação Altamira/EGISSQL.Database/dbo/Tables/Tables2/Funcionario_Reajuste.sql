CREATE TABLE [dbo].[Funcionario_Reajuste] (
    [cd_reajuste_funcionario]  INT          NOT NULL,
    [cd_funcionario]           INT          NULL,
    [dt_reajuste_funcionario]  DATETIME     NULL,
    [vl_reajuste_funcionario]  MONEY        NULL,
    [cd_tipo_reajuste_salario] INT          NULL,
    [cd_motivo_reajuste]       INT          NULL,
    [nm_reajuste_funcionario]  VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_evento]                INT          NULL,
    [cd_cargo_anterior]        INT          NULL,
    [cd_cargo]                 INT          NULL,
    CONSTRAINT [PK_Funcionario_Reajuste] PRIMARY KEY CLUSTERED ([cd_reajuste_funcionario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Funcionario_Reajuste_Evento_Folha] FOREIGN KEY ([cd_evento]) REFERENCES [dbo].[Evento_Folha] ([cd_evento])
);

