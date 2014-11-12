CREATE TABLE [dbo].[Campeonato] (
    [cd_campeonato]        INT           NOT NULL,
    [nm_campeonato]        VARCHAR (40)  NULL,
    [sg_campeonato]        CHAR (10)     NULL,
    [nm_site_campeonato]   VARCHAR (100) NULL,
    [nm_imagem_campeonato] VARCHAR (100) NULL,
    [cd_usuario]           INT           NULL,
    [dt_usuario]           DATETIME      NULL,
    [ic_ativo_campeonato]  CHAR (1)      NULL,
    [cd_departamento]      INT           NULL,
    CONSTRAINT [PK_Campeonato] PRIMARY KEY CLUSTERED ([cd_campeonato] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Campeonato_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

