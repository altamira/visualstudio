CREATE TABLE [dbo].[Politica_Tipo_Despesa] (
    [cd_politica_tipo_despesa]     INT          NOT NULL,
    [cd_tipo_despesa]              INT          NOT NULL,
    [cd_funcionario]               INT          NULL,
    [cd_departamento]              INT          NULL,
    [cd_centro_custo]              INT          NULL,
    [nm_obs_politica_tipo_despesa] VARCHAR (40) NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [cd_politica_viagem]           INT          NULL,
    [vl_politica_tipo_despesa]     FLOAT (53)   NULL,
    CONSTRAINT [PK_Politica_Tipo_Despesa] PRIMARY KEY CLUSTERED ([cd_politica_tipo_despesa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Politica_Tipo_Despesa_Centro_Custo] FOREIGN KEY ([cd_centro_custo]) REFERENCES [dbo].[Centro_Custo] ([cd_centro_custo]),
    CONSTRAINT [FK_Politica_Tipo_Despesa_Politica_Viagem] FOREIGN KEY ([cd_politica_viagem]) REFERENCES [dbo].[Politica_Viagem] ([cd_politica_viagem])
);

