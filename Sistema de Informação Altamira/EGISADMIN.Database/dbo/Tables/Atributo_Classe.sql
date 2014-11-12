CREATE TABLE [dbo].[Atributo_Classe] (
    [cd_tabela]                INT          NOT NULL,
    [cd_atributo]              INT          NOT NULL,
    [cd_classe]                INT          NOT NULL,
    [cd_ordem_atributo_classe] INT          NOT NULL,
    [ic_tipo_processo_classe]  CHAR (1)     NULL,
    [nm_obs_atributo_classe]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Atributo_Classe] PRIMARY KEY CLUSTERED ([cd_tabela] ASC, [cd_atributo] ASC, [cd_classe] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Atributo_Classe_Classe] FOREIGN KEY ([cd_classe]) REFERENCES [dbo].[Classe] ([cd_classe])
);

