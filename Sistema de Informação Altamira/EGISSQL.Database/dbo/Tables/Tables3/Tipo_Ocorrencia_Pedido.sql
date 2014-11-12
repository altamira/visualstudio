CREATE TABLE [dbo].[Tipo_Ocorrencia_Pedido] (
    [cd_tipo_ocorrencia_pedido] INT          NOT NULL,
    [nm_tipo_ocorrencia_pedido] VARCHAR (30) COLLATE Latin1_General_CI_AS NULL,
    [sg_tipo_ocorrencia_pedido] CHAR (10)    COLLATE Latin1_General_CI_AS NULL,
    [ic_tipo_ocorrencia_pedido] CHAR (1)     COLLATE Latin1_General_CI_AS NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Ocorrencia_Pedido] PRIMARY KEY CLUSTERED ([cd_tipo_ocorrencia_pedido] ASC) WITH (FILLFACTOR = 90)
);

