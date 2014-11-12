CREATE TABLE [dbo].[Meta_Faturamento] (
    [cd_empresa]              INT          NOT NULL,
    [cd_meta_faturamento]     INT          NOT NULL,
    [dt_ini_meta_faturamento] DATETIME     NOT NULL,
    [dt_fim_meta_faturamento] DATETIME     NOT NULL,
    [vl_meta_faturamento]     FLOAT (53)   NULL,
    [ic_pad_meta_faturamento] CHAR (1)     NULL,
    [nm_obs_meta_faturamento] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_tipo_mercado]         INT          NULL,
    [qt_meta_faturamento]     FLOAT (53)   NULL,
    CONSTRAINT [PK_Meta_Faturamento] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_meta_faturamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Meta_Faturamento_Tipo_Mercado] FOREIGN KEY ([cd_tipo_mercado]) REFERENCES [dbo].[Tipo_Mercado] ([cd_tipo_mercado])
);

