CREATE TABLE [dbo].[Tarefa_Projeto] (
    [cd_tarefa_projeto]     INT          NOT NULL,
    [nm_tarefa_projeto]     VARCHAR (40) NULL,
    [sg_tarefa_projeto]     CHAR (10)    NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    [ic_apo_tarefa_projeto] CHAR (1)     NULL,
    [nm_obs_tarefa_projeto] VARCHAR (40) NULL,
    CONSTRAINT [PK_Tarefa_Projeto] PRIMARY KEY CLUSTERED ([cd_tarefa_projeto] ASC) WITH (FILLFACTOR = 90)
);

