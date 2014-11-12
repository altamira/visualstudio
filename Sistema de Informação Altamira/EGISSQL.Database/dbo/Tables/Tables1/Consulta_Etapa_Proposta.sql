CREATE TABLE [dbo].[Consulta_Etapa_Proposta] (
    [cd_controle_etapa]      INT          NOT NULL,
    [cd_consulta]            INT          NOT NULL,
    [dt_prog_etapa_proposta] DATETIME     NULL,
    [dt_etapa_proposta]      DATETIME     NULL,
    [nm_etapa_proposta]      VARCHAR (40) NULL,
    [ds_etapa_proposta]      TEXT         NULL,
    [cd_usuario_responsavel] INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Consulta_Etapa_Proposta] PRIMARY KEY CLUSTERED ([cd_controle_etapa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Consulta_Etapa_Proposta_Consulta] FOREIGN KEY ([cd_consulta]) REFERENCES [dbo].[Consulta] ([cd_consulta])
);

