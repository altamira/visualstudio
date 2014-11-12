CREATE TABLE [dbo].[Consulta_Dinamica] (
    [cd_consulta_dinamica] INT           NOT NULL,
    [nm_consulta_dinamica] VARCHAR (100) NULL,
    [ds_consulta_dinamica] TEXT          NULL,
    [cd_usuario]           INT           NULL,
    [dt_usuario]           DATETIME      NULL,
    [ds_instrucao_sql]     TEXT          NULL,
    CONSTRAINT [PK_Consulta_Dinamica] PRIMARY KEY CLUSTERED ([cd_consulta_dinamica] ASC) WITH (FILLFACTOR = 90)
);

