CREATE TABLE [dbo].[Favorecido_Empresa] (
    [cd_empresa]                INT          NOT NULL,
    [cd_empresa_diversa]        INT          NOT NULL,
    [cd_favorecido_empresa_div] INT          NOT NULL,
    [nm_favorecido_empresa]     VARCHAR (30) NULL,
    [ds_favorecido_empresa]     TEXT         NULL,
    [nm_agencia_banco_favoreci] VARCHAR (20) NULL,
    [cd_conta_favorecido]       VARCHAR (20) NULL,
    [cd_banco]                  INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Favorecido_Empresa] PRIMARY KEY CLUSTERED ([cd_empresa] ASC, [cd_empresa_diversa] ASC, [cd_favorecido_empresa_div] ASC) WITH (FILLFACTOR = 90)
);

