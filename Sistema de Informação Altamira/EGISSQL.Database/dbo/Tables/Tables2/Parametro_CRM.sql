CREATE TABLE [dbo].[Parametro_CRM] (
    [cd_empresa]               INT         NOT NULL,
    [qt_ligacao_dia_operador]  INT         NULL,
    [qt_visita_vendedor]       INT         NULL,
    [cd_usuario]               INT         NULL,
    [dt_usuario]               DATETIME    NULL,
    [qt_apresentacao_vendedor] INT         NULL,
    [cd_campanha]              INT         NULL,
    [hr_inicio_trabalho]       VARCHAR (8) NULL,
    [hr_fim_trabalho]          VARCHAR (8) NULL,
    [qt_visita_tecnico]        FLOAT (53)  NULL,
    CONSTRAINT [PK_Parametro_CRM] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Parametro_CRM_Campanha] FOREIGN KEY ([cd_campanha]) REFERENCES [dbo].[Campanha] ([cd_campanha])
);

