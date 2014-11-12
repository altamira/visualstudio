CREATE TABLE [dbo].[Consulta_Negociacao] (
    [cd_consulta]            INT          NOT NULL,
    [cd_negociacao_consulta] INT          NOT NULL,
    [dt_negociacao_consulta] DATETIME     NULL,
    [nm_negociacao_consulta] VARCHAR (40) NULL,
    [ds_negociacao_consulta] TEXT         NULL,
    [cd_vendedor]            INT          NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    [cd_contato]             INT          NULL,
    CONSTRAINT [PK_Consulta_Negociacao] PRIMARY KEY CLUSTERED ([cd_consulta] ASC, [cd_negociacao_consulta] ASC) WITH (FILLFACTOR = 90)
);

