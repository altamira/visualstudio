﻿CREATE TABLE [dbo].[Equipamento] (
    [cd_equipamento]            INT          NOT NULL,
    [nm_equipamento]            VARCHAR (50) NULL,
    [nm_serie_equipamento]      VARCHAR (20) NULL,
    [cd_tipo_equipamento]       INT          NULL,
    [dt_compra_equipamento]     DATETIME     NULL,
    [cd_contrato_manutencao]    INT          NULL,
    [dt_fim_garantia_equipamen] DATETIME     NULL,
    [cd_fabricante]             INT          NULL,
    [cd_fornecedor]             INT          NULL,
    [dt_intalacao_equipamento]  DATETIME     NULL,
    [cd_patrimonio_equipamento] VARCHAR (20) NULL,
    [nm_marca_equipamento]      VARCHAR (30) NULL,
    [nm_modelo_equipamento]     VARCHAR (30) NULL,
    [ds_equipamento]            TEXT         NULL,
    [cd_nota_entrada]           INT          NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    [ic_manutencao_equipamento] CHAR (1)     NULL,
    [cd_maquina]                INT          NULL,
    [dt_instalacao_equipamento] DATETIME     NULL,
    [cd_planta]                 INT          NULL,
    [cd_departamento]           INT          NULL,
    [cd_serie_nota_fiscal]      INT          NULL,
    [cd_operacao_fiscal]        INT          NULL,
    [cd_grupo_equipamento]      INT          NULL,
    CONSTRAINT [PK_Equipamento] PRIMARY KEY CLUSTERED ([cd_equipamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Equipamento_Contrato_Manutencao] FOREIGN KEY ([cd_contrato_manutencao]) REFERENCES [dbo].[Contrato_Manutencao] ([cd_contrato_manutencao]),
    CONSTRAINT [FK_Equipamento_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento]),
    CONSTRAINT [FK_Equipamento_Fabricante] FOREIGN KEY ([cd_fabricante]) REFERENCES [dbo].[Fabricante] ([cd_fabricante]),
    CONSTRAINT [FK_Equipamento_Grupo_Equipamento] FOREIGN KEY ([cd_grupo_equipamento]) REFERENCES [dbo].[Grupo_Equipamento] ([cd_grupo_equipamento]),
    CONSTRAINT [FK_Equipamento_Maquina] FOREIGN KEY ([cd_maquina]) REFERENCES [dbo].[Maquina] ([cd_maquina]),
    CONSTRAINT [FK_Equipamento_Planta] FOREIGN KEY ([cd_planta]) REFERENCES [dbo].[Planta] ([cd_planta]),
    CONSTRAINT [FK_Equipamento_Tipo_Equipamento] FOREIGN KEY ([cd_tipo_equipamento]) REFERENCES [dbo].[Tipo_Equipamento] ([cd_tipo_equipamento])
);

