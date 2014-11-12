CREATE TABLE [dbo].[Prioridade_Suporte] (
    [cd_prioridade_suporte] INT          NOT NULL,
    [nm_prioridade_suporte] VARCHAR (40) NULL,
    [ds_prioridade_suporte] TEXT         NULL,
    [sg_prioridade_suporte] CHAR (10)    NULL,
    [qt_inicial_suporte]    INT          NULL,
    [qt_final_suporte]      INT          NULL,
    [nm_obs_prioridade]     VARCHAR (40) NULL,
    [cd_usuario]            INT          NULL,
    [dt_usuario]            DATETIME     NULL,
    CONSTRAINT [PK_Prioridade_Suporte] PRIMARY KEY CLUSTERED ([cd_prioridade_suporte] ASC) WITH (FILLFACTOR = 90)
);

