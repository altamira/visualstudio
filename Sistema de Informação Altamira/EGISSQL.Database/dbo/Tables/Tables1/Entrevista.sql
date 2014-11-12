CREATE TABLE [dbo].[Entrevista] (
    [cd_entrevista]          INT          NOT NULL,
    [dt_entrevista]          DATETIME     NULL,
    [cd_requisicao_vaga]     INT          NULL,
    [cd_tipo_entrevista]     INT          NULL,
    [cd_candidato]           INT          NULL,
    [hr_inicio_entrevista]   VARCHAR (8)  NULL,
    [hr_fim_entrevista]      VARCHAR (8)  NULL,
    [ds_entrevista]          TEXT         NULL,
    [ic_lembrete_entrevista] CHAR (1)     NULL,
    [nm_obs_entrevista]      VARCHAR (40) NULL,
    [dt_agenda_entrevista]   DATETIME     NULL,
    [dt_cancelamento]        DATETIME     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Entrevista] PRIMARY KEY CLUSTERED ([cd_entrevista] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Entrevista_Candidato] FOREIGN KEY ([cd_candidato]) REFERENCES [dbo].[Candidato] ([cd_candidato])
);

