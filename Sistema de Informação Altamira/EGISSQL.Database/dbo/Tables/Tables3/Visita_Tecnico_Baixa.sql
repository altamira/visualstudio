CREATE TABLE [dbo].[Visita_Tecnico_Baixa] (
    [cd_visita]       INT          NOT NULL,
    [dt_baixa_visita] DATETIME     NULL,
    [ds_baixa_visita] TEXT         NULL,
    [cd_tecnico]      INT          NULL,
    [cd_usuario]      INT          NULL,
    [dt_usuario]      DATETIME     NULL,
    [nm_baixa_visita] VARCHAR (60) NULL,
    CONSTRAINT [PK_Visita_Tecnico_Baixa] PRIMARY KEY CLUSTERED ([cd_visita] ASC) WITH (FILLFACTOR = 90)
);

