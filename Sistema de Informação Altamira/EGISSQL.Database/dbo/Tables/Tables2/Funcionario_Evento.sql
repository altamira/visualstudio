CREATE TABLE [dbo].[Funcionario_Evento] (
    [cd_funcionario]             INT          NOT NULL,
    [cd_evento]                  INT          NOT NULL,
    [vl_funcionario_evento]      FLOAT (53)   NULL,
    [pc_funcionario_evento]      FLOAT (53)   NULL,
    [nm_obs_funcionario_evento]  VARCHAR (40) NULL,
    [cd_usuario]                 INT          NULL,
    [dt_usuario]                 DATETIME     NULL,
    [qt_hora_funcionario_evento] FLOAT (53)   NULL,
    [cd_item_funcionario_evento] INT          NULL,
    [ic_ativo_calculo]           CHAR (1)     NULL,
    CONSTRAINT [PK_Funcionario_Evento] PRIMARY KEY CLUSTERED ([cd_funcionario] ASC, [cd_evento] ASC) WITH (FILLFACTOR = 90)
);

