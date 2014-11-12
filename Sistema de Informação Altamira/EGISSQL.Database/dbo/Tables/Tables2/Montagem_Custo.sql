CREATE TABLE [dbo].[Montagem_Custo] (
    [cd_montagem]       INT        NOT NULL,
    [cd_tipo_montagem]  INT        NOT NULL,
    [cd_usuario]        INT        NULL,
    [dt_usuario]        DATETIME   NULL,
    [vl_custo_montagem] FLOAT (53) NOT NULL,
    [cd_serie_produto]  INT        NULL,
    CONSTRAINT [PK_Montagem_Custo] PRIMARY KEY CLUSTERED ([cd_montagem] ASC, [cd_tipo_montagem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Montagem_Custo_Tipo_Montagem] FOREIGN KEY ([cd_tipo_montagem]) REFERENCES [dbo].[Tipo_Montagem] ([cd_tipo_montagem])
);

