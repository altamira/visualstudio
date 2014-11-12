CREATE TABLE [dbo].[Oportunidade_Agenda] (
    [cd_oportunidade_agenda] INT          NOT NULL,
    [dt_oportunidade_agenda] DATETIME     NULL,
    [cd_local_oficina]       INT          NULL,
    [cd_cliente]             INT          NULL,
    [cd_modelo_veiculo]      INT          NULL,
    [cd_servico]             INT          NULL,
    [nm_obs_agenda]          VARCHAR (40) NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Oportunidade_Agenda] PRIMARY KEY CLUSTERED ([cd_oportunidade_agenda] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Oportunidade_Agenda_Servico_Veiculo] FOREIGN KEY ([cd_servico]) REFERENCES [dbo].[Servico_Veiculo] ([cd_servico])
);

