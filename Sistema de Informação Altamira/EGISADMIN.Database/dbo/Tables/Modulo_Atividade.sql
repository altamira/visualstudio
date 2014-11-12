CREATE TABLE [dbo].[Modulo_Atividade] (
    [cd_modulo]                 INT          NOT NULL,
    [cd_atividade]              INT          NOT NULL,
    [qt_hora_modulo_atividade]  FLOAT (53)   NULL,
    [ds_modulo_atividade]       TEXT         NULL,
    [nm_obs_modulo_atividade]   VARCHAR (40) NULL,
    [cd_ordem_modulo_atividade] INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Modulo_Atividade] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_atividade] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Modulo_Atividade_Atividade_Implantacao] FOREIGN KEY ([cd_atividade]) REFERENCES [dbo].[Atividade_Implantacao] ([cd_atividade])
);

