CREATE TABLE [dbo].[Tipo_Simulacao_Programacao] (
    [cd_tipo_simulacao_prog]  INT          NOT NULL,
    [nm_tipo_simulacao_prog]  VARCHAR (40) NULL,
    [sg_tipo_simulacao_prog]  CHAR (10)    NULL,
    [ic_atual_simulacao_prog] CHAR (1)     NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Simulacao_Programacao] PRIMARY KEY CLUSTERED ([cd_tipo_simulacao_prog] ASC) WITH (FILLFACTOR = 90)
);

