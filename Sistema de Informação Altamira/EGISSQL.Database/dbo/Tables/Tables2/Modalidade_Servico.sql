CREATE TABLE [dbo].[Modalidade_Servico] (
    [cd_modalidade_servico] INT           NOT NULL,
    [nm_modalidade_servico] VARCHAR (100) NULL,
    [ds_modalidade_servico] TEXT          NULL,
    [cd_mascara_modalidade] INT           NULL,
    [cd_usuario]            INT           NULL,
    [dt_usuario]            DATETIME      NULL,
    CONSTRAINT [PK_Modalidade_Servico] PRIMARY KEY CLUSTERED ([cd_modalidade_servico] ASC) WITH (FILLFACTOR = 90)
);

