CREATE TABLE [dbo].[Meta_Prospeccao_Vendedor] (
    [cd_vendedor]               INT          NOT NULL,
    [dt_inicio]                 DATETIME     NOT NULL,
    [dt_final]                  DATETIME     NOT NULL,
    [qt_ligacao_meta]           INT          NULL,
    [qt_pipe_meta]              INT          NULL,
    [qt_email_meta]             INT          NULL,
    [qt_visita_meta]            INT          NULL,
    [qt_apresentacao_meta]      INT          NULL,
    [qt_venda_meta]             INT          NULL,
    [nm_obs_meta]               VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [cd_operador_telemarketing] INT          NULL,
    CONSTRAINT [PK_Meta_Prospeccao_Vendedor] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC, [dt_inicio] ASC, [dt_final] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Meta_Prospeccao_Vendedor_Operador_Telemarketing] FOREIGN KEY ([cd_operador_telemarketing]) REFERENCES [dbo].[Operador_Telemarketing] ([cd_operador_telemarketing]),
    CONSTRAINT [FK_Meta_Prospeccao_Vendedor_Vendedor] FOREIGN KEY ([cd_vendedor]) REFERENCES [dbo].[Vendedor] ([cd_vendedor])
);

