CREATE TABLE [dbo].[Projeto_Comercial_Composicao] (
    [cd_projeto_comercial]       INT           NOT NULL,
    [cd_item_projeto_comercial]  INT           NOT NULL,
    [cd_projeto_componente]      INT           NOT NULL,
    [cd_item_projeto_componente] INT           NOT NULL,
    [ic_dado_projeto]            CHAR (1)      NULL,
    [nm_dado_projeto]            VARCHAR (100) NULL,
    [ds_dado_projeto]            TEXT          NULL,
    [nm_obs_item_projeto]        VARCHAR (40)  NULL,
    [qt_dado_projeto]            FLOAT (53)    NULL,
    [cd_usuario]                 INT           NULL,
    [dt_usuario]                 DATETIME      NULL,
    CONSTRAINT [PK_Projeto_Comercial_Composicao] PRIMARY KEY CLUSTERED ([cd_projeto_comercial] ASC, [cd_item_projeto_comercial] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Projeto_Comercial_Composicao_Projeto_Componente] FOREIGN KEY ([cd_projeto_componente]) REFERENCES [dbo].[Projeto_Componente] ([cd_projeto_componente])
);

