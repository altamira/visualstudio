CREATE TABLE [dbo].[Pendencia_Cliente] (
    [cd_pendencia_cliente]    INT          NOT NULL,
    [nm_referencia_pendencia] VARCHAR (50) NULL,
    [cd_modulo]               INT          NULL,
    [cd_departamento]         INT          NULL,
    [dt_levantamento]         DATETIME     NULL,
    [dt_prevista_entrega]     DATETIME     NULL,
    [ic_prioridade]           CHAR (1)     NULL,
    [ic_status]               CHAR (1)     NULL,
    [ds_pendencia_cliente]    TEXT         NULL,
    [cd_os_pendencia_cliente] VARCHAR (20) NULL,
    [cd_analista]             INT          NULL,
    [dt_conclusao]            DATETIME     NULL,
    [cd_usuario_pendencia]    INT          NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Pendencia_Cliente] PRIMARY KEY CLUSTERED ([cd_pendencia_cliente] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Pendencia_Cliente_Analista] FOREIGN KEY ([cd_analista]) REFERENCES [dbo].[Analista] ([cd_analista]),
    CONSTRAINT [FK_Pendencia_Cliente_Usuario] FOREIGN KEY ([cd_usuario_pendencia]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

