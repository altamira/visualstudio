CREATE TABLE [dbo].[Projeto_Padrao] (
    [cd_projeto_padrao]        INT          NOT NULL,
    [nm_projeto_padrao]        VARCHAR (50) NULL,
    [sg_projeto_padrao]        CHAR (15)    NULL,
    [cd_identificacao_projeto] VARCHAR (15) NULL,
    [dt_projeto_padrao]        DATETIME     NULL,
    [nm_obs_projeto_padrao]    VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    CONSTRAINT [PK_Projeto_Padrao] PRIMARY KEY CLUSTERED ([cd_projeto_padrao] ASC) WITH (FILLFACTOR = 90)
);

