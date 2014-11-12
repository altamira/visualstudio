CREATE TABLE [dbo].[Frete_Composicao] (
    [cd_frete_composicao]  INT          NOT NULL,
    [cd_frete]             INT          NULL,
    [cd_frete_adicional]   INT          NULL,
    [ic_tipo_valor]        CHAR (1)     NULL,
    [vl_frete_composicao]  FLOAT (53)   NULL,
    [nm_obs_despesa_frete] VARCHAR (40) NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [ic_base_valor]        CHAR (1)     NULL,
    [qt_minimo_frete]      FLOAT (53)   NULL,
    CONSTRAINT [PK_Frete_Composicao] PRIMARY KEY CLUSTERED ([cd_frete_composicao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Frete_Composicao_Frete_Adicional] FOREIGN KEY ([cd_frete_adicional]) REFERENCES [dbo].[Frete_Adicional] ([cd_frete_adicional])
);

