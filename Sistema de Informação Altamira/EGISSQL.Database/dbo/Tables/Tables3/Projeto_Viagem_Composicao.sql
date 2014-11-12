CREATE TABLE [dbo].[Projeto_Viagem_Composicao] (
    [cd_projeto_viagem]       INT          NOT NULL,
    [cd_item_projeto_viagem]  INT          NOT NULL,
    [cd_funcionario]          INT          NULL,
    [nm_obs_item_proj_viagem] VARCHAR (40) NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Projeto_Viagem_Composicao] PRIMARY KEY CLUSTERED ([cd_projeto_viagem] ASC, [cd_item_projeto_viagem] ASC) WITH (FILLFACTOR = 90)
);

