CREATE TABLE [dbo].[Manutencao_Modulo] (
    [cd_modulo]                     INT          NOT NULL,
    [cd_item_manutencao_modulo]     INT          NOT NULL,
    [cd_tipo_prioridade]            INT          NULL,
    [dt_manutencao_modulo]          DATETIME     NULL,
    [nm_manutencao_modulo]          VARCHAR (50) NULL,
    [ds_manutencao_modulo]          TEXT         NULL,
    [qt_dia_manutencao_modulo]      INT          NULL,
    [qt_hora_manutencao_modulo]     FLOAT (53)   NULL,
    [dt_entrega_manutencao_entrega] DATETIME     NULL,
    [cd_tipo_manut_sistema]         INT          NULL,
    [cd_status_manut_sistema]       INT          NULL,
    [dt_baixa_manut_modulo]         DATETIME     NULL,
    [cd_usuario_baixa_manut]        INT          NULL,
    [cd_usuario]                    INT          NULL,
    [dt_usuario]                    DATETIME     NULL,
    [dt_entrega_manut_entrega]      DATETIME     NULL,
    CONSTRAINT [PK_Manutencao_Modulo] PRIMARY KEY CLUSTERED ([cd_modulo] ASC, [cd_item_manutencao_modulo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Manutencao_Modulo_Tipo_Prioridade] FOREIGN KEY ([cd_tipo_prioridade]) REFERENCES [dbo].[Tipo_Prioridade] ([cd_tipo_prioridade]),
    CONSTRAINT [FK_Manutencao_Modulo_Usuario] FOREIGN KEY ([cd_usuario_baixa_manut]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

