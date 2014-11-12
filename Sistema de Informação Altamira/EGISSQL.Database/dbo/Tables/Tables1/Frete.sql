CREATE TABLE [dbo].[Frete] (
    [cd_item_frete]    INT          NOT NULL,
    [cd_pais]          INT          NOT NULL,
    [cd_estado]        INT          NOT NULL,
    [cd_tipo_frete]    INT          NOT NULL,
    [cd_usuario]       INT          NULL,
    [dt_usuario]       DATETIME     NULL,
    [nm_obs_frete]     VARCHAR (30) NULL,
    [ic_pad_imp_frete] CHAR (1)     NULL,
    [nm_frete]         VARCHAR (40) NULL,
    [cd_frete]         INT          NULL,
    CONSTRAINT [PK_Frete] PRIMARY KEY CLUSTERED ([cd_item_frete] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Frete_Frete_Importacao] FOREIGN KEY ([cd_frete]) REFERENCES [dbo].[Frete_Importacao] ([cd_frete])
);

