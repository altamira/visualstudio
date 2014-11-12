CREATE TABLE [dbo].[Componente_Proposta] (
    [cd_componente_proposta] INT          NOT NULL,
    [nm_componente_proposta] VARCHAR (40) NULL,
    [ic_ativo_comp_proposta] CHAR (1)     NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [nm_obs_comp_proposta]   VARCHAR (40) NULL,
    [cd_ordem_componente]    INT          NULL,
    [cd_idioma]              INT          NULL,
    CONSTRAINT [PK_Componente_Proposta] PRIMARY KEY CLUSTERED ([cd_componente_proposta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Componente_Proposta_Idioma] FOREIGN KEY ([cd_idioma]) REFERENCES [dbo].[Idioma] ([cd_idioma])
);

