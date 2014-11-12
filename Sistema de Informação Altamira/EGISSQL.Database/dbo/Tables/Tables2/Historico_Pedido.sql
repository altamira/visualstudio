CREATE TABLE [dbo].[Historico_Pedido] (
    [cd_historico_pedido]      INT          NOT NULL,
    [nm_historico_pedido]      VARCHAR (30) NOT NULL,
    [ic_tipo_historico_pedido] CHAR (1)     NULL,
    [cd_tabela]                VARCHAR (50) NULL,
    [nm_atributo]              VARCHAR (50) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_departamento]          INT          NULL,
    [ic_gera_custo]            CHAR (1)     NULL,
    [ic_gera_ocorrencia]       CHAR (1)     NULL,
    CONSTRAINT [PK_Historico_Pedido] PRIMARY KEY CLUSTERED ([cd_historico_pedido] ASC) WITH (FILLFACTOR = 90)
);

