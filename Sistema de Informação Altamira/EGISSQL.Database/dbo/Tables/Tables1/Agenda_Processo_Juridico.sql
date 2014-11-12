CREATE TABLE [dbo].[Agenda_Processo_Juridico] (
    [cd_agenda_processo]     INT          NOT NULL,
    [dt_agenda_processo]     DATETIME     NULL,
    [cd_processo_juridico]   INT          NOT NULL,
    [cd_advogado]            INT          NULL,
    [cd_tipo_audiencia]      INT          NULL,
    [nm_agenda_processo]     VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [nm_obs_agenda_processo] VARCHAR (40) NULL,
    CONSTRAINT [PK_Agenda_Processo_Juridico] PRIMARY KEY CLUSTERED ([cd_agenda_processo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Agenda_Processo_Juridico_Tipo_Audiencia] FOREIGN KEY ([cd_tipo_audiencia]) REFERENCES [dbo].[Tipo_Audiencia] ([cd_tipo_audiencia])
);

