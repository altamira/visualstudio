CREATE TABLE [dbo].[Itinerario] (
    [cd_itinerario]        INT          NOT NULL,
    [nm_itinerario]        VARCHAR (40) NOT NULL,
    [sg_Itinerario]        CHAR (10)    NOT NULL,
    [nm_obs_itinerario]    VARCHAR (40) NOT NULL,
    [cd_usuario]           INT          NOT NULL,
    [dt_usuario]           DATETIME     NOT NULL,
    [cd_veiculo]           INT          NULL,
    [cd_motorista]         INT          NULL,
    [cd_faixa_cep_inicial] VARCHAR (8)  NULL,
    [cd_faixa_cep_final]   VARCHAR (8)  NULL,
    CONSTRAINT [PK_Itinerario] PRIMARY KEY CLUSTERED ([cd_itinerario] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Itinerario_Motorista] FOREIGN KEY ([cd_motorista]) REFERENCES [dbo].[Motorista] ([cd_motorista]),
    CONSTRAINT [FK_Itinerario_Veiculo] FOREIGN KEY ([cd_veiculo]) REFERENCES [dbo].[Veiculo] ([cd_veiculo])
);

