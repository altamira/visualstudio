CREATE TABLE [dbo].[Maquina_Ferramenta] (
    [cd_maquina]                  INT          NOT NULL,
    [cd_ferramenta]               INT          NOT NULL,
    [cd_usuario]                  INT          NULL,
    [dt_usuario]                  DATETIME     NULL,
    [ic_ativo_maquina_ferramenta] CHAR (1)     NULL,
    [nm_obs_maquina_ferramenta]   VARCHAR (40) NULL,
    [cd_item_ferramenta]          INT          NOT NULL,
    CONSTRAINT [PK_Maquina_Ferramenta] PRIMARY KEY CLUSTERED ([cd_maquina] ASC, [cd_item_ferramenta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Maquina_Ferramenta_Ferramenta] FOREIGN KEY ([cd_ferramenta]) REFERENCES [dbo].[Ferramenta] ([cd_ferramenta])
);

