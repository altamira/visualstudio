CREATE TABLE [dbo].[Revisao_Desenho_Projeto] (
    [cd_projeto]         INT           NOT NULL,
    [cd_desenho_projeto] INT           NOT NULL,
    [cd_revisao_projeto] INT           NOT NULL,
    [dt_revisao_projeto] DATETIME      NOT NULL,
    [nm_revisao_projeto] VARCHAR (30)  NOT NULL,
    [ds_revisao_projeto] TEXT          NULL,
    [nm_desenho_revisao] VARCHAR (50)  NULL,
    [nm_caminho_revisao] VARCHAR (100) NULL,
    [cd_usuario]         INT           NULL,
    [dt_usuario]         DATETIME      NULL,
    CONSTRAINT [PK_Revisao_Projeto] PRIMARY KEY NONCLUSTERED ([cd_projeto] ASC, [cd_desenho_projeto] ASC, [cd_revisao_projeto] ASC) WITH (FILLFACTOR = 90)
);

