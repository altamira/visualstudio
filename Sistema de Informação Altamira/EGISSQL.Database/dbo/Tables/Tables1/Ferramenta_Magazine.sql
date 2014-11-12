CREATE TABLE [dbo].[Ferramenta_Magazine] (
    [cd_maquina]             INT       NULL,
    [cd_magazine]            INT       NULL,
    [cd_posicao_ferramenta]  INT       NOT NULL,
    [cd_ferramenta]          INT       NULL,
    [nm_fantasia_ferramenta] CHAR (15) NULL,
    [cd_usuario]             INT       NULL,
    [dt_usuario]             DATETIME  NULL,
    CONSTRAINT [PK_Ferramenta_Magazine] PRIMARY KEY CLUSTERED ([cd_posicao_ferramenta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Ferramenta_Magazine_Magazine] FOREIGN KEY ([cd_magazine]) REFERENCES [dbo].[Magazine] ([cd_magazine]),
    CONSTRAINT [FK_Ferramenta_Magazine_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina])
);

