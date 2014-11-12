CREATE TABLE [dbo].[Calculo_Reajuste_Funcionario] (
    [cd_reajuste]        INT        NOT NULL,
    [dt_reajuste]        DATETIME   NULL,
    [cd_funcionario]     INT        NULL,
    [cd_evento]          INT        NULL,
    [vl_anterior_evento] FLOAT (53) NULL,
    [vl_reajuste_evento] FLOAT (53) NULL,
    [cd_usuario]         INT        NULL,
    [dt_usuario]         DATETIME   NULL,
    CONSTRAINT [PK_Calculo_Reajuste_Funcionario] PRIMARY KEY CLUSTERED ([cd_reajuste] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Calculo_Reajuste_Funcionario_Evento_Folha] FOREIGN KEY ([cd_evento]) REFERENCES [dbo].[Evento_Folha] ([cd_evento])
);

