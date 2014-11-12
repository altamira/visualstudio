CREATE TABLE [dbo].[Calculo_Ativo] (
    [cd_calculo_ativo]         INT        NOT NULL,
    [dt_inicio_calculo_ativo]  DATETIME   NULL,
    [dt_fim_calculo_ativo]     DATETIME   NULL,
    [cd_bem]                   INT        NULL,
    [cd_tipo_calculo_ativo]    INT        NULL,
    [cd_moeda]                 INT        NULL,
    [cd_indice_monetario]      INT        NULL,
    [dt_base_indice]           DATETIME   NULL,
    [vl_calculo_ativo]         FLOAT (53) NULL,
    [qt_calculo_ativo]         FLOAT (53) NULL,
    [ic_calculo_ativo]         CHAR (1)   NULL,
    [ic_contato_calculo_ativo] CHAR (1)   NULL,
    [cd_usuario]               INT        NULL,
    [dt_usuario]               DATETIME   NULL,
    CONSTRAINT [PK_Calculo_Ativo] PRIMARY KEY CLUSTERED ([cd_calculo_ativo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Calculo_Ativo_Indice_Monetario] FOREIGN KEY ([cd_indice_monetario]) REFERENCES [dbo].[Indice_Monetario] ([cd_indice_monetario])
);

