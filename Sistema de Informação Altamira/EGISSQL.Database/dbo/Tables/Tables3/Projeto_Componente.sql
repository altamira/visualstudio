CREATE TABLE [dbo].[Projeto_Componente] (
    [cd_projeto_componente] INT          NOT NULL,
    [nm_projeto_componente] VARCHAR (60) NULL,
    [ds_projeto_componente] TEXT         NULL,
    [ic_ativo_componente]   CHAR (1)     NULL,
    [nm_obs_componente]     VARCHAR (40) NULL,
    [cd_ordem_componente]   INT          NULL,
    [cd_idioma]             INT          NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Projeto_Componente] PRIMARY KEY CLUSTERED ([cd_projeto_componente] ASC) WITH (FILLFACTOR = 90)
);

