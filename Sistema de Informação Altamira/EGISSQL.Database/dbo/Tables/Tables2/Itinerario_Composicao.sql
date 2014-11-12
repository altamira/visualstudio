CREATE TABLE [dbo].[Itinerario_Composicao] (
    [cd_itinerario]            INT          NOT NULL,
    [cd_itinerario_composicao] INT          NOT NULL,
    [cd_distrito]              INT          NULL,
    [cd_veiculo]               INT          NULL,
    [cd_motorista]             INT          NULL,
    [nm_obs_itinerario_comp]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_pais]                  INT          NULL,
    [cd_estado]                INT          NULL,
    [cd_cidade]                INT          NULL,
    [cd_transportadora]        INT          NULL,
    [cd_entregador]            INT          NULL,
    CONSTRAINT [PK_Itinerario_Composicao] PRIMARY KEY CLUSTERED ([cd_itinerario] ASC, [cd_itinerario_composicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Itinerario_Composicao_Entregador] FOREIGN KEY ([cd_entregador]) REFERENCES [dbo].[Entregador] ([cd_entregador]),
    CONSTRAINT [FK_Itinerario_Composicao_Motorista] FOREIGN KEY ([cd_motorista]) REFERENCES [dbo].[Motorista] ([cd_motorista]),
    CONSTRAINT [FK_Itinerario_Composicao_Transportadora] FOREIGN KEY ([cd_transportadora]) REFERENCES [dbo].[Transportadora] ([cd_transportadora])
);

