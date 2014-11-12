CREATE TABLE [dbo].[Desenho_Projeto] (
    [cd_projeto]         INT           NOT NULL,
    [cd_desenho_projeto] INT           NOT NULL,
    [nm_desenho_projeto] VARCHAR (50)  NOT NULL,
    [nm_caminho_projeto] VARCHAR (100) NULL,
    [cd_usuario]         INT           NULL,
    [dt_usuario]         DATETIME      NULL,
    CONSTRAINT [PK_Desenho_Projeto] PRIMARY KEY CLUSTERED ([cd_projeto] ASC, [cd_desenho_projeto] ASC) WITH (FILLFACTOR = 90)
);

