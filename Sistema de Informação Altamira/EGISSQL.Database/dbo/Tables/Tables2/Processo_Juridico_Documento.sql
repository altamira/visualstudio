CREATE TABLE [dbo].[Processo_Juridico_Documento] (
    [cd_processo_documento] INT           NOT NULL,
    [dt_processo_documento] DATETIME      NULL,
    [cd_processo_juridico]  INT           NULL,
    [nm_processo_documento] VARCHAR (50)  NULL,
    [ds_processo_documento] TEXT          NULL,
    [nm_caminho_documento]  VARCHAR (120) NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    CONSTRAINT [PK_Processo_Juridico_Documento] PRIMARY KEY CLUSTERED ([cd_processo_documento] ASC) WITH (FILLFACTOR = 90)
);

