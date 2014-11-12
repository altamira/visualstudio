CREATE TABLE [dbo].[Formacao_Markup_Periodo] (
    [cd_tipo_markup]         INT        NOT NULL,
    [cd_aplicacao_markup]    INT        NOT NULL,
    [dt_ini_formacao_markup] DATETIME   NULL,
    [dt_fim_formacao_markup] DATETIME   NULL,
    [cd_usuario]             INT        NULL,
    [dt_usuario]             DATETIME   NULL,
    [pc_formacao_markup]     FLOAT (53) NULL,
    CONSTRAINT [PK_Formacao_Markup_Periodo] PRIMARY KEY CLUSTERED ([cd_tipo_markup] ASC, [cd_aplicacao_markup] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Formacao_Markup_Periodo_Aplicacao_Markup] FOREIGN KEY ([cd_aplicacao_markup]) REFERENCES [dbo].[Aplicacao_Markup] ([cd_aplicacao_markup])
);

