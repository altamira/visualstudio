CREATE TABLE [dbo].[Tipo_Projeto_Viagem] (
    [cd_tipo_projeto_viagem] INT          NOT NULL,
    [nm_tipo_projeto_viagem] VARCHAR (30) NULL,
    [sg_tipo_projeto_viagem] CHAR (10)    NULL,
    [cd_usuario]             INT          NULL,
    [dt_usuario]             DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Projeto_Viagem] PRIMARY KEY CLUSTERED ([cd_tipo_projeto_viagem] ASC) WITH (FILLFACTOR = 90)
);

