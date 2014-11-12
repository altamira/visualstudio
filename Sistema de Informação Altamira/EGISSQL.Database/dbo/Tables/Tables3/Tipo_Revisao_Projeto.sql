CREATE TABLE [dbo].[Tipo_Revisao_Projeto] (
    [cd_tipo_revisao_projeto] INT          NOT NULL,
    [nm_tipo_revisao_projeto] VARCHAR (40) NULL,
    [sg_tipo_revisao_projeto] CHAR (10)    NULL,
    [cd_usuario]              INT          NULL,
    [dt_usuario]              DATETIME     NULL,
    CONSTRAINT [PK_Tipo_Revisao_Projeto] PRIMARY KEY CLUSTERED ([cd_tipo_revisao_projeto] ASC) WITH (FILLFACTOR = 90)
);

