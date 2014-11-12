CREATE TABLE [dbo].[Processo_Juridico_Anexo] (
    [cd_processo_anexo]        INT          NOT NULL,
    [cd_processo_juridico]     INT          NULL,
    [cd_processo_juridico_pai] INT          NULL,
    [nm_obs_processo_anexo]    VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Processo_Juridico_Anexo] PRIMARY KEY CLUSTERED ([cd_processo_anexo] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Processo_Juridico_Anexo_Processo_Juridico] FOREIGN KEY ([cd_processo_juridico_pai]) REFERENCES [dbo].[Processo_Juridico] ([cd_processo_juridico])
);

