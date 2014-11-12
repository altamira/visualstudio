CREATE TABLE [dbo].[Historico_Mao_Obra] (
    [dt_historico_mao_obra] DATETIME   NOT NULL,
    [cd_mao_obra]           INT        NOT NULL,
    [vl_historico_mao_obra] FLOAT (53) NULL,
    [cd_usuario]            INT        NULL,
    [dt_usuario]            DATETIME   NULL,
    CONSTRAINT [PK_Historico_Mao_Obra] PRIMARY KEY CLUSTERED ([cd_mao_obra] ASC) WITH (FILLFACTOR = 90)
);

