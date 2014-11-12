CREATE TABLE [dbo].[Processo_Juridico_Historico] (
    [cd_processo_historico]     INT          NOT NULL,
    [dt_processo_historico]     DATETIME     NULL,
    [cd_processo_juridico]      INT          NOT NULL,
    [ds_processo_historico]     TEXT         NULL,
    [dt_agendamento]            DATETIME     NULL,
    [hr_agendamento]            VARCHAR (8)  NULL,
    [cd_tipo_andamento]         INT          NULL,
    [nm_obs_processo_historico] VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Processo_Juridico_Historico] PRIMARY KEY CLUSTERED ([cd_processo_historico] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Juridico_Historico_Tipo_Andamento_Processo] FOREIGN KEY ([cd_tipo_andamento]) REFERENCES [dbo].[Tipo_Andamento_Processo] ([cd_tipo_andamento_processo])
);

