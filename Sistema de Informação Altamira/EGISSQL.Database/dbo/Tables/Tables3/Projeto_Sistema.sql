CREATE TABLE [dbo].[Projeto_Sistema] (
    [cd_projeto_sistema]       INT          NOT NULL,
    [nm_projeto]               VARCHAR (40) NULL,
    [cd_identificacao_projeto] VARCHAR (20) NULL,
    [qt_hora_projeto_sistema]  FLOAT (53)   NULL,
    [qt_real_projeto_sistema]  FLOAT (53)   NULL,
    [cd_cliente]               INT          NULL,
    [ic_ativo_projeto]         CHAR (1)     NULL,
    [nm_obs_projeto_sistema]   VARCHAR (40) NULL,
    [cd_usuario]               INT          NULL,
    [dt_usuario]               DATETIME     NULL,
    [cd_cliente_sistema]       INT          NULL,
    [qt_hora_coord_projeto]    FLOAT (53)   NULL,
    [qt_hora_impl_projeto]     FLOAT (53)   NULL,
    [dt_inicial_projeto]       DATETIME     NULL,
    [dt_final_projeto]         DATETIME     NULL,
    [cd_consultor]             INT          NULL,
    CONSTRAINT [PK_Projeto_Sistema] PRIMARY KEY CLUSTERED ([cd_projeto_sistema] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK_Projeto_Sistema_Cliente] FOREIGN KEY ([cd_cliente]) REFERENCES [dbo].[Cliente] ([cd_cliente])
);

