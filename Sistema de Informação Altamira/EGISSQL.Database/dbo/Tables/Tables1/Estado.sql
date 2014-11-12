CREATE TABLE [dbo].[Estado] (
    [cd_estado]               INT           NOT NULL,
    [nm_estado]               VARCHAR (30)  NULL,
    [sg_estado]               CHAR (2)      NULL,
    [cd_pais]                 INT           NULL,
    [ic_zona_franca]          CHAR (1)      NULL,
    [cd_usuario]              INT           NULL,
    [dt_usuario]              DATETIME      NULL,
    [nm_link_sintegra_estado] VARCHAR (150) NULL,
    [ic_analise_estado]       CHAR (1)      NULL,
    [ic_valida_ie_estado]     CHAR (1)      NULL,
    [cd_regiao_pais]          INT           NULL,
    [cd_ibge_estado]          INT           NULL,
    [nm_bandeira_estado]      VARCHAR (150) NULL,
    [sg_nire_estado]          CHAR (10)     NULL,
    PRIMARY KEY CLUSTERED ([cd_estado] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Estado_Regiao_Pais] FOREIGN KEY ([cd_regiao_pais]) REFERENCES [dbo].[Regiao_Pais] ([cd_regiao_pais])
);

