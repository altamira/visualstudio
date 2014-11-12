CREATE TABLE [dbo].[Prestacao_Conta_Itinerario] (
    [cd_prestacao_itinerario]      INT          NOT NULL,
    [cd_prestacao]                 INT          NULL,
    [cd_item_prestacao_itinerario] INT          NULL,
    [nm_de_itinerario_prestacao]   VARCHAR (40) NULL,
    [nm_para_itinerario_prestacao] VARCHAR (40) NULL,
    [nm_finalidade_itinerario]     VARCHAR (50) NULL,
    [cd_locadora_auto]             INT          NULL,
    [qt_item_km_itinerario]        FLOAT (53)   NULL,
    [nm_obs_itinerario_prestacao]  VARCHAR (40) NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    CONSTRAINT [PK_Prestacao_Conta_Itinerario] PRIMARY KEY CLUSTERED ([cd_prestacao_itinerario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Prestacao_Conta_Itinerario_Locadora_Auto] FOREIGN KEY ([cd_locadora_auto]) REFERENCES [dbo].[Locadora_Auto] ([cd_locadora_auto])
);

