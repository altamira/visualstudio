CREATE TABLE [dbo].[Tipo_Importacao] (
    [cd_tipo_importacao]       INT          NOT NULL,
    [nm_tipo_importacao]       VARCHAR (30) NOT NULL,
    [sg_tipo_importacao]       CHAR (10)    NOT NULL,
    [qt_dia_tipo_importacao]   INT          NOT NULL,
    [cd_usuario]               INT          NOT NULL,
    [dt_usuario]               DATETIME     NOT NULL,
    [pc_ii_tipo_importacao]    FLOAT (53)   NULL,
    [pc_ipi_tipo_importacao]   FLOAT (53)   NULL,
    [pc_icms_tipo_importacao]  FLOAT (53)   NULL,
    [pc_rbase_tipo_importacao] FLOAT (53)   NULL,
    [sg_imp_tipo_importacao]   CHAR (2)     NULL,
    [ic_pad_tipo_importacao]   CHAR (1)     NULL,
    [qt_dias_embarque]         FLOAT (53)   NULL,
    [pc_frete_tipo_importacao] FLOAT (53)   NULL,
    [ic_via_transporte]        CHAR (1)     NULL,
    [cd_tipo_frete]            INT          NULL,
    [cd_remocao]               INT          NULL,
    [cd_transporte]            INT          NULL,
    CONSTRAINT [PK_Tipo_Importacao] PRIMARY KEY CLUSTERED ([cd_tipo_importacao] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Importacao_Remocao] FOREIGN KEY ([cd_remocao]) REFERENCES [dbo].[Remocao] ([cd_remocao]),
    CONSTRAINT [FK_Tipo_Importacao_Tipo_Frete] FOREIGN KEY ([cd_tipo_frete]) REFERENCES [dbo].[Tipo_Frete] ([cd_tipo_frete])
);

