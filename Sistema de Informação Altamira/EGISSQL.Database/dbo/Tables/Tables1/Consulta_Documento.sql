CREATE TABLE [dbo].[Consulta_Documento] (
    [cd_consulta]           INT           NOT NULL,
    [cd_consulta_documento] INT           NOT NULL,
    [nm_consulta_documento] VARCHAR (50)  NULL,
    [dt_consulta_documento] DATETIME      NULL,
    [nm_caminho_documento]  VARCHAR (200) NULL,
    [ds_consulta_documento] TEXT          NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    CONSTRAINT [PK_Consulta_Documento] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_consulta_documento] ASC) WITH (FILLFACTOR = 90)
);

