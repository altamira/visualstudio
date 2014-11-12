CREATE TABLE [dbo].[Nivel_Suporte] (
    [cd_nivel_suporte]             INT          NOT NULL,
    [nm_nivel_suporte]             VARCHAR (40) NULL,
    [sg_nivel_suporte]             CHAR (10)    NULL,
    [cd_usuario]                   INT          NULL,
    [dt_usuario]                   DATETIME     NULL,
    [ic_comercial_nivel_suporte]   CHAR (1)     NULL,
    [ic_treinamento_nivel_suporte] CHAR (1)     NULL,
    [ic_engenharia_nivel_suporte]  CHAR (1)     NULL,
    CONSTRAINT [PK_Nivel_Suporte] PRIMARY KEY CLUSTERED ([cd_nivel_suporte] ASC) WITH (FILLFACTOR = 90)
);

