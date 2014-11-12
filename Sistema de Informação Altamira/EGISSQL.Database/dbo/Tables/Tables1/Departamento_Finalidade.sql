CREATE TABLE [dbo].[Departamento_Finalidade] (
    [cd_departamento]           INT      NOT NULL,
    [ic_comercial_Produto]      CHAR (1) NULL,
    [ic_compra_produto]         CHAR (1) NULL,
    [ic_producao_produto]       CHAR (1) NULL,
    [ic_processo_produto]       CHAR (1) NULL,
    [ic_importacao_Produto]     CHAR (1) NULL,
    [ic_exportacao_produto]     CHAR (1) NULL,
    [ic_beneficiamento_produto] CHAR (1) NULL,
    [ic_amostra_produto]        CHAR (1) NULL,
    [ic_consignacao_produto]    CHAR (1) NULL,
    [ic_transferencia_produto]  CHAR (1) NULL,
    [ic_sob_encomenda_produto]  CHAR (1) NULL,
    [ic_revenda_produto]        CHAR (1) NULL,
    [ic_tecnica_produto]        CHAR (1) NULL,
    [ic_almox_produto]          CHAR (1) NULL,
    [cd_usuario]                INT      NULL,
    [dt_usuario]                DATETIME NULL,
    CONSTRAINT [PK_Departamento_Finalidade] PRIMARY KEY CLUSTERED ([cd_departamento] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Departamento_Finalidade_Departamento] FOREIGN KEY ([cd_departamento]) REFERENCES [dbo].[Departamento] ([cd_departamento])
);

