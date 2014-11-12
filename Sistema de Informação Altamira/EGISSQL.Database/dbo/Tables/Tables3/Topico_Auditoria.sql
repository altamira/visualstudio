CREATE TABLE [dbo].[Topico_Auditoria] (
    [cd_topico_auditoria]     INT          NOT NULL,
    [nm_topico_auditoria]     VARCHAR (40) NULL,
    [ds_topico_auditoria]     TEXT         NULL,
    [cd_instrucao]            INT          NULL,
    [qt_topico_auditoria]     INT          NULL,
    [nm_obs_topico_auditoria] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Topico_Auditoria] PRIMARY KEY CLUSTERED ([cd_topico_auditoria] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Topico_Auditoria_Instrucao_Interna] FOREIGN KEY ([cd_instrucao]) REFERENCES [dbo].[Instrucao_Interna] ([cd_instrucao])
);

