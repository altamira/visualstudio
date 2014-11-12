CREATE TABLE [dbo].[Grupo_Ocorrencia_Pedido_Venda] (
    [cd_grupo_ocorrencia_pedido]    INT          NOT NULL,
    [nm_grupo_ocorrencia_pedido]    VARCHAR (20) NULL,
    [sg_grupo_ocorrecia_pedido]     CHAR (10)    NULL,
    [cd_usuario]                    INT          NULL,
    [dt_usuario]                    DATETIME     NULL,
    [ic_controlar_grupo_especifico] CHAR (1)     NULL,
    CONSTRAINT [PK_Grupo_Ocorrencia_Pedido_Venda] PRIMARY KEY CLUSTERED ([cd_grupo_ocorrencia_pedido] ASC) WITH (FILLFACTOR = 90)
);

