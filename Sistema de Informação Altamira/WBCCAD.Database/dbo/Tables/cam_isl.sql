CREATE TABLE [dbo].[cam_isl] (
    [isl_descricao]      NVARCHAR (40) NULL,
    [isl_codigo]         NVARCHAR (20) NULL,
    [isl_espessura]      INT           NULL,
    [isl_tipo]           NVARCHAR (2)  NULL,
    [isl_largura_padrao] FLOAT (53)    NULL,
    [isl_vao_maximo]     FLOAT (53)    NULL,
    [isl_pedido]         INT           NULL,
    [isl_fabricante]     NVARCHAR (30) NULL,
    [pref_des]           NVARCHAR (50) NULL,
    [multiplo]           FLOAT (53)    NULL,
    [medida_canto]       FLOAT (53)    NULL,
    [cor]                NVARCHAR (5)  NULL,
    [fator_k]            FLOAT (53)    NULL,
    [isl_acabamento]     NVARCHAR (10) NULL
);

