CREATE TABLE [dbo].[Aluno_Parcela] (
    [cd_aluno]                 INT          NOT NULL,
    [cd_aluno_parcela]         INT          NOT NULL,
    [dt_vencimento_parcela]    DATETIME     NULL,
    [vl_parcela]               FLOAT (53)   NULL,
    [cd_identificacao_parcela] VARCHAR (15) NULL,
    [nm_obs_aluno_parcela]     VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [dt_pagamento_parcela]     DATETIME     NULL,
    CONSTRAINT [PK_Aluno_Parcela] PRIMARY KEY CLUSTERED ([cd_aluno] ASC, [cd_aluno_parcela] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Aluno_Parcela_Aluno] FOREIGN KEY ([cd_aluno]) REFERENCES [dbo].[Aluno] ([cd_aluno])
);

