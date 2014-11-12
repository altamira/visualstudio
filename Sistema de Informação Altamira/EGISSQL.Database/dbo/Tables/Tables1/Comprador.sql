CREATE TABLE [dbo].[Comprador] (
    [cd_comprador]                INT          NOT NULL,
    [nm_comprador]                VARCHAR (40) NOT NULL,
    [nm_fantasia_comprador]       VARCHAR (15) NOT NULL,
    [cd_usuario]                  INT          NOT NULL,
    [dt_usuario]                  DATETIME     NOT NULL,
    [ic_padrao_comprador]         CHAR (1)     NULL,
    [cd_tipo_mercado]             INT          NULL,
    [ic_altera_requisicao_compra] CHAR (1)     NULL,
    [ic_ajustar_custo_entrada]    CHAR (1)     NULL,
    CONSTRAINT [PK_Comprador] PRIMARY KEY CLUSTERED ([cd_comprador] ASC) WITH (FILLFACTOR = 90)
);

