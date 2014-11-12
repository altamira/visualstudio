CREATE TABLE [dbo].[Unidade_Medida] (
    [cd_unidade_medida]         INT          NOT NULL,
    [nm_unidade_medida]         VARCHAR (30) NOT NULL,
    [sg_unidade_medida]         CHAR (10)    NOT NULL,
    [cd_imagem]                 INT          NULL,
    [cd_usuario]                INT          NOT NULL,
    [dt_usuario]                DATETIME     NOT NULL,
    [ic_tipo_unidade_medida]    CHAR (1)     NULL,
    [ic_pad_unidade_medida]     CHAR (1)     NULL,
    [ic_fator_conversao]        CHAR (1)     NULL,
    [cd_unidade_inst_norma_srf] CHAR (6)     NULL,
    [qt_decimal_unidade_medida] INT          NULL,
    [nm_titulo_unidade_1]       VARCHAR (20) NULL,
    [nm_titulo_unidade_2]       VARCHAR (20) NULL,
    [ic_conversao_mapa_carga]   CHAR (1)     NULL,
    [cd_fase_produto]           INT          NULL,
    CONSTRAINT [PK_Unidade_medida] PRIMARY KEY CLUSTERED ([cd_unidade_medida] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Unidade_Medida_Fase_Produto] FOREIGN KEY ([cd_fase_produto]) REFERENCES [dbo].[Fase_Produto] ([cd_fase_produto])
);

