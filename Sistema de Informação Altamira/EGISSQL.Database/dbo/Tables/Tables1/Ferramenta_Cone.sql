CREATE TABLE [dbo].[Ferramenta_Cone] (
    [cd_cone]               INT      NOT NULL,
    [cd_grupo_ferramenta]   INT      NOT NULL,
    [cd_ferramenta]         INT      NOT NULL,
    [dt_montagem_cone]      DATETIME NULL,
    [qt_tempo_retorno_cone] INT      NOT NULL,
    [cd_usuario]            INT      NOT NULL,
    [dt_usuario]            DATETIME NULL,
    CONSTRAINT [PK_Ferramenta_Cone] PRIMARY KEY CLUSTERED ([cd_cone] ASC, [cd_grupo_ferramenta] ASC, [cd_ferramenta] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK__Ferrament__cd_co__3D7E1B63] FOREIGN KEY ([cd_cone]) REFERENCES [dbo].[Cone] ([cd_cone])
);


GO
CREATE NONCLUSTERED INDEX [XIF16Ferramenta_Cone]
    ON [dbo].[Ferramenta_Cone]([cd_grupo_ferramenta] ASC, [cd_ferramenta] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [XIF17Ferramenta_Cone]
    ON [dbo].[Ferramenta_Cone]([cd_cone] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [XIF18Ferramenta_Cone]
    ON [dbo].[Ferramenta_Cone]([cd_usuario] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Ferramenta_Cone]
    ON [dbo].[Ferramenta_Cone]([cd_grupo_ferramenta] ASC, [cd_ferramenta] ASC) WITH (FILLFACTOR = 90);

