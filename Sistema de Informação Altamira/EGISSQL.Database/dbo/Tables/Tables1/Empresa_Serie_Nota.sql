CREATE TABLE [dbo].[Empresa_Serie_Nota] (
    [cd_empresa]              INT          NOT NULL,
    [cd_item_serie_nota]      INT          NOT NULL,
    [cd_serie_nota_fiscal]    INT          NOT NULL,
    [cd_tipo_numeracao_nota]  INT          NOT NULL,
    [cd_nota_empresa]         INT          NULL,
    [cd_ultima_nota_impressa] INT          NULL,
    [nm_obs_nota_empresa]     VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    [cd_formulario_empresa]   INT          NULL,
    [ic_tipo_emp_serie_nota]  CHAR (1)     NULL,
    CONSTRAINT [PK_Empresa_Serie_Nota] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_item_serie_nota] ASC, [cd_serie_nota_fiscal] ASC, [cd_tipo_numeracao_nota] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Empresa_Serie_Nota_Tipo_Numeracao_Nota] FOREIGN KEY ([cd_tipo_numeracao_nota]) REFERENCES [dbo].[Tipo_Numeracao_Nota] ([cd_tipo_numeracao_nota])
);

