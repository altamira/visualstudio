CREATE TABLE [dbo].[Source_Safe] (
    [cd_source_safe]         INT           NOT NULL,
    [nm_arquivo_alterado]    VARCHAR (100) NULL,
    [ic_status_source_safe]  CHAR (1)      NULL,
    [cd_usuario]             INT           NULL,
    [dt_usuario]             DATETIME      NULL,
    [cd_usuario_atualizacao] INT           NULL,
    CONSTRAINT [PK_Source_Safe] PRIMARY KEY CLUSTERED ([cd_source_safe] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Source_Safe_Usuario] FOREIGN KEY ([cd_usuario_atualizacao]) REFERENCES [dbo].[Usuario] ([cd_usuario])
);

