CREATE TABLE [dbo].[Movimento_Cone] (
    [dt_movimento_cone]    DATETIME NOT NULL,
    [cd_cone]              INT      NOT NULL,
    [cd_movimento]         INT      NOT NULL,
    [cd_grupo_ferramenta]  INT      NULL,
    [ds_movimento_cone]    TEXT     NULL,
    [cd_ferramenta]        INT      NULL,
    [cd_maquina]           INT      NOT NULL,
    [cd_tipo_movimento]    INT      NULL,
    [cd_usuario]           INT      NOT NULL,
    [qt_dia_operacao_cone] INT      NULL,
    [dt_usuario]           DATETIME NULL,
    CONSTRAINT [PK__Movimento_Cone__0BE6BFCF] PRIMARY KEY NONCLUSTERED ([dt_movimento_cone] ASC, [cd_cone] ASC, [cd_movimento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK__Movimento__cd_co__3C89F72A] FOREIGN KEY ([cd_cone]) REFERENCES [dbo].[Cone] ([cd_cone]),
    CONSTRAINT [FK__Movimento__cd_ma__16644E42] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina]),
    CONSTRAINT [FK__Movimento__cd_ti__1940BAED] FOREIGN KEY ([cd_tipo_movimento]) REFERENCES [dbo].[Tipo_Movimento_Cone] ([cd_tipo_movimento])
);


GO
CREATE NONCLUSTERED INDEX [_WA_Sys_CD_MOVIMENTO_7CA47C3F]
    ON [dbo].[Movimento_Cone]([cd_movimento] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [_WA_Sys_cd_ferramenta_7CA47C3F]
    ON [dbo].[Movimento_Cone]([cd_ferramenta] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [_WA_Sys_cd_grupo_ferramenta_7CA47C3F]
    ON [dbo].[Movimento_Cone]([cd_grupo_ferramenta] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [_WA_Sys_cd_cone_7CA47C3F]
    ON [dbo].[Movimento_Cone]([cd_cone] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [_WA_Sys_cd_maquina_7CA47C3F]
    ON [dbo].[Movimento_Cone]([cd_maquina] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [_WA_Sys_cd_tipo_movimento_7CA47C3F]
    ON [dbo].[Movimento_Cone]([cd_tipo_movimento] ASC) WITH (FILLFACTOR = 90);


GO
CREATE NONCLUSTERED INDEX [IX_Movimento_Cone]
    ON [dbo].[Movimento_Cone]([cd_movimento] ASC) WITH (FILLFACTOR = 90);

