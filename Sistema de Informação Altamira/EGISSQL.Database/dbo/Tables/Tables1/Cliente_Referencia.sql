CREATE TABLE [dbo].[Cliente_Referencia] (
    [cd_cliente]                INT          NOT NULL,
    [cd_tipo_ref_comercial]     INT          NULL,
    [nm_cliente_referencia]     VARCHAR (40) NULL,
    [dt_cliente_referencia]     DATETIME     NULL,
    [nm_func_cliente_ref]       VARCHAR (40) NULL,
    [cd_ddd]                    CHAR (4)     NULL,
    [cd_fone]                   VARCHAR (15) NULL,
    [cd_fax]                    VARCHAR (15) NULL,
    [ds_obs_cliente_referencia] TEXT         NULL,
    [nm_contato_cliente_ref]    VARCHAR (40) NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Cliente_Referencia] PRIMARY KEY CLUSTERED ([cd_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Cliente_Referencia_Tipo_Referencia_Comercial] FOREIGN KEY ([cd_tipo_ref_comercial]) REFERENCES [dbo].[Tipo_Referencia_Comercial] ([cd_tipo_ref_comercial])
);

