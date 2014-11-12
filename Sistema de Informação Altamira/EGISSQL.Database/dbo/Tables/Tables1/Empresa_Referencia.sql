CREATE TABLE [dbo].[Empresa_Referencia] (
    [cd_empresa]                INT          NOT NULL,
    [cd_tipo_ref_comercial]     INT          NULL,
    [nm_empresa_referencia]     VARCHAR (40) NULL,
    [dt_empresa_referencia]     DATETIME     NULL,
    [nm_func_empresa_ref]       VARCHAR (40) NULL,
    [cd_ddd]                    CHAR (4)     NULL,
    [cd_fone]                   VARCHAR (15) NULL,
    [cd_fax]                    VARCHAR (15) NULL,
    [ds_obs_empresa_referencia] TEXT         NULL,
    [nm_contato_empresa_ref]    VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Empresa_Referencia] PRIMARY KEY CLUSTERED ([cd_empresa] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Empresa_Referencia_Tipo_Referencia_Comercial] FOREIGN KEY ([cd_tipo_ref_comercial]) REFERENCES [dbo].[Tipo_Referencia_Comercial] ([cd_tipo_ref_comercial])
);

