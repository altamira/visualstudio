CREATE TABLE [dbo].[Divisao_Area_Vendedor] (
    [cd_vendedor]      INT        NOT NULL,
    [cd_geomapa]       CHAR (10)  NOT NULL,
    [vl_geomapa]       FLOAT (53) NULL,
    [qt_cliente]       INT        NULL,
    [qt_cliente_venda] INT        NULL,
    [pc_crescimento]   FLOAT (53) NULL,
    [vl_saldo]         FLOAT (53) NULL,
    CONSTRAINT [PK_Divisao_area_vendedor] PRIMARY KEY CLUSTERED ([cd_vendedor] ASC, [cd_geomapa] ASC) WITH (FILLFACTOR = 90)
);

