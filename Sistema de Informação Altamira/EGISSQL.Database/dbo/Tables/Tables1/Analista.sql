CREATE TABLE [dbo].[Analista] (
    [cd_analista]          INT          NOT NULL,
    [nm_analista]          VARCHAR (40) NULL,
    [nm_fantasia_analista] VARCHAR (15) NULL,
    [cd_ddd_analista]      CHAR (4)     NULL,
    [cd_fone_analista]     VARCHAR (15) NULL,
    [cd_celular_analista]  VARCHAR (15) NULL,
    [vl_analista]          FLOAT (53)   NULL,
    [ds_analista]          TEXT         NULL,
    [cd_usuario]           INT          NULL,
    [dt_usuario]           DATETIME     NULL,
    [qt_fator_conv_extra]  FLOAT (53)   NULL,
    [ic_ativo_analista]    CHAR (1)     NULL,
    [cd_conta_banco]       INT          NULL,
    CONSTRAINT [PK_Analista] PRIMARY KEY CLUSTERED ([cd_analista] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Analista_Conta_Agencia_Banco] FOREIGN KEY ([cd_conta_banco]) REFERENCES [dbo].[Conta_Agencia_Banco] ([cd_conta_banco])
);

