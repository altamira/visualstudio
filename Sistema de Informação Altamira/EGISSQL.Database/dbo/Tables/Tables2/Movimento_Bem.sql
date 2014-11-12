CREATE TABLE [dbo].[Movimento_Bem] (
    [cd_movimento_bem]      INT          NOT NULL,
    [cd_bem]                INT          NOT NULL,
    [dt_movimento_bem]      DATETIME     NULL,
    [cd_tipo_movimento_bem] INT          NULL,
    [cd_historico_bem]      INT          NULL,
    [nm_obs_movimento_bem]  VARCHAR (40) NULL,
    [vl_movimento_bem]      FLOAT (53)   NULL,
    [cd_moeda]              INT          NULL,
    [dt_moeda]              DATETIME     NULL,
    [cd_tipo_documento]     INT          NULL,
    [cd_doc_movimento_bem]  INT          NULL,
    [dt_doc_movimento_bem]  DATETIME     NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [cd_calculo_bem]        INT          NULL,
    CONSTRAINT [PK_Movimento_Bem] PRIMARY KEY CLUSTERED ([cd_movimento_bem] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Movimento_Bem_Bem] FOREIGN KEY ([cd_bem]) REFERENCES [dbo].[Bem] ([cd_bem]),
    CONSTRAINT [FK_Movimento_Bem_Historico_Bem] FOREIGN KEY ([cd_historico_bem]) REFERENCES [dbo].[Historico_Bem] ([cd_historico_bem]),
    CONSTRAINT [FK_Movimento_Bem_Tipo_Documento] FOREIGN KEY ([cd_tipo_documento]) REFERENCES [dbo].[Tipo_Documento] ([cd_tipo_documento]),
    CONSTRAINT [FK_Movimento_Bem_Tipo_Movimento_Bem] FOREIGN KEY ([cd_tipo_movimento_bem]) REFERENCES [dbo].[Tipo_Movimento_Bem] ([cd_tipo_movimento_bem])
);

