CREATE TABLE [dbo].[Motivo_Ativacao_Pedido] (
    [cd_motivo_ativacao_pedido] INT          NOT NULL,
    [nm_motivo_ativacao_pedido] VARCHAR (40) NULL,
    [sg_motivo_ativacao_pedido] CHAR (10)    NULL,
    [ic_motivo_ativacao_pedido] CHAR (1)     NULL,
    [cd_usuario]                INT          NULL,
    [dt_usuario]                DATETIME     NULL,
    CONSTRAINT [PK_Motivo_Ativacao_Pedido] PRIMARY KEY CLUSTERED ([cd_motivo_ativacao_pedido] ASC) WITH (FILLFACTOR = 90)
);

