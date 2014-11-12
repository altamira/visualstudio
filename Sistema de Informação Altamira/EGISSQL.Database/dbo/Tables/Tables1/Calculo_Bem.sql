CREATE TABLE [dbo].[Calculo_Bem] (
    [cd_calculo_bem]        INT        NOT NULL,
    [cd_bem]                INT        NOT NULL,
    [dt_calculo_bem]        DATETIME   NOT NULL,
    [cd_tipo_calculo_ativo] INT        NULL,
    [cd_moeda]              INT        NULL,
    [qt_moeda_calculo_bem]  FLOAT (53) NULL,
    [vl_calculo_bem]        FLOAT (53) NULL,
    [pc_calculo_bem]        FLOAT (53) NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    [cd_indice_monetario]   INT        NULL,
    [cd_grupo_bem]          INT        NULL,
    CONSTRAINT [PK_Calculo_Bem] PRIMARY KEY CLUSTERED ([cd_bem] ASC, [dt_calculo_bem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Calculo_Bem_Indice_Monetario] FOREIGN KEY ([cd_indice_monetario]) REFERENCES [dbo].[Indice_Monetario] ([cd_indice_monetario])
);

