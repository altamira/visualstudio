CREATE TABLE [dbo].[Log_Erro] (
    [cd_log_erro]  INT      NOT NULL,
    [cd_empresa]   INT      NULL,
    [cd_usuario]   INT      NULL,
    [cd_funcao]    INT      NULL,
    [cd_menu]      INT      NULL,
    [nm_estacao]   INT      NULL,
    [dt_usuario]   DATETIME NULL,
    [ic_envio_gbs] CHAR (1) NULL,
    [dt_envio_gbs] DATETIME NULL,
    [dt_log_erro]  DATETIME NULL,
    CONSTRAINT [PK_] PRIMARY KEY CLUSTERED ([cd_log_erro] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK__Empresa] FOREIGN KEY ([cd_empresa]) REFERENCES [dbo].[Empresa] ([cd_empresa])
);

