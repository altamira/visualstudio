CREATE TABLE [dbo].[cia_aerea] (
    [cd_cia_aerea]            INT           NOT NULL,
    [nm_cia_aerea]            VARCHAR (40)  NOT NULL,
    [nm_fantasia_cia_aerea]   VARCHAR (15)  NOT NULL,
    [cd_cep_cia_aerea]        INT           NOT NULL,
    [nm_end_cia_aerea]        VARCHAR (50)  NOT NULL,
    [nm_bairro_cia_aerea]     VARCHAR (25)  NOT NULL,
    [cd_pais]                 INT           NOT NULL,
    [dt_usuario]              DATETIME      NOT NULL,
    [cd_usuario]              INT           NOT NULL,
    [nm_observacao_cia_aerea] VARCHAR (40)  NOT NULL,
    [nm_contato_cia_aerea]    VARCHAR (100) NOT NULL,
    [nm_email_cia_aerea]      VARCHAR (100) NOT NULL,
    [nm_site_cia_aerea]       VARCHAR (100) NOT NULL,
    [cd_fax_cia_aerea]        INT           NOT NULL,
    [cd_fone_cia_aerea]       INT           NOT NULL,
    [cd_estado]               INT           NOT NULL,
    [cd_cidade]               INT           NOT NULL,
    CONSTRAINT [PK_cia_aerea] PRIMARY KEY CLUSTERED ([cd_cia_aerea] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_cia_aerea_Pais] FOREIGN KEY ([cd_pais]) REFERENCES [dbo].[Pais] ([cd_pais])
);

