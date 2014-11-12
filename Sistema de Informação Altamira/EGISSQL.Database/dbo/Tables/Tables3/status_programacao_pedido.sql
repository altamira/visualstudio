CREATE TABLE [dbo].[status_programacao_pedido] (
    [cd_status_programacao] INT          NOT NULL,
    [de_status_programacao] VARCHAR (40) COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    [dt_usuario]            DATETIME     NOT NULL,
    [cd_usuario]            INT          NOT NULL,
    [sg_status_programacao] CHAR (5)     COLLATE SQL_Latin1_General_CP1250_CI_AS NOT NULL,
    CONSTRAINT [FK_status_programacao_pedido_Usuario] FOREIGN KEY ([cd_usuario]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

