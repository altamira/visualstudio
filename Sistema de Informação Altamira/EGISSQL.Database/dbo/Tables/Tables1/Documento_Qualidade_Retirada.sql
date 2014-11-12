CREATE TABLE [dbo].[Documento_Qualidade_Retirada] (
    [cd_retirada_documento]  INT      NOT NULL,
    [dt_retirada_documento]  DATETIME NULL,
    [dt_prevista_devolucao]  DATETIME NULL,
    [cd_motivo_retirada]     INT      NULL,
    [cd_documento_qualidade] INT      NOT NULL,
    [cd_planta]              INT      NULL,
    [cd_departamento]        INT      NULL,
    [ds_retirada_documento]  TEXT     NULL,
    [cd_funcionario]         INT      NULL,
    [dt_devolucao_documento] DATETIME NULL,
    [cd_usuario]             INT      NULL,
    [dt_usuario]             DATETIME NULL,
    CONSTRAINT [PK_Documento_Qualidade_Retirada] PRIMARY KEY CLUSTERED ([cd_retirada_documento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Documento_Qualidade_Retirada_Funcionario] FOREIGN KEY ([cd_funcionario]) REFERENCES [dbo].[Funcionario] ([cd_funcionario])
);

