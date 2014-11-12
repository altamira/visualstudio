CREATE TABLE [dbo].[Aluno_Plano] (
    [cd_aluno]                INT          NOT NULL,
    [cd_plano]                INT          NOT NULL,
    [vl_plano_aluno]          FLOAT (53)   NULL,
    [cd_modalidade_pagamento] INT          NULL,
    [qt_dia_vencimento]       INT          NULL,
    [cd_status_aluno]         INT          NULL,
    [dt_matricula_aluno]      DATETIME     NULL,
    [cd_matricula_aluno]      INT          NULL,
    [cd_identificacao_aluno]  VARCHAR (25) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_convenio]             INT          NULL,
    [nm_complemento_situacao] VARCHAR (40) NULL,
    [cd_motivo_situacao]      INT          NULL,
    [dt_situacao_aluno]       DATETIME     NULL,
    CONSTRAINT [PK_Aluno_Plano] PRIMARY KEY CLUSTERED ([cd_aluno] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Aluno_Plano_Convenio] FOREIGN KEY ([cd_convenio]) REFERENCES [dbo].[Convenio] ([cd_convenio]),
    CONSTRAINT [FK_Aluno_Plano_Motivo_Situacao_Aluno] FOREIGN KEY ([cd_motivo_situacao]) REFERENCES [dbo].[Motivo_Situacao_Aluno] ([cd_motivo_situacao]),
    CONSTRAINT [FK_Aluno_Plano_Status_Cliente] FOREIGN KEY ([cd_status_aluno]) REFERENCES [dbo].[Status_Cliente] ([cd_status_cliente])
);

