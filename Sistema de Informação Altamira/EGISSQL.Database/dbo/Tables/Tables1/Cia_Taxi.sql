CREATE TABLE [dbo].[Cia_Taxi] (
    [cd_cia_taxi]          INT           NOT NULL,
    [nm_cia_taxi]          VARCHAR (40)  NOT NULL,
    [nm_fantasia_cia_taxi] VARCHAR (15)  NOT NULL,
    [cd_cep_cia_taxi]      INT           NOT NULL,
    [nm_end_cia_taxi]      VARCHAR (50)  NOT NULL,
    [nm_bairro_cia_taxi]   VARCHAR (25)  NOT NULL,
    [cd_pais]              INT           NOT NULL,
    [cd_estado]            INT           NOT NULL,
    [cd_cidade]            INT           NOT NULL,
    [cd_fone_cia_taxi]     INT           NOT NULL,
    [cd_fax_cia_taxi]      INT           NOT NULL,
    [nm_site_cia_taxi]     VARCHAR (100) NOT NULL,
    [nm_email_cia_taxi]    VARCHAR (100) NOT NULL,
    [nm_contato_cia_taxi]  VARCHAR (40)  NOT NULL,
    [nm_obs_cia_taxi]      VARCHAR (40)  NOT NULL,
    CONSTRAINT [PK_Cia_Taxi] PRIMARY KEY CLUSTERED ([cd_cia_taxi] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cia_Taxi_Pais] FOREIGN KEY ([cd_pais]) REFERENCES [dbo].[Pais] ([cd_pais])
);

