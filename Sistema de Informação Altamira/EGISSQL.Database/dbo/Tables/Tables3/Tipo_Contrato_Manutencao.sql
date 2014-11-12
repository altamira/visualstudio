CREATE TABLE [dbo].[Tipo_Contrato_Manutencao] (
    [cd_tipo_contrato_manut] INT          NOT NULL,
    [nm_tipo_contrato_manut] VARCHAR (30) NOT NULL,
    [sg_tipo_contrato_manut] CHAR (10)    NULL,
    [vl_manut_tipo_contrato] FLOAT (53)   NULL,
    [qt_fator_tipo_contrato] FLOAT (53)   NULL,
    [cd_tipo_contrato]       INT          NULL,
    [cd_indice_reajuste]     INT          NULL,
    [cd_moeda]               INT          NULL,
    [ds_tipo_contrato_manut] TEXT         NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Contrato_Manutencao] PRIMARY KEY CLUSTERED ([cd_tipo_contrato_manut] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Tipo_Contrato_Manutencao_Moeda] FOREIGN KEY ([cd_moeda]) REFERENCES [dbo].[Moeda] ([cd_moeda])
);

